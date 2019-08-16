//
//  StorageListError.swift
//  S3TransferUtilitySampleSwift
//
//  Created by Law, Michael on 8/14/19.
//  Copyright © 2019 Amazon. All rights reserved.
//

import Foundation
public class StorageListError: AmplifyError {
    internal init(errorDescription: ErrorDescription, recoverySuggestion: RecoverySuggestion) {
        self.errorDescription = errorDescription
        self.recoverySuggestion = recoverySuggestion
    }
    
    public var errorDescription: ErrorDescription
    
    // specific to the Put operation
    public var recoverySuggestion: RecoverySuggestion
    
    
}
