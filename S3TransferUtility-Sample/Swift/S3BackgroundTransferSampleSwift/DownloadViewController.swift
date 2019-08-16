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

class DownloadViewController: UIViewController{

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var statusLabel: UILabel!

    @objc var completionHandler: AWSS3TransferUtilityDownloadCompletionHandlerBlock?

    @objc lazy var transferUtility = {
        AWSS3TransferUtility.default()
    }()

    var awss3StoragePlugin: AWSS3StoragePlugin?
    var refStorageGetOperation: StorageGetOperation?
    var unsubscribeGetOperation: Unsubscribe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("DownloadViewController viewDidLoad")
        self.progressView.progress = 0.0;
        self.statusLabel.text = "Ready"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        awss3StoragePlugin = appDelegate.awss3StoragePlugin
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func start(_ sender: UIButton) {

        DispatchQueue.main.async(execute: {
            self.statusLabel.text = ""
            self.progressView.progress = 0
        })

        self.imageView.image = nil;

        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                if (self.progressView.progress < Float(progress.fractionCompleted)) {
                    self.progressView.progress = Float(progress.fractionCompleted)
                }
            })
        }

//        self.completionHandler = { (task, location, data, error) -> Void in
//            DispatchQueue.main.async(execute: {
//                if let error = error {
//                    NSLog("Failed with error: \(error)")
//                    self.statusLabel.text = "Failed"
//                }
//                else if(self.progressView.progress != 1.0) {
//                    self.statusLabel.text = "Failed"
//                }
//                else{
//                    self.statusLabel.text = "Success"
//                    self.imageView.image = UIImage(data: data!)
//                }
//            })
//        }
        
        self.refStorageGetOperation = self.awss3StoragePlugin?.get(key: S3DownloadKeyName, options: nil)
        self.unsubscribeGetOperation = self.refStorageGetOperation?.subscribe({ (event) in
            switch(event) {
            case .unknown:
                break;
            case .notInProcess:
                break;
            case .inProcess(let progress):
                print("[Subscription] progress is \(progress.fractionCompleted)")
                DispatchQueue.main.async(execute: {
                    if (self.progressView.progress < Float(progress.fractionCompleted)) {
                        self.progressView.progress = Float(progress.fractionCompleted)
                    }
                })
                break;
            case .completed(let result):
                print("[Subscription] completed \(result)")
                DispatchQueue.main.async(execute: {
                    
                    if(self.progressView.progress != 1.0) {
                        self.statusLabel.text = "Failed"
                    }
                    else{
                        self.statusLabel.text = "Success"
                        self.imageView.image = UIImage(data: result.data)
                    }
                })
                
                self.unsubscribeGetOperation?()
            case .failed(_):
                break;
            }
        })
//
//        transferUtility.downloadData(
//            forKey: S3DownloadKeyName,
//            expression: expression,
//            completionHandler: completionHandler).continueWith { (task) -> AnyObject? in
//                if let error = task.error {
//                    NSLog("Error: %@",error.localizedDescription);
//                    DispatchQueue.main.async(execute: {
//                        self.statusLabel.text = "Failed"
//                    })
//                }
//
//                if let _ = task.result {
//                    DispatchQueue.main.async(execute: {
//                        self.statusLabel.text = "Downloading..."
//                    })
//                    NSLog("Download Starting!")
//                    // Do something with uploadTask.
//                }
//                return nil;
//            }
    }
}
