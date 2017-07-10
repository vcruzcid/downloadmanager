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
    @IBOutlet weak var downloadButtonOutlet: UIButton!
    @IBOutlet weak var urlLabel: UILabel!
    
    
    @IBAction func downloadButton(_ sender: UIButton) {
        //let fileDownloadURL = URL(string: "https://www.dropbox.com/s/77lp9p7055ru733/iOScapture.zip?dl=1")
        //let fileDownloadURL = URL(string: "http://192.168.203.138/test.zip")
        let fileDownloadURL = URL(string: "https://www.dropbox.com/s/pz71oox28q1jfo4/iOScapture.appcomnfig.pcap?dl=1")
        
        self.progressBar.isHidden = false
        self.progressLbl.isHidden = false
        self.downloadButtonOutlet.isEnabled = false
        self.urlLabel.text = "URL: \(String(describing: fileDownloadURL!)) "
        self.statusLbl.text = "Status: Downloading"

        
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL: URL = documentsURL.appendingPathComponent("test.file")
            self.appendDebugLog(logText: fileURL.absoluteString)
            
            return (fileURL, [.createIntermediateDirectories, .removePreviousFile])
        }
        
        Alamofire.download(fileDownloadURL!, to: destination)
            .response { response in
                
                let debugText = String(describing: response.request) + "\n" + String(describing: response.response) + "\n" + String(describing: response.temporaryURL) + "\n" + String(describing: response.destinationURL) + "\n" + String(describing: response.error)
                self.appendDebugLog(logText: debugText)
                
                print(response.request)
                print(response.response)
                print(response.temporaryURL)
                print(response.destinationURL)
                print(response.error)
                
                if response.error != nil {
                    self.statusLbl.text = "Status: Failed with error"
        }
            }
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in

                // Send the tread to the foreground (need to do this will all closures because closures runs in the background)
                DispatchQueue.main.async {
                    let progressText = String.init(format: "%0.2f %%", progress.fractionCompleted * 100)
                    self.progressLbl.text = progressText
                    self.progressBar.setProgress(Float(progress.fractionCompleted), animated: true)
                }
                print("Progress: \(progress.fractionCompleted * 100)")
             
            }
            
            .responseJSON { response in
                debugPrint(response)
                self.appendDebugLog(logText: response.debugDescription)
            }
            
            .validate {request, response, temporaryURL, destinationURL in
                self.downloadButtonOutlet.setTitle("Download Again", for: .normal)
                self.downloadButtonOutlet.isEnabled = true
                self.statusLbl.text = "Status: Downloaded"
                
                return .success
        }

    }
    
    func appendDebugLog(logText: String) {
        DispatchQueue.main.async {
            self.responsesTextView.text = self.responsesTextView.text + "\n" + logText
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
}
