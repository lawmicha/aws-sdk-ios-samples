//
//  AmplifyOperation.swift
//  S3TransferUtilitySampleSwift
//
//  Created by Law, Michael on 8/13/19.
//  Copyright © 2019 Amazon. All rights reserved.
//

import Foundation
public class AmplifyOperation<InProcessType, CompletedType, ErrorType: AmplifyError>: Operation, CategoryTypeable, EventPublishable {
    
    public var categoryType: CategoryType = .storage
    
    public let id = UUID()
    
    public func listenToOperationEvents(
        onEvent: @escaping (HubPayload) -> Void) -> String {
        
        //        let idFilteringWrapper: HubFilter = { payload in
        //            guard let payload.message?.
        //        }
       
        return "UnSubscribeToken"
    }
    
    public func subscribe(_ onEvent: @escaping (AsyncEvent<InProcessType, CompletedType, ErrorType>) -> Void) -> Unsubscribe {
        return { () -> Void in return }
    }
    
    public var result: CompletedType
    
    public var error: ErrorType
    
    public func completionHandler(_ onComplete: @escaping (AsyncEvent<InProcessType, CompletedType, ErrorType>) -> Void) {
        // check if operation has completed. by checking state is finished, or is executing, etc.
        
        // if operation has completed, then we simply trigger the onComplete with the AsyncEvent object for completion
        //onComplete(AsyncEvent.completed(result))
        //onComplete(AsyncEvent.failed(error))
    }
}

extension AmplifyOperation: Cancellable {

}

//extension AmplifyOperation: EventPublishable {
//    public func subscribe(_ onEvent: @escaping (AsyncEvent<InProcessType, CompletedType, ErrorType>) -> Void) -> Unsubscribe {
//        return { () -> Void in return }
//    }
//}



