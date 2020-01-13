//

import Foundation
import Combine
import Apollo
import ApolloPublishers

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

typealias GraphCancellable = Apollo.Cancellable

class DataStore: ObservableObject {
    @Published var launches = [LaunchBasicFragment]() // this graphql data definition is just stupid :|

    @Published var selectedLaunch: LaunchFragment? = nil

    @Published private var launchesCurrentCursor: String? = nil
    @Published private var hasMoreLaunches: Bool = true

    @Published var userEmail: String = ""
    @Published var authToken: String = ""

    @Published var showMessages = false

    let errors = ErrorStore()

    private var disposeBag: Set<AnyCancellable> = []
    private var backend: ApolloClient { Network.shared.spaceEndpoint }

    private var subscriptions = [GraphCancellable]()

    deinit {
        disposeBag.removeAll()
    }

    func fetchNextLaunchesPage() {
        if !hasMoreLaunches { return }
        print("Fetching a page of results.")

        let queryResult = backend.fetchPublisher(query: LaunchListQuery(pageSize: 20, after: launchesCurrentCursor))
            .asPureResult()
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
            .receive(on: RunLoop.main)
            .map({ $0.launches })
            .map(Optional.some)
            .catch({ _ in Just(nil) })
            .sink(receiveValue: { [weak self] d in
                guard let self = self,
                    let data = d else { return }
                print("Fetch completed.")
                self.hasMoreLaunches = data.hasMore
                self.launchesCurrentCursor = data.cursor
                print("Cursor is: \(data.cursor)")
                let newLaunches = data.launches.compactMap({ $0 }).map({ $0.fragments.launchBasicFragment })
                self.launches.append(contentsOf: newLaunches)
                print("Total number of items fetched: \(self.launches.count)")
            }).store(in: &disposeBag)
    }

    func fetchDetailsPublisher(launchId: String) -> AnyPublisher<LaunchFragment?, Error> {
        backend
            .fetchPublisher(query: LaunchDetailsWithFragmentsQuery(launchId: launchId))
            .asPureResult()
            .map({ $0.launch?.fragments.launchFragment })
            .eraseToAnyPublisher()
    }

    func fetchDetails(launchId: String) {
        disposeBag.removeAll()

        fetchDetailsPublisher(launchId: launchId)
            .catch({ _ in Just(nil) })
            .receive(on: RunLoop.main)
            .assign(to: \.selectedLaunch, on: self)
            .store(in: &disposeBag)
    }

    func logIn(email: String) {
        backend
            .performPublisher(mutation: LogMeInMutation(email: email))
            .asPureResult()
            .map({ $0.login })
            .catch({ _ -> Just<String?> in Just(nil) })
            .filter({ $0 != nil && $0 != "" })
            .map({ $0! })
            .sink(receiveValue: { [weak self] token in
                guard let self = self else { return }
                self.authToken = token
                Network.reconfigure(withToken: token)
            }).store(in: &disposeBag)
    }

    func bookTrip(id: String) -> AnyPublisher<Int, Never> {
        return backend
            .performPublisher(mutation: BookingTripsMutation(ids: [id]))
            .asPureResult()
            .map({ $0.bookTrips.launches?.compactMap({ $0 }) ?? [] })
            .map({ $0.reduce(0, { $1.fragments.launchFragment.isBooked ? $0 + 1 : $0 }) })
            .catch({ _ -> Just<Int> in Just(0) })
            .eraseToAnyPublisher()
    }

    func fetchMessagesPage(cursor: String?) -> AnyPublisher<MessageListQuery.Data.PassengerMessage?, Never> {
        return backend.fetchPublisher(query: MessageListQuery(pageSize: 20, after: cursor), cachePolicy: .returnCacheDataElseFetch)
            .asPureResult()
            .map({ $0.passengerMessages })
            .catch({ _ -> Just<MessageListQuery.Data.PassengerMessage?> in Just(nil) })
            .filter({ $0 != nil })
            .eraseToAnyPublisher()
    }

    func postMessage(_ msg: String) -> AnyPublisher<MessageFragment?, Never> {
        return backend.performPublisher(mutation: SaveMessageMutation(message: msg))
        .asPureResult()
            .map({ $0.addMessage?.fragments.messageFragment })
            .catch({ _ -> Just<MessageFragment?> in Just(nil) })
            .eraseToAnyPublisher()
    }

    func flush() {
        self.subscriptions.forEach({ $0.cancel() })
        self.subscriptions.removeAll()
    }

    func listen() {
        let subs = backend.subscribe(subscription: ListenToBookingsSubscription()) { result in
            print(result)
        }

        self.subscriptions.append(subs)
    }

    func listenToBookigs() -> AnyPublisher<String?, Never> {
        return backend.publisher(for: ListenToBookingsSubscription())
            .asPureResult()
            .map({ $0.tripBooked.id })
            .catch({ _ -> Just<String?> in Just(nil) })
            .eraseToAnyPublisher()
    }

    func listenToBookingsDoneFor(launchId: String) -> AnyPublisher<LaunchFragment?, Never> {
        return self.listenToBookigs()
            .filter({
                $0 == launchId
            })
            .flatMap({ id -> AnyPublisher<LaunchFragment?, Never> in
                guard let _id = id else { return Just(nil).eraseToAnyPublisher() }
                return self.fetchDetailsPublisher(launchId: _id)
                    .catch({ _ -> Just<LaunchFragment?> in Just(nil) })
                    .eraseToAnyPublisher()
            })
            .eraseToAnyPublisher()
    }
}
