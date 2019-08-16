//
//  StorageProvider.swift
//  S3TransferUtilitySampleSwift
//
//  Created by Law, Michael on 8/12/19.
//  Copyright © 2019 Amazon. All rights reserved.
//

import Foundation

// the interface for which the StorageCategory and the StoragePlugin will implement
// The StorageCategory will expose these methods to the client, and implement the logic to use the plugin and call plugin's method
// The Plugin is the wrapper class ontop of the backing storage, AWSStoragePlugin is a wrapp on top of AWSS3
public protocol StorageCategoryClientBehavior {
    // Download in memory to a Data object
    func get(key: String, options: Any?) -> StorageGetOperation
//
//    // Generate a download URL
    func getURL(key: String, options: Any?) -> StorageGetUrlOperation
    
    // Upload data to Storage for key
    func put(key: String, data: Data, options: Any?) -> StoragePutOperation
    
    // Delete file at key
    func remove(key: String, options: Any?) -> StorageRemoveOperation
//
//    // list objects relative to the path
    func list(path: String, options: Any?) -> StorageListOperation
}




