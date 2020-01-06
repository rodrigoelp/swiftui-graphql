//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class ListenToBookingsSubscription: GraphQLSubscription {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    subscription ListenToBookings {
      tripBooked {
        __typename
        id
      }
    }
    """

  public let operationName = "ListenToBookings"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("tripBooked", type: .nonNull(.object(TripBooked.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(tripBooked: TripBooked) {
      self.init(unsafeResultMap: ["__typename": "Subscription", "tripBooked": tripBooked.resultMap])
    }

    public var tripBooked: TripBooked {
      get {
        return TripBooked(unsafeResultMap: resultMap["tripBooked"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "tripBooked")
      }
    }

    public struct TripBooked: GraphQLSelectionSet {
      public static let possibleTypes = ["LaunchReference"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID) {
        self.init(unsafeResultMap: ["__typename": "LaunchReference", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}
