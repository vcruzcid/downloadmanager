//
//  LinksManager.swift
//  DownloadManager
//
//  Created by Victor Cruz on 7/11/17.
//  Copyright © 2017 Cruz Cid Consultores Asociados. All rights reserved.
//

import Foundation

class LinkManager {
    var link: [DownloadLink] = []
    var file: [DownloadedFile] = []
    
    func loadLinks() {
            let link1 = DownloadLink(url: "https://www.dropbox.com/s/pz71oox28q1jfo4/iOScapture.appcomnfig.pcap?dl=1", protocolType: "HTPPS", site: "Dropbox", fileName: "iOScapture.pcap")
            let link2 = DownloadLink(url: "https://supporthelper.cs.mobileiron.com/vcruz-download-test.bin", protocolType: "HTTPS", site: "MobileIron", fileName: "1GBFile.bin")
            let link3 = DownloadLink(url: "https://supporthelper.cs.mobileiron.com/vcruz-download-test-512m.bin", protocolType: "HTTPS", site: "MobileIron", fileName: "512MBFile.bin")
            let link4 = DownloadLink(url: "http://ipv4.download.thinkbroadband.com/50MB.zip", protocolType: "HTTP", site: "ThinkBroadband", fileName: "50MB File")
            //let link4 = DownloadLink(url: "https://f5geomart.cloud.pge.com/arcgis/rest/directories/arcgisjobs/downloadreplica_gpserver/j93b7ce648aa14073adc6c530bb64ba20/scratch/Color.zip", protocolType: "HTTPS", site: "PG&E Internal Geomart", fileName: "Color.zip")
        link += [link1,link2,link3,link4]
    }
}
