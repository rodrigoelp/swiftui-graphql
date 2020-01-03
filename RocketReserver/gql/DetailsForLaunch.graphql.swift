//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class LaunchDetailsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query LaunchDetails($launchId: ID!) {
      launch(id: $launchId) {
        __typename
        id
        site
        isBooked
        mission {
          __typename
          name
          missionPatch(size: SMALL)
        }
        rocket {
          __typename
          id
          name
          type
        }
      }
    }
    """

  public let operationName = "LaunchDetails"

  public var launchId: GraphQLID

  public init(launchId: GraphQLID) {
    self.launchId = launchId
  }

  public var variables: GraphQLMap? {
    return ["launchId": launchId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("launch", arguments: ["id": GraphQLVariable("launchId")], type: .object(Launch.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(launch: Launch? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "launch": launch.flatMap { (value: Launch) -> ResultMap in value.resultMap }])
    }

    public var launch: Launch? {
      get {
        return (resultMap["launch"] as? ResultMap).flatMap { Launch(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "launch")
      }
    }

    public struct Launch: GraphQLSelectionSet {
      public static let possibleTypes = ["Launch"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("site", type: .scalar(String.self)),
        GraphQLField("isBooked", type: .nonNull(.scalar(Bool.self))),
        GraphQLField("mission", type: .object(Mission.selections)),
        GraphQLField("rocket", type: .object(Rocket.selections)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, site: String? = nil, isBooked: Bool, mission: Mission? = nil, rocket: Rocket? = nil) {
        self.init(unsafeResultMap: ["__typename": "Launch", "id": id, "site": site, "isBooked": isBooked, "mission": mission.flatMap { (value: Mission) -> ResultMap in value.resultMap }, "rocket": rocket.flatMap { (value: Rocket) -> ResultMap in value.resultMap }])
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

      public var site: String? {
        get {
          return resultMap["site"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "site")
        }
      }

      public var isBooked: Bool {
        get {
          return resultMap["isBooked"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "isBooked")
        }
      }

      public var mission: Mission? {
        get {
          return (resultMap["mission"] as? ResultMap).flatMap { Mission(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "mission")
        }
      }

      public var rocket: Rocket? {
        get {
          return (resultMap["rocket"] as? ResultMap).flatMap { Rocket(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "rocket")
        }
      }

      public struct Mission: GraphQLSelectionSet {
        public static let possibleTypes = ["Mission"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("missionPatch", arguments: ["size": "SMALL"], type: .scalar(String.self)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(name: String? = nil, missionPatch: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Mission", "name": name, "missionPatch": missionPatch])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var missionPatch: String? {
          get {
            return resultMap["missionPatch"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "missionPatch")
          }
        }
      }

      public struct Rocket: GraphQLSelectionSet {
        public static let possibleTypes = ["Rocket"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("type", type: .scalar(String.self)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String? = nil, type: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Rocket", "id": id, "name": name, "type": type])
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

        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var type: String? {
          get {
            return resultMap["type"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "type")
          }
        }
      }
    }
  }
}

public final class LaunchDetailsWithFragmentsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query LaunchDetailsWithFragments($launchId: ID!) {
      launch(id: $launchId) {
        __typename
        ...LaunchFragment
      }
    }
    """

  public let operationName = "LaunchDetailsWithFragments"

  public var queryDocument: String { return operationDefinition.appending(LaunchFragment.fragmentDefinition).appending(MissionFragment.fragmentDefinition).appending(RocketFragment.fragmentDefinition) }

  public var launchId: GraphQLID

  public init(launchId: GraphQLID) {
    self.launchId = launchId
  }

  public var variables: GraphQLMap? {
    return ["launchId": launchId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("launch", arguments: ["id": GraphQLVariable("launchId")], type: .object(Launch.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(launch: Launch? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "launch": launch.flatMap { (value: Launch) -> ResultMap in value.resultMap }])
    }

    public var launch: Launch? {
      get {
        return (resultMap["launch"] as? ResultMap).flatMap { Launch(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "launch")
      }
    }

    public struct Launch: GraphQLSelectionSet {
      public static let possibleTypes = ["Launch"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(LaunchFragment.self),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
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

        public var launchFragment: LaunchFragment {
          get {
            return LaunchFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public struct MissionFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment MissionFragment on Mission {
      __typename
      name
      missionPatch(size: SMALL)
    }
    """

  public static let possibleTypes = ["Mission"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("name", type: .scalar(String.self)),
    GraphQLField("missionPatch", arguments: ["size": "SMALL"], type: .scalar(String.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(name: String? = nil, missionPatch: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "Mission", "name": name, "missionPatch": missionPatch])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var name: String? {
    get {
      return resultMap["name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var missionPatch: String? {
    get {
      return resultMap["missionPatch"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "missionPatch")
    }
  }
}

public struct RocketFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment RocketFragment on Rocket {
      __typename
      id
      name
      type
    }
    """

  public static let possibleTypes = ["Rocket"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("name", type: .scalar(String.self)),
    GraphQLField("type", type: .scalar(String.self)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, name: String? = nil, type: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "Rocket", "id": id, "name": name, "type": type])
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

  public var name: String? {
    get {
      return resultMap["name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var type: String? {
    get {
      return resultMap["type"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "type")
    }
  }
}

public struct LaunchFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition =
    """
    fragment LaunchFragment on Launch {
      __typename
      id
      site
      isBooked
      mission {
        __typename
        ...MissionFragment
      }
      rocket {
        __typename
        ...RocketFragment
      }
    }
    """

  public static let possibleTypes = ["Launch"]

  public static let selections: [GraphQLSelection] = [
    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
    GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
    GraphQLField("site", type: .scalar(String.self)),
    GraphQLField("isBooked", type: .nonNull(.scalar(Bool.self))),
    GraphQLField("mission", type: .object(Mission.selections)),
    GraphQLField("rocket", type: .object(Rocket.selections)),
  ]

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, site: String? = nil, isBooked: Bool, mission: Mission? = nil, rocket: Rocket? = nil) {
    self.init(unsafeResultMap: ["__typename": "Launch", "id": id, "site": site, "isBooked": isBooked, "mission": mission.flatMap { (value: Mission) -> ResultMap in value.resultMap }, "rocket": rocket.flatMap { (value: Rocket) -> ResultMap in value.resultMap }])
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

  public var site: String? {
    get {
      return resultMap["site"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "site")
    }
  }

  public var isBooked: Bool {
    get {
      return resultMap["isBooked"]! as! Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "isBooked")
    }
  }

  public var mission: Mission? {
    get {
      return (resultMap["mission"] as? ResultMap).flatMap { Mission(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "mission")
    }
  }

  public var rocket: Rocket? {
    get {
      return (resultMap["rocket"] as? ResultMap).flatMap { Rocket(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "rocket")
    }
  }

  public struct Mission: GraphQLSelectionSet {
    public static let possibleTypes = ["Mission"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(MissionFragment.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(name: String? = nil, missionPatch: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mission", "name": name, "missionPatch": missionPatch])
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

      public var missionFragment: MissionFragment {
        get {
          return MissionFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct Rocket: GraphQLSelectionSet {
    public static let possibleTypes = ["Rocket"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLFragmentSpread(RocketFragment.self),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, name: String? = nil, type: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Rocket", "id": id, "name": name, "type": type])
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

      public var rocketFragment: RocketFragment {
        get {
          return RocketFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}
