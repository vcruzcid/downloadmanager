//
//  DownloadLinks.swift
//  DownloadManager
//
//  Created by Victor Cruz on 7/11/17.
//  Copyright © 2017 Cruz Cid Consultores Asociados. All rights reserved.
//

import Foundation

class DownloadLinks: {
    
    var url: String
    var type: String
    var site: String

    init(url:String, type: String, site:String) {
        self.url = url
        self.type = type
        self.site = site
    }
}
