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
            MasterView(launches: $dataStore.launches)
                .navigationBarTitle(Text("Launches"))
                .navigationBarItems(
                    leading: EditButton(),
                    trailing: Button(
                        action: {
//                            withAnimation { self.dates.insert(Date(), at: 0) }
                        }
                    ) {
                        Image(systemName: "plus")
                    }
                )
            DetailView()
        }.onAppear {
            self.dataStore.loadLaunches() // this might be a problem later on...
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct MasterView: View {
    @Binding var launches: [LaunchListQuery.Data.Launch.Launch]

    var body: some View {
        List {
            ForEach(launches) { item in
                Text(item.site ?? "")
//                NavigationLink(
//                    destination: DetailView(selectedDate: date)
//                ) {
//                    Text("\(date, formatter: dateFormatter)")
//                }
            }.onDelete { indices in
//                indices.forEach { self.dates.remove(at: $0) }
            }
        }
    }
}

struct DetailView: View {
    var selectedDate: Date?

    var body: some View {
        Group {
            if selectedDate != nil {
                Text("\(selectedDate!, formatter: dateFormatter)")
            } else {
                Text("Detail view content goes here")
            }
        }.navigationBarTitle(Text("Detail"))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
