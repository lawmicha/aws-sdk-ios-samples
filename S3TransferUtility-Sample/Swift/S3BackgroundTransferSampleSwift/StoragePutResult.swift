//
//  StorageError.swift
//  S3TransferUtilitySampleSwift
//
//  Created by Law, Michael on 8/13/19.
//  Copyright © 2019 Amazon. All rights reserved.
//

import Foundation

// completed type
public class StoragePutResult {
    internal init(key: String) {
        self.key = key
    }
    
    // contains information like the key
    var key: String
}
