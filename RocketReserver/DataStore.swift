//

import Foundation
import Combine
import Apollo

class ErrorStore: ObservableObject {
    @Published var showError: Bool = false
    @Published var message: String = ""
}

final class Cache<Key: Hashable, Value> {
    final class WrappedKey: NSObject {
        let key: Key
        init(_ key: Key) { self.key = key }

        override var hash: Int { key.hashValue }
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else { return false }
            return value.key == key
        }
    }

    final class Entry {
        let value: Value
        init(_ value: Value) { self.value = value }
    }

    deinit {
        wrapped.removeAllObjects()
    }

    private let wrapped = NSCache<WrappedKey, Entry>()

    func cache(_ value: Value, forKey key: Key) {
        wrapped.setObject(Entry(value), forKey: WrappedKey(key))
    }

    func get(forKey key: Key) -> Value? {
        return wrapped.object(forKey: WrappedKey(key))?.value
    }
}


class ImageCache {
    static var shared = ImageCache()

    private var cache: Cache<String, Data> = Cache()
    private var disposeBag: Set<AnyCancellable> = []

    func fetchImage(forUrl url: URL) -> AnyPublisher<Data, Never> {
        if let image = cache.get(forKey: url.absoluteString) {
            return Just(image).eraseToAnyPublisher()
        }

        let content = URLSession
            .shared
            .dataTaskPublisher(for: url)
            .map({ Optional.some($0.data) })
            .catch({ e -> Just<Data?> in
                print("Failed getting the image \(String(describing: e))")
                return Just(nil)
            })
            .share()

        content
            .filter({ $0 != nil })
            .sink(receiveCompletion: { _ in return },
                  receiveValue: { [weak self] data in
                    guard let self = self else { return }
                    self.cache.cache(data!, forKey: url.absoluteString)
            })
            .store(in: &disposeBag)

        return content.map({ $0 ?? Data() }).eraseToAnyPublisher()
    }
}

class DataStore: ObservableObject {
    @Published var launches = [LaunchBasicFragment]() // this graphql data definition is just stupid :|

    @Published var selectedLaunch: LaunchFragment? = nil

    @Published private var currentCursor: String? = nil
    @Published private var hasMore: Bool = true

    @Published var userEmail: String = ""
    @Published var authToken: String = ""

    let errors = ErrorStore()

    private var disposeBag: Set<AnyCancellable> = []
    private var backend: ApolloClient { Network.shared.spaceEndpoint }

    deinit {
        disposeBag.removeAll()
    }

    func fetchNextLaunchesPage() {
        if !hasMore { return }
        print("Fetching a page of results.")

        let queryResult = backend.fetchPublisher(query: LaunchListQuery(pageSize: 20, after: currentCursor))
            .share()

        queryResult
            .map({ _ in (false, "") })
            .catch({ e in Just((true, String(describing: e))) })
            .sink(receiveValue: { [weak self] analysis in
                guard let self = self else { return }
                if analysis.0 {
                    print("There was an error processing the fetch request.")
                }
                self.errors.showError = analysis.0
                self.errors.message = analysis.1
            })
            .store(in: &disposeBag)

        queryResult
            .catch({ _ in Just(nil) })
            .filter({ $0 != nil })
            .receive(on: RunLoop.main)
            .map({ $0!.launches })
            .sink(receiveValue: { [weak self] data in
                guard let self = self else { return }
                print("Fetch completed.")
                self.hasMore = data.hasMore
                self.currentCursor = data.cursor
                print("Cursor is: \(data.cursor)")
                let newLaunches = data.launches.compactMap({ $0 }).map({ $0.fragments.launchBasicFragment })
                self.launches.append(contentsOf: newLaunches)
                print("Total number of items fetched: \(self.launches.count)")
            }).store(in: &disposeBag)
    }

    func fetchDetails(launchId: String) {
        disposeBag.removeAll()

        backend
            .fetchPublisher(query: LaunchDetailsWithFragmentsQuery(launchId: launchId))
            .map({ $0?.launch?.fragments.launchFragment })
            .catch({ _ in Just(nil) })
            .receive(on: RunLoop.main)
            .assign(to: \.selectedLaunch, on: self)
            .store(in: &disposeBag)
    }

    func logIn(email: String) {
        let getToken = backend.performPublisher(mutation: LogMeInMutation(email: email))
            .map({ $0?.login })
            .catch({ _ -> Just<String?> in Just(nil) })
            .filter({ $0 != nil && $0 != "" })
            .map({ $0! })
            .share()

        getToken
            .sink(receiveValue: { [weak self] token in
                guard let self = self else { return }
                self.authToken = token
                Network.shared.networkPreflight.authToken = token
            }).store(in: &disposeBag)
    }

    func bookTrip(id: String) -> AnyPublisher<Int, Never> {
        return backend.performPublisher(mutation: BookingTripsMutation(ids: [ id ]))
            .map({ $0?.bookTrips.launches?.compactMap({ $0 }) ?? [] })
            .map({ $0.reduce(0) { $1.fragments.launchFragment.isBooked ? $0 + 1 : $0 }})
            .catch({ _ -> Just<Int> in Just(0) })
            .eraseToAnyPublisher()
    }
}
