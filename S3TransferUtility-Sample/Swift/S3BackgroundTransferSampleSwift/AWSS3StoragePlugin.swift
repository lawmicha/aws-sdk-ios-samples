//
//  AWSS3Provider.swift
//  S3TransferUtilitySampleSwift
//
//  Created by Law, Michael on 8/12/19.
//  Copyright © 2019 Amazon. All rights reserved.
//

import Foundation

import AWSS3

public struct AWSS3StoragePlugin: StorageCategoryPlugin {
    public var key: PluginKey = "AWSS3StoragePlugin"
    private let queue: OperationQueue = OperationQueue()
    
    public init() {
    }
    
    
    public func configure(using configuration: Any?) throws {
        // TODO: replace this with AmplifyConfiguration object
        if let serviceInfo = configuration as? AWSServiceInfo {
            let serviceConfiguration = AWSServiceConfiguration(region: serviceInfo.region, credentialsProvider: serviceInfo.cognitoCredentialsProvider)
            
            // AWSS3TransferUtility for Get and Put
            AWSS3TransferUtility.register(with: serviceConfiguration!, forKey: key)
            
            // AWSS3PreSignedURLBuilder for GetUrl
            AWSS3PreSignedURLBuilder.register(with: serviceConfiguration!, forKey: key)
            
            // AWSS3 for List and Remove
            AWSS3.register(with: serviceConfiguration!, forKey: key)
        }
    }
    
    public func getAWSS3() -> AWSS3 {
        return AWSS3.s3(forKey: key)
    }
    
    public func put(key: String, data: Data, options: Any?) -> StoragePutOperation {
        let operation = AWSS3StoragePutOperation(data: data, key: key)
        queue.addOperation(operation)
        return operation
    }
    
    public func get(key: String, options: Any?) -> StorageGetOperation {
        let operation = AWSS3StorageGetOperation(key: key)
        queue.addOperation(operation)
        return operation
    }
    
    public func getURL(key: String, options: Any?) -> StorageGetUrlOperation {
        let operation = AWSS3StorageGetUrlOperation(key: key)
        queue.addOperation(operation)
        return operation
    }
    
    public func remove(key: String, options: Any?) -> StorageRemoveOperation {
        let operation = AWSS3StorageRemoveOperation(key: key)
        queue.addOperation(operation)
        return operation
    }
    
    public func list(path: String, options: Any?) -> StorageListOperation {
        let operation = AWSS3StorageListOperation(path: path)
        queue.addOperation(operation)
        return operation
    }
    
    public func reset() {
    }
}
