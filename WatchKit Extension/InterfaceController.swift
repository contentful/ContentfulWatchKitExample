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
    var locations = Locations()
    var newsItems: [Location]!
    @IBOutlet weak var newsTable: WKInterfaceTable!

    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        return newsItems[rowIndex]
    }

    override func willActivate() {
        WKInterfaceController.openParentApplication([NSObject:AnyObject]()) {
            (replyInfo, error) -> Void in
            if let error = error {
                NSLog("Error: %@", error)
            }

            var location = self.locations.defaultCoordinate
            if let replyInfo = replyInfo {
                if let locationData = replyInfo["currentLocation"] as? NSData {
                    locationData.getBytes(&location, length: sizeof(CLLocationCoordinate2D))
                }
            }

            NSLog("Current location: %.5f, %5.f", location.latitude, location.longitude)

            self.fetchEntries(location)
        }
    }

    func fetchEntries(location: CLLocationCoordinate2D) {
        locations.fetchEntries(location) { (locations) in
            self.newsItems = locations
            self.newsTable.setNumberOfRows(count(self.newsItems), withRowType: "NewsTableRowController")

            for (index, location) in enumerate(self.newsItems) {
                let row = self.newsTable.rowControllerAtIndex(index) as! NewsTableRowController

                row.distanceLabel.setText(String(format: "%.0fm", location.distance))
                row.nameLabel.setText((location.entry.fields as NSDictionary)["nameOfBar"] as? String)
            }
        }
    }
}
