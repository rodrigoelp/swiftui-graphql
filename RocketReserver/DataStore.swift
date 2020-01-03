//

import Foundation
import Combine
import Apollo

class ErrorStore: ObservableObject {
    @Published var showError: Bool = false
    @Published var message: String = ""
}

class DataStore: ObservableObject {
    @Published var launches = [LaunchBasicFragment]() // this graphql data definition is just stupid :|

    @Published var selectedLaunch: LaunchFragment? = nil

    @Published private var currentCursor: String? = nil
    @Published private var hasMore: Bool = true

    let errors = ErrorStore()

    private var disposeBag: Set<AnyCancellable> = []
    private var backend: ApolloClient {
        Network.shared.spaceEndpoint
    }

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

    func logIn() {
        backend.perform(mutation: LogMeInMutation(email: "freq@aa.com")) { result in
            switch result {
                case .success(let d):
                    print(d)
                case .failure(let e):
                    print(e)
            }
        }
    }
}
