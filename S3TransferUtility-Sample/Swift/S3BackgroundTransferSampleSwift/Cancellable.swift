//
//  Cancellable.swift
//  S3TransferUtilitySampleSwift
//
//  Created by Law, Michael on 8/13/19.
//  Copyright © 2019 Amazon. All rights reserved.
//


/// The conforming type supports canceling an in-process operation. The exact semantics of "canceling" are not defined
/// in the protocol. Specifically, there is no guarantee that a `cancel` results in immediate cessation of activity.
public protocol Cancellable {
    func cancel()
}
