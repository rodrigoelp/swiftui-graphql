//

import Foundation
import Combine
import Apollo

extension ApolloClient {
    func fetchAsync<Query: GraphQLQuery>(query: Query) -> AnyPublisher<Query.Data?, Error> {
        return Future { [weak self] completion in
            guard let self = self else { return }

            self.fetch(query: query) { result in
                switch result {
                    case .success(let set):
                        if let partialErrors = set.errors {
                            print("Detected some partial results, but the server returned errors as well")
                            partialErrors.forEach {
                                print(String(describing: $0))
                            }
                        }
                        completion(.success(set.data))
                    case .failure(let e):
                        completion(.failure(e))
                }
            }
        }.eraseToAnyPublisher()
    }
}
