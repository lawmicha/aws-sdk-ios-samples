//
//  AWSS3StorageListOperation.swift
//  S3TransferUtilitySampleSwift
//
//  Created by Law, Michael on 8/14/19.
//  Copyright © 2019 Amazon. All rights reserved.
//

import Foundation
import AWSS3

public class AWSS3StorageListOperation: AmplifyOperation<Void, StorageListResult, StorageListError>, StorageListOperation {
    
    let path: String
    
    var onEvent: ((AsyncEvent<Void, StorageListResult, StorageListError>) -> Void)?
    init(path: String) {
        self.path = path
    }
    
    // override AmplifyOperation : Cancellable
    override public func cancel() {
        cancel()
    }
    
    func emitSuccess(result: AWSS3ListObjectsV2Output) {
        if let contents = result.contents {
            var list: [String] = Array()
            for s3Key in contents {
                list.append(s3Key.key!)
            }
            let result = StorageListResult(list: list)
            self.onEvent?(AsyncEvent.completed(result))
        }
        
        
    }
    
    override public func main() {
        let request: AWSS3ListObjectsV2Request = AWSS3ListObjectsV2Request()
        request.bucket = "swiftstoragesample1fd7e03cf4804cdaac1f0d548fbe3aa0-devo"
        //request.prefix = path
        AWSS3.s3(forKey: "AWSS3StoragePlugin").listObjectsV2(request).continueWith { (task) -> Any? in
            print("continueWith")
            if let error = task.error {
                print("error" + error.localizedDescription)
                // return promise that failed.
            }
            
            // For now
            if let results = task.result {
                self.emitSuccess(result: results)
                //print("results: \(results)")
            }
            
            return nil
        }
    }
    
    // Temporary hack to replace Hub notifications
    override public func subscribe(_ onEvent: @escaping (AsyncEvent<Void, StorageListResult, StorageListError>) -> Void) -> Unsubscribe {
        print("subscribed with event listener")
        self.onEvent = onEvent
        return unsubscribe
    }
    
    func unsubscribe() {
        print("unsubscribing")
        self.onEvent = nil
    }
}
