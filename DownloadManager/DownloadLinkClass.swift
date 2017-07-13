//
//  DownloadLinkClass.swift
//  DownloadManager
//
//  Created by Victor Cruz on 7/11/17.
//  Copyright © 2017 Cruz Cid Consultores Asociados. All rights reserved.
//

import Foundation

class DownloadLink: NSObject {
    var url: String
    var protocolType: String
    var site: String
    var fileName: String
    
    init(url:String, protocolType:String, site:String, fileName: String) {
        self.url = url
        self.protocolType = protocolType
        self.site = site
        self.fileName = fileName
        super.init()
    }
}
