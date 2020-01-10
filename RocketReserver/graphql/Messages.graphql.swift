//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class MessageListQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query MessageList($pageSize: Int! = 20, $after: String) {
      passengerMessages(pageSize: $pageSize, after: $after) {
        __typename
        messages {
          __typename
          ...MessageFragment
        }
      }
    }
    """

  public let operationName = "MessageList"

  public var queryDocument: String { return operationDefinition.appending(MessageFragment.fragmentDefinition) }

  public var pageSize: Int
  public var after: String?

  public init(pageSize: Int, after: String? = nil) {
    self.pageSize = pageSize
    self.after = after
  }

  public var variables: GraphQLMap? {
    return ["pageSize": pageSize, "after": after]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("passengerMessages", arguments: ["pageSize": GraphQLVariable("pageSize"), "after": GraphQLVariable("after")], type: .object(PassengerMessage.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(passengerMessages: PassengerMessage? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "passengerMessages": passengerMessages.flatMap { (value: PassengerMessage) -> ResultMap in value.resultMap }])
    }

    public var passengerMessages: PassengerMessage? {
      get {
        return (resultMap["passengerMessages"] as? ResultMap).flatMap { PassengerMessage(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "passengerMessages")
      }
    }

    public struct PassengerMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["PassengerMessageConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("messages", type: .nonNull(.list(.object(Message.selections)))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(messages: [Message?]) {
        self.init(unsafeResultMap: ["__typename": "PassengerMessageConnection", "messages": messages.map { (value: Message?) -> ResultMap? in value.flatMap { (value: Message) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var messages: [Message?] {
        get {
          return (resultMap["messages"] as! [ResultMap?]).map { (value: ResultMap?) -> Message? in value.flatMap { (value: ResultMap) -> Message in Message(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Message?) -> ResultMap? in value.flatMap { (value: Message) -> ResultMap in value.resultMap } }, forKey: "messages")
        }
      }

      public struct Message: GraphQLSelectionSet {
        public static let possibleTypes = ["PassengerMessage"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(MessageFragment.self),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, userId: GraphQLID, message: String) {
          self.init(unsafeResultMap: ["__typename": "PassengerMessage", "id": id, "userId": userId, "message": message])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var messageFragment: MessageFragment {
            get {
              return MessageFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }
}

public final class SaveMessageMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation SaveMessage($message: String!) {
      addMessage(message: $message) {
        __typename
        ...MessageFragment
      }
    }
    """

  public let operationName = "SaveMessage"

  public var queryDocument: String { return operationDefinition.appending(MessageFragment.fragmentDefinition) }

  public var message: String

  public init(message: String) {
    self.message = message
  }

  public var variables: GraphQLMap? {
    return ["message": message]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("addMessage", arguments: ["message": GraphQLVariable("message")], type: .object(AddMessage.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(addMessage: AddMessage? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "addMessage": addMessage.flatMap { (value: AddMessage) -> ResultMap in value.resultMap }])
    }

    public var addMessage: AddMessage? {
      get {
        return (resultMap["addMessage"] as? ResultMap).flatMap { AddMessage(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "addMessage")
      }
    }

    public struct AddMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["PassengerMessage"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(MessageFragment.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, userId: GraphQLID, message: String) {
        self.init(unsafeResultMap: ["__typename": "PassengerMessage", "id": id, "userId": userId, "message": message])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var messageFragment: MessageFragment {
          get {
            return MessageFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class ListenForMessagesSubscription: GraphQLSubscription {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    subscription ListenForMessages {
      postedMessages {
        __typename
        ...MessageFragment
      }
    }
    """

  public let operationName = "ListenForMessages"

  public var queryDocument: String { return operationDefinition.appending(MessageFragment.fragmentDefinition) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("postedMessages", type: .nonNull(.object(PostedMessage.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(postedMessages: PostedMessage) {
      self.init(unsafeResultMap: ["__typename": "Subscription", "postedMessages": postedMessages.resultMap])
    }

    public var postedMessages: PostedMessage {
      get {
        return PostedMessage(unsafeResultMap: resultMap["postedMessages"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "postedMessages")
      }
    }

    public struct PostedMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["PassengerMessage"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(MessageFragment.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, userId: GraphQLID, message: String) {
        self.init(unsafeResultMap: ["__typename": "PassengerMessage", "id": id, "userId": userId, "message": message])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var messageFragment: MessageFragment {
          get {
            return MessageFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public struct MessageFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment MessageFragment on PassengerMessage {
      __typename
      id
      userId
      message
    }
    """

  public static let possibleTypes = ["PassengerMessage"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("userId", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("message", type: .nonNull(.scalar(String.self))),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, userId: GraphQLID, message: String) {
    self.init(unsafeResultMap: ["__typename": "PassengerMessage", "id": id, "userId": userId, "message": message])
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

  public var userId: GraphQLID {
    get {
      return resultMap["userId"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "userId")
    }
  }

  public var message: String {
    get {
      return resultMap["message"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "message")
    }
  }
}
