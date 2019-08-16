//
//  AsyncEvent.swift
//  S3TransferUtilitySampleSwift
//
//  Created by Law, Michael on 8/13/19.
//  Copyright © 2019 Amazon. All rights reserved.
//

import Foundation
public enum AsyncEvent<InProcessType, CompletedType, ErrorType: AmplifyError> {
    case unknown
    case notInProcess
    case inProcess(InProcessType)
    case completed(CompletedType)
    case failed(ErrorType)
}
