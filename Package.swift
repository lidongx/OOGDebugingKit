// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OOGDebugingKit",
    
    platforms: [
       .iOS(.v15)
    ],

    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "OOGDebugingKit",
            targets: ["OOGDebugingKit"]),
    ],
    
    dependencies: [
        .package(
            url: "https://github.com/Alamofire/Alamofire.git",
            from: "5.9.1"
        ),
        
        .package(
            url: "https://github.com/retro-labs/components-ios-swift.git",
            from: "0.1.11"
        ),
        
        .package(
            url: "https://github.com/retro-labs/iOS-FIREvents.git",
            from: "6.3.4"
        ),
        
        .package(
            url: "https://github.com/retro-labs/iOS-IAPManager.git",
            from: "11.4.8"
        ),
        
        .package(
            url: "https://github.com/SnapKit/SnapKit.git",
            from: "5.7.1"
        ),
        
        
    ],
    
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "OOGDebugingKit",
            dependencies: [
                "Alamofire",
                .product(name: "Components", package: "components-ios-swift"),
                .product(name: "FIREvents", package: "iOS-FIREvents"),
                .product(name: "IAPManagerCore", package: "iOS-IAPManager"),
                "SnapKit"
            ],
            path: "Source",
            resources: [
                .process("Assets")
            ]
        )
    ],
    
    swiftLanguageVersions: [
        .v5
    ]
)
