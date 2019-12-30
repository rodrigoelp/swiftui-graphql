//

import Foundation

class DataStore: ObservableObject {
    @Published var launches = [LaunchListQuery.Data.Launch.Launch]() // this graphql data definition is just stupid :|

    func loadLaunches() {
        Network.shared.apollo
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
}
