//

import Foundation
import SwiftUI
import Combine

struct LaunchDetailsView: View {
    @EnvironmentObject var dataStore: DataStore
    let launchId: String?

    @State var imageContent: Data = Data()

    init(launchId: String?) {
        self.launchId = launchId
    }

    var body: some View {
        Group {
            if dataStore.selectedLaunch?.id != nil {
                MissionDetailsView(launch: dataStore.selectedLaunch!)
            } else {
                Text("Select a launch to view details.")
            }
        }.onAppear(perform: {
            if let launchId = self.launchId {
                self.dataStore
                    .fetchDetails(launchId: launchId)
            }
        })
            .navigationBarTitle(Text("Launch Details"))
    }
}

struct MissionDetailsView: View {
    let launch: LaunchFragment

    var body: some View {
        HStack {
            launch.mission?
                .fragments
                .missionFragment
                .missionPatch
                .flatMap({ URL(string: $0) })
                .map({ NetworkImage(url: $0) })

            VStack {
                Text(launch.mission?.fragments.missionFragment.name ?? "No mission name")

                Text("ID: \(launch.id)")
                Text(launch.site.map { "Site: \($0)" } ?? "Site without a name")
            }
        }
    }
}

struct NetworkImage: View {
    let url: URL
    @ObservedObject private var resolver: NetworkImageResolver

    init(url: URL) {
        self.url = url
        resolver = NetworkImageResolver()
        resolver.load(url: url)
    }

    var body: some View {
        Group {
            resolver.image
        }
    }
}

enum ImageResolverError: Error {
    case invalid
}

class NetworkImageResolver: ObservableObject {
    private var disposeBag: Set<AnyCancellable> = []

    @Published var image: Image = Image(systemName: "photo")

    deinit {
        disposeBag.removeAll()
    }

    func load(url: URL) {
        print(url)
        ImageCache.shared
            .fetchImage(forUrl: url)
            .tryMap({
                print(String(describing: $0))
                guard let image = UIImage(data: $0) else {
                    throw ImageResolverError.invalid
                }
                print("provided image...")
                return Image(uiImage: image)
            })
            .catch({ e -> Just<Image> in
                print("Failed getting the image \(String(describing: e))")
                return Just(Image(systemName: "livephoto"))
            })
            .receive(on: RunLoop.main)
            .assign(to: \.image, on: self)
            .store(in: &disposeBag)
    }
}
