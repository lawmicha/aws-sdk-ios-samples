//
//  AWSS3StorageGetOperation.swift
//  S3TransferUtilitySampleSwift
//
//  Created by Law, Michael on 8/14/19.
//  Copyright © 2019 Amazon. All rights reserved.
//

import Foundation
import AWSS3

public class AWSS3StorageRemoveOperation: AmplifyOperation<Void, StorageRemoveResult, StorageRemoveError>, StorageRemoveOperation {
    
    let key: String
    
    var onEvent: ((AsyncEvent<Void, StorageRemoveResult, StorageRemoveError>) -> Void)?
    init(key: String) {
        self.key = key
    }
    
    // override AmplifyOperation : Cancellable
    override public func cancel() {
        cancel()
    }
    
    func emitSuccess() {
        let result = StorageRemoveResult()
        self.onEvent?(AsyncEvent.completed(result))
    }
    
    override public func main() {
        let request : AWSS3DeleteObjectRequest = AWSS3DeleteObjectRequest()
        request.bucket = "swiftstoragesample1fd7e03cf4804cdaac1f0d548fbe3aa0-devo"
        request.key = key
        
        AWSS3.s3(forKey: "AWSS3StoragePlugin").deleteObject(request).continueWith { (task) -> Any? in
            print("deleted Object")
            
            if let error = task.error {
                print("error" + error.localizedDescription)
                // if there are errors, dispatch the event to the Hub. developers can subscribe to thre Hub for some of these events.
                // then return the Promise object with failures.
            }
            
            self.emitSuccess()
            // if there are no errors, we return the Promise object with task.result
            return nil
        }
    }
    
    // Temporary hack to replace Hub notifications
    override public func subscribe(_ onEvent: @escaping (AsyncEvent<Void, StorageRemoveResult, StorageRemoveError>) -> Void) -> Unsubscribe {
        print("subscribed with event listener")
        self.onEvent = onEvent
        return unsubscribe
    }
    
    func unsubscribe() {
        print("unsubscribing")
        self.onEvent = nil
    }
}
