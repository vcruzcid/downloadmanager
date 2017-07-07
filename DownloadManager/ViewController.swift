//
//  ViewController.swift
//  DownloadManager
//
//  Created by Victor Cruz on 7/7/17.
//  Copyright © 2017 Cruz Cid Consultores Asociados. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var responsesTextView: UITextView!
    
    
    @IBAction func downloadButton(_ sender: UIButton) {
//        self.progressBar.isHidden = false
//        self.progressLbl.isHidden = false
        let mySelf = self
        
        let fileDownloadURL = URL(string: "https://www.dropbox.com/s/77lp9p7055ru733/iOScapture.zip?dl=1")
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL: URL = documentsURL.appendingPathComponent("test.file")
            return (fileURL, [.createIntermediateDirectories, .removePreviousFile])
        }
        
        Alamofire.download(fileDownloadURL!, to: destination)
            .response { response in
                self.responsesTextView.text = String(describing: response.temporaryURL)
                print(response.request)
                print(response.response)
                print(response.temporaryURL)
                print(response.destinationURL)
                print(response.error)
            }
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                var dataProgress = (progress.fractionCompleted * 100)
                //print(dataProgress)
                mySelf.progressLbl.text = "Victor"
                mySelf.progressBar.setProgress(0.5, animated: true)
                //print("Progress: \(progress.fractionCompleted * 100)")
                //print(String("\(progress.fractionCompleted * 100) %") as Any)
            }
            
            .validate {request, response, temporaryURL, destinationURL in
                return .success
                
        }

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.progressLbl.text = "0%"
        self.progressBar.progress = 0.0
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //func DownloadFile(_ url: URL) -> Bool {
        //Alamofire.download(url: url)
    //}

}

