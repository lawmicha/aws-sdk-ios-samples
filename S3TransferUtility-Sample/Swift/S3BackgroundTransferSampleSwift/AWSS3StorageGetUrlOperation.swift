//
//  AWSS3StorageGetUrlOperation.swift
//  S3TransferUtilitySampleSwift
//
//  Created by Law, Michael on 8/14/19.
//  Copyright © 2019 Amazon. All rights reserved.
//

import Foundation
import AWSS3

public class AWSS3StorageGetUrlOperation: AmplifyOperation<Void, StorageGetUrlResult, StorageGetUrlError>, StorageGetUrlOperation {
    
    let key: String
    
    var refGetTask: AWSS3TransferUtilityDownloadTask?
    var onEvent: ((AsyncEvent<Void, StorageGetUrlResult, StorageGetUrlError>) -> Void)?
    init(key: String) {
        self.key = key
    }
    
    // implements Resumable
    public func pause() {
        
    }
    
    // implements Resumbable
    public func resume() {
        
    }
    
    // override AmplifyOperation : Cancellable
    override public func cancel() {
        self.refGetTask?.cancel()
        cancel()
    }
    
    func emitSuccess(url: NSURL) {
        let result = StorageGetUrlResult(url: url)
        self.onEvent?(AsyncEvent.completed(result))
    }
    
    override public func main() {
        print("Executing AWSS3StorageGetUrlOperation")
        
        let request = AWSS3GetPreSignedURLRequest()
        request.bucket = "swiftstoragesample1fd7e03cf4804cdaac1f0d548fbe3aa0-devo"
        request.key = key
        request.httpMethod = AWSHTTPMethod.GET
        request.expires = NSDate(timeIntervalSinceNow: 18000) as Date
        
//        getPreSignedURLRequest.expires = [NSDate dateWithTimeIntervalSinceNow:_transferUtilityConfiguration.timeoutIntervalForResource];
//        getPreSignedURLRequest.minimumCredentialsExpirationInterval = _transferUtilityConfiguration.timeoutIntervalForResource;
//        getPreSignedURLRequest.accelerateModeEnabled = self.transferUtilityConfiguration.isAccelerateModeEnabled;
        let s3PreSignedURLBuilder = AWSS3PreSignedURLBuilder.s3PreSignedURLBuilder(forKey: "AWSS3StoragePlugin")
        s3PreSignedURLBuilder.getPreSignedURL(request).continueWith { (task) -> Any? in
            if let error = task.error {
                print("Error: \(error.localizedDescription)")
            }
            
            if let result = task.result {
                self.emitSuccess(url: result)
            }
            
            return nil
        }

    }
    
    // Temporary hack to replace Hub notifications
    override public func subscribe(_ onEvent: @escaping (AsyncEvent<Void, StorageGetUrlResult, StorageGetUrlError>) -> Void) -> Unsubscribe {
        print("subscribed with event listener")
        self.onEvent = onEvent
        return unsubscribe
    }
    
    func unsubscribe() {
        print("unsubscribing")
        self.onEvent = nil
    }
}
