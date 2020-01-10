import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataStore: DataStore

    var body: some View {
        if dataStore.authToken != "" {
            return AnyView(LoggedInContentView())
        } else {
            return AnyView(LoginView())
        }
    }
}

struct LoggedInContentView: View {
    @EnvironmentObject var dataStore: DataStore
    @EnvironmentObject var errorStore: ErrorStore

    var body: some View {
        NavigationView {
            LaunchListView(launches: $dataStore.launches)
                .navigationBarTitle(Text("Launches"))
                .navigationBarItems(trailing: Button(action: { self.dataStore.showMessages = true }, label: { Text("Messages") }))
            LaunchDetailsView(launchId: nil, viewModel: LaunchDetailsViewModel(id: nil, dataStore: self.dataStore))
        }.onAppear {
            self.dataStore.fetchNextLaunchesPage() // this might be a problem later on...
        }.alert(isPresented: $errorStore.showError,
                content: { Alert(title: Text("Oops"), message: Text(self.errorStore.message)) })
            .sheet(isPresented: $dataStore.showMessages, content: {
                LaunchMessageListView(viewModel: MessageListViewModel(self.dataStore))
            })
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DataStore())
    }
}
