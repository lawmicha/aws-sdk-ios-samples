//
//  ListAndGetUrlViewController.swift
//  S3TransferUtilitySampleSwift
//
//  Created by Law, Michael on 8/14/19.
//  Copyright © 2019 Amazon. All rights reserved.
//

import UIKit

class ListAndGetUrlViewController: UIViewController {

    var awss3StoragePlugin: AWSS3StoragePlugin?
    
    var refStorageListOperation: StorageListOperation?
    var unsubscribeListOperation: Unsubscribe?
    
    var refStorageGetUrlOperation: StorageGetUrlOperation?
    var unsubscribeGetUrlOperation: Unsubscribe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("[ListAndGetUrlViewController] viewDidLoad")
        // Do any additional setup after loading the view.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        awss3StoragePlugin = appDelegate.awss3StoragePlugin
    }
    

    @IBAction func listClicked(_ sender: UIButton) {
        
        print("list clicked")
        
        self.refStorageListOperation = self.awss3StoragePlugin?.list(path: "public", options: nil)
        self.unsubscribeListOperation = self.refStorageListOperation?.subscribe({ (event) in
            switch(event) {
            case .unknown:
                break;
            case .notInProcess:
                break;
            case .completed(let result):
                print("[Subscription] completed \(result.list)")
                self.unsubscribeListOperation?()
            case .failed(_):
                break;
            @unknown default:
                break;
            }
        })
    }
    
    @IBAction func getUrlTest(_ sender: UIButton) {
        
        self.refStorageGetUrlOperation = self.awss3StoragePlugin?.getURL(key: "testingKey3", options: nil)
        self.unsubscribeGetUrlOperation = self.refStorageGetUrlOperation?.subscribe({ (event) in
            switch(event) {
            case .unknown:
                break;
            case .notInProcess:
                break;
            case .completed(let result):
                print("[Subscription] completed \(result.url)")
                self.unsubscribeGetUrlOperation?()
            case .failed(_):
                break;
            @unknown default:
                break;
            }
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
