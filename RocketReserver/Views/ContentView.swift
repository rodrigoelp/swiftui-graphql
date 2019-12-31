//

import SwiftUI

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()

struct ContentView: View {
    @EnvironmentObject var dataStore: DataStore

    var body: some View {
        NavigationView {
            LaunchListView(launches: $dataStore.launches)
                .navigationBarTitle(Text("Launches"))
            LaunchDetailsView(launchId: nil)
        }.onAppear {
            self.dataStore.loadLaunches() // this might be a problem later on...
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
