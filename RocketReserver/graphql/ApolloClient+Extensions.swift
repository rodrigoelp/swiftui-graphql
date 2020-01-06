//

import Foundation
import Combine
import Apollo

extension ApolloClient {
    func fetchPublisher<Query: GraphQLQuery>(query: Query) -> AnyPublisher<Query.Data?, Error> {
        return Future { [weak self] completion in
            self?.fetch(query: query) { result in
                completion(ApolloClient.unwrapResult(result))
            }
        }.eraseToAnyPublisher()
    }

    func performPublisher<Mutation: GraphQLMutation>(mutation: Mutation) -> AnyPublisher<Mutation.Data?, Error> {
        return Future { [weak self] completion in
            self?.perform(mutation: mutation) { result in
                completion(ApolloClient.unwrapResult(result))
            }
        }.eraseToAnyPublisher()
    }

    func subscribePublisher<Subscription: GraphQLSubscription>(subscription: Subscription) -> AnyPublisher<Subscription.Data?, Error> {
        return Future { [weak self] completion in
            self?.subscribe(subscription: subscription) { result in
                completion(ApolloClient.unwrapResult(result))
            }
        }.eraseToAnyPublisher()
    }

    private static func unwrapResult<T>(_ graphResult: Result<GraphQLResult<T>, Error>) -> Result<T?, Error> {
        return graphResult
            .map({ r in
                r.errors?.forEach({
                    print("Detected partial results with errors.")
                    print(String(describing: $0))
                })
                return r.data
            })
    }
}
