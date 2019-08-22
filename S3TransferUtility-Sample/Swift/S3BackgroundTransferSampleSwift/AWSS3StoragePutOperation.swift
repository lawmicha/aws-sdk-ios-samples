//
//  StoragePutOperation.swift
//  S3TransferUtilitySampleSwift
//
//  Created by Law, Michael on 8/13/19.
//  Copyright © 2019 Amazon. All rights reserved.
//

import Foundation
import AWSS3

public class AWSS3StoragePutOperation: AmplifyOperation<Progress, StoragePutResult, StoragePutError>, StoragePutOperation {

    let data: Data
    let key: String
    
    var refUploadTask: AWSS3TransferUtilityUploadTask?
    var onEvent: ((AsyncEvent<Progress, StoragePutResult, StoragePutError>) -> Void)?
    init(data: Data, key: String) {
        
        self.data = data
        self.key = key
        //super.init()
    }
    
    // implements Resumable
    public func pause() {
        refUploadTask?.suspend()
    }
    
    // implements Resumbable
    public func resume() {
        refUploadTask?.resume()
    }
    
    // override AmplifyOperation : Cancellable
    override public func cancel() {
        // use stored UtilityTask to cancel the upload
        refUploadTask?.cancel()
        cancel()
    }
    
    func emitEvent(progress: Progress) {
        self.onEvent?(AsyncEvent.inProcess(progress))
    }
    
    func emitSuccess() {
        let result = StoragePutResult(key: self.key)
        self.onEvent?(AsyncEvent.completed(result))
    }
    
    override public func main() {
        print("Executing StoragePutOperation")
        let transferUtility = AWSS3TransferUtility.s3TransferUtility(forKey: "AWSS3StoragePlugin")
        let uploadExpression = AWSS3TransferUtilityUploadExpression()
        uploadExpression.progressBlock = {(task, progress) in
            //sprint("[SubscriptionPutOperation.Main] Upload progress: ", progress.fractionCompleted)
            
            // TODO: Hub.dispatch progress event with payload (progress)
            
            // With the Hub, a dispatch will call the subscriber's closure block.
            // Until the Hub is implemented, we will mock this behaviour by holding onto the closure block
            // when the subscriber passes in the closure on the subscribe() call, then call the closure directly
            // to propagate the progress to the client.
            self.emitEvent(progress: progress)
            
        }
        let completionHandler = { (task: AWSS3TransferUtilityUploadTask, error: Error?) -> Void in
            if let HTTPResponse = task.response {
                print("Status: \(HTTPResponse)")
                
                // TODO: if error, dispatch error event with payload  (task.error)
                
                // TODO: Hub.dispatch completion event with payload (Success)
                // TODO: self.emitSuccess/emitError
            }
            
            if let error = error {
                print("Failed with error: \(error)")
            } else {
                self.emitSuccess()
            }
            
            
        }
        
        if (isCancelled) {
            return
        }
        
        transferUtility?.uploadData(
            data,
            bucket: "swiftstoragesample1fd7e03cf4804cdaac1f0d548fbe3aa0-devo", // private|protected|public
            key: key, // key of the object
            contentType: "application/octet-stream", // contentType or "binary/octet-stream
            expression: uploadExpression,
            completionHandler: completionHandler).continueWith {(task) -> AnyObject? in
                // TODO: emit error event if any
                
                if let uploadTask = task.result {
                    if (self.isCancelled) {
                        uploadTask.cancel()
                    } else {
                        self.refUploadTask = uploadTask
                    }
                }
                return nil
            }
    }
    
    // Temporary hack to replace Hub notifications
    override public func subscribe(_ onEvent: @escaping (AsyncEvent<Progress, StoragePutResult, StoragePutError>) -> Void) -> Unsubscribe {
        print("subscribed with event listener")
        self.onEvent = onEvent
        return unsubscribe
    }
    
    func unsubscribe() {
        print("unsubscribing")
        self.onEvent = nil
    }
}
