//
// Copyright 2018-2019 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

/// The Amplify category with which the conforming type is associated. Categories, Plugins, ClientBehaviors, etc must
/// all share the same CategoryType
public protocol CategoryTypeable {
    var categoryType: CategoryType { get }
}

/// Amplify supports these Category types
public enum CategoryType: String {
    /// Record app metrics and analytics bdata
    case analytics
    
    /// Retrieve data from a remote service
    case api
    
    /// Identify and authorize users of your application
    case auth
    
    /// Listen for or dispatch Amplify events
    case hub
    
    /// Log Amplify and app messages
    case logging
    
    /// Upload and download files from the cloud
    case storage
}

extension CategoryType: CaseIterable {}

public extension CategoryType {
    var displayName: String {
        switch self {
        case .analytics:
            return "Analytics"
        case .api:
            return "API"
        case .auth:
            return "Auth"
        case .hub:
            return "Hub"
        case .logging:
            return "Loggin"
        case .storage:
            return "Storage"
        }
    }
}
