//

import SwiftUI
import Combine
import Apollo

typealias GraphQLCancellable = Apollo.Cancellable

class MessageListViewModel: ObservableObject {
    let dataStore: DataStore

    private var disposeBag: Set<AnyCancellable> = []

    @Published var cursor: String? = nil
    @Published var messages = [MessageFragment]()
    @Published var newMessage = ""

    var subscription: GraphQLCancellable? = nil

    init(_ dataStore: DataStore) {
        self.dataStore = dataStore
        self.setup()
    }

    deinit {
        subscription?.cancel()
        disposeBag.removeAll()
    }

    private func setup() {
        dataStore.fetchMessagesPage(cursor: nil)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] input in
                guard let self = self,
                    let data = input else { return }
                self.messages = data.messages
                    .map({ $0?.fragments.messageFragment })
                    .compactMap({ $0 })
            }).store(in: &disposeBag)

        let client = Network.shared.spaceEndpoint
        client.publisher(for: ListenForMessagesSubscription())
            .asPureResult()
            .map({ $0.postedMessages.fragments.messageFragment })
            .catch({ e -> Just<MessageFragment?> in
                print("Detected an error with the messages... \(String(describing: e))")
                return Just(nil)
            }).sink(receiveValue: { [weak self] in
                guard let fragment = $0, let self = self else { return }
                self.messages.append(fragment)
            }).store(in: &disposeBag)
    }

    func postMessage() {
        self.dataStore.postMessage(newMessage)
            .sink { (fragment: MessageFragment?) in
                if fragment != nil {
                    print("Posted!")
                }
        }.store(in: &disposeBag)
    }
}

struct LaunchMessageListView: View {
    @ObservedObject var viewModel: MessageListViewModel

    var body: some View {
        VStack {
            HStack {
                Group {
                    TextField("", text: $viewModel.newMessage).padding(.all, 2)
                }.border(Color(red: 0.9, green: 0.9, blue: 0.9), width: 1).cornerRadius(4)
                    .padding(.horizontal, 4)
                Button(action: viewModel.postMessage, label: { Text("Post") })
            }.padding()
            List(viewModel.messages) { (item: MessageFragment) in
                VStack {
                    Text(item.message)
                }
            }
        }
    }
}
