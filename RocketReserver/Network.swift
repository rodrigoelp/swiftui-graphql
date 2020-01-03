//

import Foundation
import Apollo
import ApolloSQLite

class Network {
    private let endpoint = URL(string: "https://n1kqy.sse.codesandbox.io/graphql")!
//    private let endpoint = URL(string: "http://localhost:4000/graphql")! // switching to a local server for fun.
    static let shared = Network()

    private(set) lazy var spaceEndpoint = Network.createClient(url: endpoint, dbName: "local-cache.sqlite")

    private static func createClient(url: URL, dbName: String) -> ApolloClient {
        let httpTransport = HTTPNetworkTransport(url: url)
        let dbUrl = try! FileManager.default.url(for: .documentDirectory,
                                                 in: .userDomainMask,
                                                 appropriateFor: nil,
                                                 create: false)
            .appendingPathComponent(dbName)
        let cache = try! SQLiteNormalizedCache(fileURL: dbUrl)
        let store = ApolloStore(cache: cache)
        let client = ApolloClient(networkTransport: httpTransport, store: store)
        client.cacheKeyForObject = { $0["id"] }
        return client
    }
}
