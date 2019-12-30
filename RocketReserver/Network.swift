//

import Foundation
import Apollo

class Network {
//    private let endpoint = URL(string: "https://n1kqy.sse.codesandbox.io/graphql")!
    private let endpoint = URL(string: "http://localhost:4000/graphql")! // switching to a local server for fun.
    static let shared = Network()

    private(set) lazy var apollo = ApolloClient(url: endpoint)
}
