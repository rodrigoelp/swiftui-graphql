//

import Foundation
import Combine
import Apollo

extension ApolloClient {
    func fetchPublisher<Query: GraphQLQuery>(query: Query) -> AnyPublisher<Query.Data?, Error> {
        return Future { [weak self] completion in
            guard let self = self else { return }

            self.fetch(query: query) { result in
                completion(ApolloClient.unwrapResult(result))
            }
        }.eraseToAnyPublisher()
    }

    func performPublisher<Mutation: GraphQLMutation>(mutation: Mutation) -> AnyPublisher<Mutation.Data?, Error> {
        return Future { [weak self] completion in
            guard let self = self else { return }
            self.perform(mutation: mutation) { result in
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
