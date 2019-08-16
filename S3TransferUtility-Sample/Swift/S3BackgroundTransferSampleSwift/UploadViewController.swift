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

class UploadViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    
    @IBOutlet var s3UploadButton: UIButton!
    
    @objc var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
    @objc var progressBlock: AWSS3TransferUtilityProgressBlock?

    @objc let imagePicker = UIImagePickerController()

    @objc lazy var transferUtility = {
        AWSS3TransferUtility.default()
    }()
    
    @objc lazy var s3 = {
       AWSS3.default()
    }()
    
    var awss3StoragePlugin: AWSS3StoragePlugin?
    
    var refUploadTask: AWSS3TransferUtilityUploadTask?
    var refStoragePutOperation: StoragePutOperation?
    var unsubscribePutOperation: Unsubscribe?
    
    var refStorageRemoveOperation: StorageRemoveOperation?
    var unsubscribeRemoveOperation: Unsubscribe?

    let S3UploadTextKeyName: String = "testingKey111"      // Name of file to be uploaded
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("UploadViewController viewDidLoad")
        
        
        self.progressView.progress = 0.0;
        self.statusLabel.text = "Ready"
        self.imagePicker.delegate = self
        self.cancelButton.setTitle("Cancel Upload", for: .normal)
        //self.cancelButton.isHidden = true

        self.progressBlock = {(task, progress) in
            DispatchQueue.main.async(execute: {
                if (self.progressView.progress < Float(progress.fractionCompleted)) {
                    self.progressView.progress = Float(progress.fractionCompleted)
                }
            })
        }

        self.completionHandler = { (task, error) -> Void in
            
            DispatchQueue.main.async(execute: {
                if let error = error {
                    print("Failed with error: \(error)")
                    self.statusLabel.text = "Failed"
                }
                else if(self.progressView.progress != 1.0) {
                    self.statusLabel.text = "Failed"
                    NSLog("Error: Failed - Likely due to invalid region / filename")
                }
                else{
                    self.statusLabel.text = "Success"
                }
            })
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        awss3StoragePlugin = appDelegate.awss3StoragePlugin
    }

    @IBAction func selectAndUpload(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary

        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func s3Upload(_ sender: Any) {
        print("s3Upload Clicked")
        var dataString = "1234567890"
        for _ in 1...5 {
            dataString += dataString
        }
        var testData = dataString.data(using: String.Encoding.utf8)!
        self.refStoragePutOperation = self.awss3StoragePlugin?.put(key: S3UploadTextKeyName, data: testData, options: 1)
        self.unsubscribePutOperation = self.refStoragePutOperation?.subscribe({ (event) in
            switch(event) {
            case .unknown:
                break;
            case .notInProcess:
                break;
            case .inProcess(let progress):
                print("[Subscription] progress is \(progress.fractionCompleted)")
            case .completed(let result):
                print("[Subscription] completed \(result.key)")
                self.unsubscribePutOperation?()
            case .failed(_):
                break;
            @unknown default:
                break;
            }
        })
    }
    
    @IBAction func deleteS3Upload(_ sender: Any) {
        print("deleting uploaded text")
        
        self.refStorageRemoveOperation = self.awss3StoragePlugin?.remove(key: S3UploadTextKeyName, options: nil)
        self.unsubscribeRemoveOperation = self.refStorageRemoveOperation?.subscribe({ (event) in
            switch(event) {
            case .unknown:
                break;
            case .notInProcess:
                break;
            case .completed(let result):
                print("[Subscription] completed \(result)")
                self.unsubscribeRemoveOperation?()
            case .failed(_):
                break;
            @unknown default:
                break;
            }
        })
    }
    
    @IBAction func cancelUpload(_ sender: UIButton) {
        //refUploadTask?.cancel();
        refStoragePutOperation?.cancel()
        print("Cancelled")
    }
    
    @objc func uploadImage(with data: Data) {
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = progressBlock

        DispatchQueue.main.async(execute: {
            self.statusLabel.text = ""
            self.progressView.progress = 0
        })

        self.refStoragePutOperation = self.awss3StoragePlugin?.put(key: S3UploadKeyName, data: data, options: 1)
        self.unsubscribePutOperation = self.refStoragePutOperation?.subscribe({ (event) in
            
            switch (event) {
            case .unknown:
                print("[Subscription] unknown")
            case .notInProcess:
                print("[Subscription] not in process")
            case .inProcess(let progress):
                print("[Subscription] progress is \(progress.fractionCompleted)")
            case .completed(let result):
                print("[Subscription] completed \(result.key)")
                self.unsubscribePutOperation?()
            case .failed(_):
                print("[Subscription] failed")
            }
        })
        
        
//        transferUtility.uploadData(
//            data,
//            key: S3UploadKeyName,
//            contentType: "image/png",
//            expression: expression,
//            completionHandler: completionHandler).continueWith { (task) -> AnyObject? in
//                if let error = task.error {
//                    print("Error: \(error.localizedDescription)")
//
//                    DispatchQueue.main.async {
//                        self.statusLabel.text = "Failed"
//                    }
//                }
//
//                if let uploadTask = task.result {
//
//                    DispatchQueue.main.async {
//                        self.statusLabel.text = "Uploading..."
//                        print("Upload Starting!")
//                    }
//
//                    // Hold a reference to the uploadTask for pausing, resuming, canceling
//                    self.refUploadTask = uploadTask;
//                }
//
//                return nil;
//        }
    }
}

extension UploadViewController: UIImagePickerControllerDelegate {

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if "public.image" == info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaType)] as? String {
            let image: UIImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage
            self.uploadImage(with: image.pngData()!)
        }


        dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
