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
    @EnvironmentObject var errorStore: ErrorStore

    var body: some View {
        NavigationView {
            LaunchListView(launches: $dataStore.launches)
                .navigationBarTitle(Text("Launches"))
            LaunchDetailsView(launchId: nil)
        }.onAppear {
            self.dataStore.fetchNextLaunchesPage() // this might be a problem later on...
        }.alert(isPresented: $errorStore.showError,
                content: { Alert(title: Text("Oops"), message: Text(self.errorStore.message)) })
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
