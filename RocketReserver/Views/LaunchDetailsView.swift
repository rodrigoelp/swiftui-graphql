//

import Foundation
import SwiftUI
import Combine

struct LaunchDetailsView: View {
    @EnvironmentObject var dataStore: DataStore
    @State var operation: String = ""
    @State private var disposeBag: Set<AnyCancellable> = []

    let launchId: String?

    init(launchId: String?) {
        self.launchId = launchId
    }

    var body: some View {
        Group {
            if dataStore.selectedLaunch?.id != nil {
                VStack {
                    MissionDetailsView(launch: dataStore.selectedLaunch!)

                    Button(action: self.bookTrip, label: { Text("Book Now!") })

                    Text(operation)
                }
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

    func bookTrip() {
        guard let id = launchId else { return }
        dataStore.bookTrip(id: id)
            .map({ "This mission has been booked \($0) times" })
            .assign(to: \.operation, on: self)
            .store(in: &disposeBag)
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
                .map({ NetworkImage(url: $0).frame(width: 150, height: 140, alignment: .center) })

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
        ImageCache.shared
            .fetchImage(forUrl: url)
            .tryMap({
                print(String(describing: $0))
                guard let image = UIImage(data: $0) else {
                    throw ImageResolverError.invalid
                }
                return Image(uiImage: image).resizable()
            })
            .catch({ e -> Just<Image> in
                return Just(Image(systemName: "livephoto"))
            })
            .receive(on: RunLoop.main)
            .assign(to: \.image, on: self)
            .store(in: &disposeBag)
    }
}
