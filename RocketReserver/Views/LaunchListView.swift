//

import SwiftUI

struct LaunchListView: View {
    @EnvironmentObject var dataStore: DataStore
    @Binding var launches: [LaunchBasicFragment]

    var body: some View {
        List {
            ForEach(launches) { item in
                NavigationLink(
                    destination: LaunchDetailsView(launchId: item.id,
                                                   viewModel: LaunchDetailsViewModel(id: item.id,
                                                                                     dataStore: self.dataStore))
                ) {
                    Text(self.getLaunchName(item))
                }.onAppear(perform: { self.itemPresented(item) })
            }
        }
    }

    private func itemPresented(_ item: LaunchBasicFragment) {
        if launches.firstIndex(where: { $0.id == item.id }) == (launches.count - 1) {
            // needs to fetch more items.
            dataStore.fetchNextLaunchesPage()
        }
    }

    private func getLaunchName(_ data: LaunchBasicFragment) -> String {
        guard let site = data.site else {
            return "Host of Launch \(data.id)"
        }
        return "\(site) for launch \(data.id)"
    }
 }
