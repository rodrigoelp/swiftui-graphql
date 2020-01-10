//

import Foundation
import SwiftUI
import Combine

class LaunchDetailsViewModel: ObservableObject {
    private var disposedBag: Set<AnyCancellable> = []

    let launchId: String?
    @Published var details: Details? = nil
    @Published var seatsBooked = 0

    let dataStore: DataStore

    init(id: String?, dataStore: DataStore) {
        launchId = id
        self.dataStore = dataStore
    }

    deinit {
        disposedBag.removeAll()
    }

    func load() {
        guard let id = launchId else { return }

        disposedBag.removeAll()

        let detailsPublisher = dataStore
            .fetchDetailsPublisher(launchId: id)
            .catch({ _ -> Just<LaunchFragment?> in Just(nil) })
            .filter({ $0 != nil })
            .receive(on: RunLoop.main)
            .share()

        detailsPublisher
            .map({ l -> Details? in
                guard let launch = l,
                    let missionFragment = launch.mission?.fragments.missionFragment,
                    let patchUrl = missionFragment.missionPatch.flatMap({ URL(string: $0) }),
                    let name = missionFragment.name,
                    let site = launch.site
                    else {
                        return nil
                }
                return Details(missionPatch: patchUrl, missionName: name, site: site)
            })
            .assign(to: \.details, on: self)
            .store(in: &disposedBag)

        detailsPublisher
            .map({ $0?.pax ?? 0 })
            .assign(to: \.seatsBooked, on: self)
            .store(in: &disposedBag)

        dataStore.listen()

//        dataStore.listenToBookingsDoneFor(launchId: id)
//            .map({ $0?.pax })
//            .map({
//                $0 ?? 0
//            })
//            .receive(on: RunLoop.main)
//            .assign(to: \.seatsBooked, on: self)
//            .store(in: &disposedBag)
    }

    func bookTrip() {
        guard let id = launchId else { return }

        dataStore.bookTrip(id: id)
            .assign(to: \.seatsBooked, on: self)
            .store(in: &disposedBag)
    }

    func stop() {
        dataStore.flush()
    }

    struct Details {
        let missionPatch: URL
        let missionName: String
        let site: String
    }
}

struct LaunchDetailsView: View {
    @EnvironmentObject var dataStore: DataStore
    @ObservedObject var viewModel: LaunchDetailsViewModel
    let launchId: String?

    init(launchId: String?, viewModel: LaunchDetailsViewModel) {
        self.launchId = launchId
        self.viewModel = viewModel
    }

    var body: some View {
        Group {
            if launchId != nil {
                VStack {
                    Spacer()
                    MissionDetailsView(viewModel: self.viewModel)

                    Button(action: self.viewModel.bookTrip, label: { Text("Book Now!") })
                    Spacer()
                }
            } else {
                Text("Select a launch to view details.")
            }
        }.onAppear(perform: {
            self.viewModel.load()
        }).onDisappear(perform: { self.viewModel.stop() })
            .navigationBarTitle(Text("Launch Details"))
    }
}

struct MissionDetailsView: View {
    @ObservedObject var viewModel: LaunchDetailsViewModel

    var body: some View {
        VStack {
            viewModel.details.map({
                NetworkImage(url: $0.missionPatch)
                    .frame(width: 150, height: 150, alignment: .center)
            })
            VStack {
                Text("Launch Number: \(viewModel.launchId!)")
                Text(viewModel.details.map { "Name: \($0.missionName)" } ?? "Nameless mission")
                Text(viewModel.details.map { "Site: \($0.site)" } ?? "Site not specified")
                Text(viewModel.seatsBooked > 0 ? "\(viewModel.seatsBooked) seated" : "No seats taken")
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
        resolver.image
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
