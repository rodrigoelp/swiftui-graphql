//

import Foundation
import Apollo
import ApolloWebSocket
import ApolloSQLite

class Network {
    private static let httpEndpoint = URL(string: "https://n1kqy.sse.codesandbox.io/graphql")!
    // You will need to host your own version and enable the subscriptions to get this endpoint to work.
    // I am not exposing mine as I am not sure it will exist for a long period of time.
    private static let webSocketEndpoint = URL(string: "wss://n1kqy.sse.codesandbox.io/graphql")!

    private(set) static var shared = Network()
    private(set) var spaceEndpoint: ApolloClient = createDefaultClient()
    static let cacheName = "local-cache.sqlite"

    private static func createDefaultClient() -> ApolloClient {
        return ApolloClient(networkTransport: HTTPNetworkTransport(url: Network.httpEndpoint))
    }

    static func reconfigure(withToken token: String, cachingOn dbName: String = cacheName) {
        shared.spaceEndpoint = createClient(withToken: token, cachingOn: dbName)
    }

    static func createClient(withToken token: String, cachingOn dbName: String = cacheName) -> ApolloClient {
        let store = createStoreCache(named: dbName)
        let uploadTransport = createUploadTransport(with: token)
        let subscriptionTransport = createNotificationTransport(with: token)
        let transport = SplitNetworkTransport(httpNetworkTransport: uploadTransport,
                                                   webSocketNetworkTransport: subscriptionTransport)
        let client = ApolloClient(networkTransport: transport, store: store)
        client.cacheKeyForObject = { $0["id"] }
        return client
    }

    private static func createStoreCache(named name: String) -> ApolloStore {
        let dbUrl = try! FileManager.default.url(for: .documentDirectory,
                                                 in: .userDomainMask,
                                                 appropriateFor: nil,
                                                 create: false)
            .appendingPathComponent(name)
        let cache = try! SQLiteNormalizedCache(fileURL: dbUrl)
        return ApolloStore(cache: cache)
    }

    private static func createUploadTransport(with token: String) -> HTTPNetworkTransport {
        let interceptor = HttpTransportRequestInterceptor(authToken: token)
        return HTTPNetworkTransport(url: httpEndpoint,
                                                   delegate: interceptor)
    }

    private static func createNotificationTransport(with token: String) -> WebSocketTransport {
        let wsRequest = URLRequest(url: webSocketEndpoint)
        let authPayload = ["authorization": token, "authToken": token]
        return WebSocketTransport(request: wsRequest, connectingPayload: authPayload)
    }
}

class HttpTransportRequestInterceptor: HTTPNetworkTransportPreflightDelegate {
    let authToken: String

    init(authToken: String) {
        self.authToken = authToken
    }

    func networkTransport(_ networkTransport: HTTPNetworkTransport, shouldSend request: URLRequest) -> Bool {
        return true
    }

    func networkTransport(_ networkTransport: HTTPNetworkTransport, willSend request: inout URLRequest) {
        request.setValue(authToken, forHTTPHeaderField: "authToken")
        request.setValue(authToken, forHTTPHeaderField: "authorization")
    }
}
