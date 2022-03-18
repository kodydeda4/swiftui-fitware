// swift-tools-version: 5.5

import PackageDescription

let package = Package(
  name: "AppState",
  platforms: [.macOS(.v12), .iOS(.v15), .watchOS(.v8)],
  products: [],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.31.0"),
    .package(
      name: "Firebase",
      url: "https://github.com/firebase/firebase-ios-sdk.git",
      .upToNextMajor(from: "8.10.0")
    ),
  ],
  targets: []
).addSources([
  
  // MARK: Feature
  Source(name: "App", dependencies: [
    .composableArchitecture,
    .firebase,
    .failure,
    .auth,
    .user,
    .exerciseList,
    .exerciseListClient,
    .authClient
  ]),
  Source(name: "Auth", dependencies: [
    .composableArchitecture,
    .firebase,
    .failure,
    .authClient
  ]),
  Source(name: "User", dependencies: [
    .composableArchitecture,
    .firebase,
    .failure,
    .exerciseList,
    .exerciseListClient,
    .workoutList,
    .workoutListClient,
    .settings
  ]),
  Source(name: "ExerciseList", dependencies: [
    .composableArchitecture,
    .failure,
    .exercise,
    .exerciseListClient,
  ]),
  Source(name: "Exercise", dependencies: [
    .composableArchitecture,
    .failure
  ]),
  Source(name: "WorkoutList", dependencies: [
    .composableArchitecture,
    .failure,
    .workoutListClient
  ]),
  Source(name: "Settings", dependencies: [
    .composableArchitecture,
    .failure,
    .authClient
  ]),
  
  
  // MARK: Client
  Source(name: "AuthClient", dependencies: [
    .composableArchitecture,
    .firebase,
    .failure
  ]),
  Source(name: "ExerciseListClient", dependencies: [
    .composableArchitecture,
    .failure,
    .exercise,
  ]),
  Source(name: "WorkoutListClient", dependencies: [
    .composableArchitecture,
    .failure,
    .firebase,
    .firebaseFirestoreSwift,
    .exercise
  ]),
  
  // MARK: General
  Source(name: "Failure", dependencies: []),
])

// MARK: - Extensions

struct Source {
  let name: String
  var dependencies: [Target.Dependency] = []
}

extension Package {
  func addSources(_ sources: [Source]) -> Package {
    self.products += sources.map { .library(name: $0.name, targets: [$0.name]) }
    self.targets += sources.map { .target(name: $0.name, dependencies: $0.dependencies) }
    return self
  }
}

// MARK: - Dependencies

// Features
extension Target.Dependency {
  static let app: Self = "App"
  static let auth: Self = "Auth"
  static let user: Self = "User"
  static let exerciseList: Self = "ExerciseList"
  static let exercise: Self = "Exercise"
  static let workoutList: Self = "WorkoutList"
  static let settings: Self = "Settings"
}

// Clients
extension Target.Dependency {
  static let authClient: Self = "AuthClient"
  static let exerciseListClient: Self = "ExerciseListClient"
  static let workoutListClient: Self = "WorkoutListClient"
}

// Core
extension Target.Dependency {
  static let failure: Self = "Failure"
}

// External
extension Target.Dependency {
  static let composableArchitecture: Self = .product(
    name: "ComposableArchitecture",
    package: "swift-composable-architecture"
  )
  static let firebase: Self = .product(
    name: "FirebaseAuth",
    package: "Firebase"
  )
  static let firebaseFirestoreSwift: Self = .product(
    name: "FirebaseFirestoreSwift-Beta",
    package: "Firebase"
  )
}
