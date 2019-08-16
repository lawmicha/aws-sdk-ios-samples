//
//  HubPayload.swift
//  S3TransferUtilitySampleSwift
//
//  Created by Law, Michael on 8/13/19.
//  Copyright © 2019 Amazon. All rights reserved.
//

public struct HubPayload {
    public let event: String
    public let data: Codable?
    public let message: String?
    
    public init(event: String, data: Codable? = nil, message: String? = nil) {
        self.event = event
        self.data = data
        self.message = message
    }
}
