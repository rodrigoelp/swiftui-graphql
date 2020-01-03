//

import Foundation
import SwiftUI
import Combine

struct LaunchDetailsView: View {
    @EnvironmentObject var dataStore: DataStore
    let launchId: String?

    var body: some View {
        Group {
            if dataStore.selectedLaunch?.id != nil {
                HStack {

                    dataStore.selectedLaunch!
                        .mission?
                        .fragments
                        .missionFragment
                        .missionPatch
                        .flatMap({ URL(string: $0) })
                        .map({ NetworkImage(url: $0) })

                    VStack {
                        Text(dataStore.selectedLaunch!.mission?.fragments.missionFragment.name ?? "No mission name")

                        Text("ID: \(dataStore.selectedLaunch!.id)")
                        Text(dataStore.selectedLaunch!.site.map { "Site: \($0)" } ?? "Site without a name")
                    }
                }
            } else {
                Text("Select a launch to view details.")
            }
        }.onAppear(perform: {
            if let launchId = self.launchId {
                self.dataStore
                    .fetchDetails(launchId: launchId)
            }
        }).navigationBarTitle(Text("Launch Details"))
    }
}

struct NetworkImage: View {
    let url: URL
    @ObservedObject private var resolver = NetworkImageResolver()

    var body: some View {
        Group {
            resolver.content
                .map { UIImage(data: $0)! }
                .map { Image(uiImage: $0 ) }
                ?? Image(systemName: "livephoto")
        }.onAppear(perform: { self.resolver.load(url: self.url) })
    }
}

class NetworkImageResolver: ObservableObject {
    @Published var content: Data? = nil

    private var disposeBag: Set<AnyCancellable> = []

    func load(url: URL) {
        print(url)
        URLSession
            .shared
            .dataTaskPublisher(for: url)
            .map({ Optional.some($0.data) })
            .catch({ e -> Just<Data?> in
                print("Failed getting the image \(String(describing: e))")
                return Just(nil)
            })
            .receive(on: RunLoop.main)
            .assign(to: \.content, on: self)
            .store(in: &disposeBag)
    }

    deinit {
        disposeBag.removeAll()
    }
}
