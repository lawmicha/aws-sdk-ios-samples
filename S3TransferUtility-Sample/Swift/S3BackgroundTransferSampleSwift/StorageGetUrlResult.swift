//
//  StorageGetUrlResult.swift
//  S3TransferUtilitySampleSwift
//
//  Created by Law, Michael on 8/14/19.
//  Copyright © 2019 Amazon. All rights reserved.
//

import Foundation
public class StorageGetUrlResult {
    internal init(url: NSURL) {
        self.url = url
    }
    
    var url: NSURL
}
