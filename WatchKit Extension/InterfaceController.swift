//
//  InterfaceController.swift
//  WatchKitExample WatchKit Extension
//
//  Created by Boris Bügling on 19/11/14.
//  Copyright (c) 2014 Contentful GmbH. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController, CLLocationManagerDelegate {

    var client: CDAClient
    var newsItems: [CDAEntry]!
    @IBOutlet weak var newsTable: WKInterfaceTable!

    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        return newsItems[rowIndex]
    }

    override init() {
        client = CDAClient(spaceKey: "exembnlnz9oo", accessToken: "2ec43b32ffdda511b09abfd6a5b8ff65125cd19a4f6377d6a1e9540d34120052")

        super.init()
    }

    override func willActivate() {
        let userDefaults = NSUserDefaults(suiteName: "group.com.contentful.WatchKitExample")
        userDefaults!.synchronize()
        let locationData = userDefaults!.dataForKey("currentLocation")

        var location = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        if let locationData = locationData {
            locationData.getBytes(&location, length: sizeof(CLLocationCoordinate2D))
        }

        NSLog("Current location: %.5f, %5.f", location.latitude, location.longitude)

        /* Valid locations:
            37.33170, -122          for SF
            40.75889, -73.98513     for NY
            52.52191, 13.413215     for Berlin
         */

        fetchEntries(location)
    }

    func fetchEntries(location: CLLocationCoordinate2D) {
        client.fetchEntriesMatching(["content_type": "6LmYY0rGhOaUyweiwSm4m", "order": "-sys.createdAt", "fields.visible": true, "fields.location[within]": [ location.latitude, location.longitude, 1000 ] ],
            success: { (response, array) -> Void in
                self.newsItems = array.items as! [CDAEntry]

                if self.newsItems.count == 0 {
                    self.fetchEntries(CLLocationCoordinate2D(latitude: 52.52191, longitude: 13.413215))
                    return
                }

                self.newsTable.setNumberOfRows(count(self.newsItems), withRowType: "NewsTableRowController")

                for (index, entry) in enumerate(self.newsItems) {
                    let row = self.newsTable.rowControllerAtIndex(index) as! NewsTableRowController

                    row.interfaceLabel.setText((entry.fields as NSDictionary)["nameOfBar"] as? String)
                }
            }) { (reponse, error) -> Void in
                NSLog("@Error: %@", error)
        }
    }
}
