/*
 * Copyright 2010-2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

import UIKit
import AWSS3
import AWSMobileClient

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var awss3StoragePlugin: AWSS3StoragePlugin?
    
    func application(_ application: UIApplication,
                     handleEventsForBackgroundURLSession identifier: String,
                     completionHandler: @escaping () -> Void) {

        // Instead of using AWSS3TransferUtility.register method, use Amplify.configure() which will call StorageCategory's plugin.configure.
        
        //provide the completionHandler to the TransferUtility to support background transfers.
//        AWSS3TransferUtility.interceptApplication(application,
//                                                  handleEventsForBackgroundURLSession: identifier,
//                                                  completionHandler: completionHandler)
        
        
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("application start")
        
        // The Amplify V0 experience is to ship with AWSMobileClient, which has a direct dependency on awsconfiguration.json.
        // AWSMobileClient and AWSS3TransferUtility default instances are both retrieving the same CredentialsProvider from awsconfiguration.json
        // So how do we use AWSMobileClient and Amplify together?
        // AWSMobileClient uses AWSInfo, which will have to be updated to read from amplifyconfiguration.json so that it takes precedent over awsconfiguration.json.
        // Amplify will initialize with the amplifyconfiguration.json
        // Amplify.add(AWSS3StoragePlugin()) // create and add the plugin
        // Amplify.configure() // configures using amplifyconfiguration.json
        self.awss3StoragePlugin = AWSS3StoragePlugin()
        do {
            // For now, retrieve data from awsconfiguration.json until Amplify Core is built,"CredentialsProvider", "S3TransferUtility"
            let serviceInfo: AWSServiceInfo? = AWSInfo.default().defaultServiceInfo("S3TransferUtility")
            if let serviceInfo = serviceInfo {
                try self.awss3StoragePlugin?.configure(using: serviceInfo) // serviceInfo will be replaced with AmplifyConfiguration object
            }
        } catch {
            print("Error configuring AWSS3StoragePlugin")
        }
        
        AWSMobileClient.sharedInstance().initialize { (userState, error) in
            guard error == nil else {
                print("Error initializing AWSMobileClient. Error: \(error!.localizedDescription)")
                return
            }
            print("AWSMobileClient initialized.")
        }
        
        return true
    }
}
