//

import Foundation
import SwiftUI

struct LaunchListView: View {
    @EnvironmentObject var dataStore: DataStore
    @Binding var launches: [LaunchListQuery.Data.Launch.Launch]

    var body: some View {
        List {
            ForEach(launches) { item in
                NavigationLink(
                    destination: LaunchDetailsView(launchId: item.id)
                ) {
                    Text(item.site ?? "")
                }
            }
        }
    }
 }
