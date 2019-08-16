//
//  StoragePutOperationProtocol.swift
//  S3TransferUtilitySampleSwift
//
//  Created by Law, Michael on 8/14/19.
//  Copyright © 2019 Amazon. All rights reserved.
//

import Foundation
public protocol StoragePutOperation: AmplifyOperation<Progress, StoragePutResult, StoragePutError>, Resumable {
}
