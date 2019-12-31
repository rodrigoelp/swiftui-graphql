//

import Foundation
import Combine
import Apollo

class DataStore: ObservableObject {
    @Published var launches = [LaunchListQuery.Data.Launch.Launch]() // this graphql data definition is just stupid :|

    @Published var selectedLaunch: LaunchDetailsQuery.Data.Launch? = nil

    private var disposeBag: Set<AnyCancellable> = []
    private var backend: ApolloClient {
        Network.shared.apollo
    }

    deinit {
        disposeBag.removeAll()
    }

    func loadLaunches() {
        backend
            .fetch(query: LaunchListQuery()) { [weak self] result in
                guard let self = self else { return }
                switch result {
                    case .success(let data):
                        guard let d = data.data else { return }
                        DispatchQueue.main
                            .async {
                                self.launches.append(contentsOf: d.launches.launches.compactMap({ $0 }))
                    }
                    case .failure(let e):
                        print("MASSIVE FAILURE HERE!!!: \(String(describing: e))")
                }
        }
    }

    func fetchDetails(launchId: String) {
        backend
            .fetchAsync(query: LaunchDetailsQuery(launchId: launchId))
            .map({ $0?.launch })
            .catch({ _ in Just(nil) })
            .receive(on: RunLoop.main)
            .assign(to: \.selectedLaunch, on: self)
            .store(in: &disposeBag)
    }
}
