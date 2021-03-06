//
//  NewViewController.swift
//  DownloadManager
//
//  Created by Victor Cruz on 7/11/17.
//  Copyright © 2017 Cruz Cid Consultores Asociados. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class NewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var resultsTextArea: UITextView!
    
    var downloadedFileLogData: DownloadedFile?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var linkManager: LinkManager?
    
    @IBAction func addLinkButton(_ sender: UIBarButtonItem) {
        let addLinkToList = UIAlertController(title: "Add File",message: "Please type URL", preferredStyle: .alert)
        addLinkToList.addTextField {(textField) in
            textField.keyboardType = .URL
        }
        
        addLinkToList.addAction(UIAlertAction(title: "Add URL", style: .default)
        { (action:UIAlertAction!) in
            let newUrl = addLinkToList.textFields?[0].text
            if self.canOpenURL(string: newUrl) {
                // Add the link to the Array
                let urlComponents = NSURLComponents(string: newUrl!)
                let newLink = DownloadLink(url: newUrl!, protocolType: (urlComponents?.scheme)! , site: (urlComponents?.host)!, fileName: (newUrl! as NSString).lastPathComponent)
                self.linkManager?.link.append(newLink)
                self.tableView.reloadData()
            }
            else {
                print("Invalid URL")
            }
        })
        
        addLinkToList.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel")
            self.tableView.isUserInteractionEnabled = true
        })
        
        self.present(addLinkToList, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkManager = appDelegate.linkManager
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.contentInset = UIEdgeInsets.zero
        self.automaticallyAdjustsScrollViewInsets = false
        
        linkManager?.loadLinks()
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.linkManager!.link.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        
        // set the text from the data model and Configure the cell
        if let link = self.linkManager?.link[indexPath.row] {
        cell.textLabel?.text = link.fileName + " from " + link.site + " using " + link.protocolType
        }
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.isUserInteractionEnabled = false
        self.statusLabel.text = "Status: Downloading..."
        self.resultsTextArea.text = ""
        
        if let link = linkManager?.link
        {
            downloadedFileLogData = DownloadedFile(dateStarted: Date(), url: link[indexPath.row].url, protocolType: link[indexPath.row].protocolType, site: link[indexPath.row].site, fileName: link[indexPath.row].fileName)
        
        self.downloadFileAlamoFire(url: link[indexPath.row].url)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func enableStuff() {
        self.progressView.setProgress(0, animated: false)
        self.progressView.isHidden = false
        self.percentageLabel.text = "0%"
        self.percentageLabel.isHidden = false
        self.statusLabel.isHidden = false
    }
    
    func downloadFileAlamoFire(url: String) {
        enableStuff()
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL: URL = documentsURL.appendingPathComponent("test.file")
            //self.appendDebugLog(logText: fileURL.absoluteString)
            return (fileURL, [.createIntermediateDirectories, .removePreviousFile])
        }
        
        Alamofire.download(url, method: .get, to: destination)
            .response { response in
                let debugText = String(describing: response.request) + "\n" + String(describing: response.response) + "\n" + String(describing: response.temporaryURL) + "\n" + String(describing: response.destinationURL) + "\n" + String(describing: response.error)
                self.appendDebugLog(logText: debugText)
                
                //                print(response.request)
                //                print(response.response)
                //                print(response.temporaryURL)
                //                print(response.destinationURL)
                //                print(response.error)
                
                if response.error != nil {
                    self.statusLabel.text = "Status: Failed with error"
                    self.downloadedFileLogData?.status = false
                    self.tableView.isUserInteractionEnabled = true
                }
            }
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                
                // Send the tread to the foreground (need to do this will all closures because closures runs in the background)
                DispatchQueue.main.async {
                    let progressText = String.init(format: "%0.2f %%", progress.fractionCompleted * 100)
                    self.percentageLabel.text = progressText
                    self.progressView.setProgress(Float(progress.fractionCompleted), animated: true)
                }
                print("Progress: \(progress.fractionCompleted * 100)")
                
            }
            
            .responseJSON { response in
                debugPrint(response)
                self.appendDebugLog(logText: response.debugDescription)
            }
            
            .validate {request, response, temporaryURL, destinationURL in
                
                
                DispatchQueue.main.async {
                    self.tableView.isUserInteractionEnabled = true
                    self.statusLabel.text = "Status: Downloaded"
                    self.downloadedFileLogData?.status = true
                    self.linkManager?.file.append(self.downloadedFileLogData!)
                }
                    self.downloadedFileLogData?.dateFinished = Date()
                return .success
        }

    }
    
    func appendDebugLog(logText: String) {
        DispatchQueue.main.async {
            self.resultsTextArea.text = self.resultsTextArea.text + "\n" + logText
        }
    }
    
    // Function to validate if the URL can be opened
    func canOpenURL(string: String?) -> Bool {
        guard let urlString = string else {return false}
        guard let url = NSURL(string: urlString) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {return false}
        
        //
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
}
