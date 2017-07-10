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
    
    
    @IBAction func downloadButton(_ sender: UIButton) {
        self.progressBar.isHidden = false
        self.progressLbl.isHidden = false
        self.downloadButtonOutlet.isEnabled = false
        
        //let fileDownloadURL = URL(string: "https://www.dropbox.com/s/77lp9p7055ru733/iOScapture.zip?dl=1")
        //let fileDownloadURL = URL(string: "http://192.168.203.138/test.zip")
        let fileDownloadURL = URL(string: "https://www.dropbox.com/s/pz71oox28q1jfo4/iOScapture.appcomnfig.pcap?dl=1")
        
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL: URL = documentsURL.appendingPathComponent("test.file")
            return (fileURL, [.createIntermediateDirectories, .removePreviousFile])
        }
        
        Alamofire.download(fileDownloadURL!, to: destination)
            .response { response in
                DispatchQueue.main.async {
                    print("test")
                    self.responsesTextView.text = String(describing: response.request) + String(describing: response.response) + String(describing: response.temporaryURL) + String(describing: response.destinationURL) + String(describing: response.error)
                }
                
                
                print(response.request)
                print(response.response)
                print(response.temporaryURL)
                print(response.destinationURL)
                print(response.error)
                
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
            }
            
            .validate {request, response, temporaryURL, destinationURL in
                self.downloadButtonOutlet.setTitle("Download Again", for: .normal)
                self.downloadButtonOutlet.isEnabled = true
                
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
}
