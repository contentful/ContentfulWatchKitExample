//
//  InterfaceController.swift
//  WatchKitExample WatchKit Extension
//
//  Created by Boris Bügling on 19/11/14.
//  Copyright (c) 2014 Contentful GmbH. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    var client: CDAClient!
    var newsItems: [CDAEntry]!
    @IBOutlet weak var newsTable: WKInterfaceTable!

    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        return newsItems[rowIndex]
    }

    override init(context: AnyObject?) {
        super.init(context: context)

        client = CDAClient(spaceKey: "exembnlnz9oo", accessToken: "2ec43b32ffdda511b09abfd6a5b8ff65125cd19a4f6377d6a1e9540d34120052")

        client.fetchEntriesMatching(["content_type": "6LmYY0rGhOaUyweiwSm4m", "order": "-sys.createdAt", "fields.visible": true],
            success: { (response, array) -> Void in
                self.newsItems = array.items as [CDAEntry]

                self.newsTable.setNumberOfRows(countElements(self.newsItems), withRowType: "NewsTableRowController")

                for (index, entry) in enumerate(self.newsItems) {
                    let row = self.newsTable.rowControllerAtIndex(index) as NewsTableRowController

                    row.interfaceLabel.setText((entry.fields as NSDictionary)["nameOfBar"] as? String)
                }
            }) { (reponse, error) -> Void in
                NSLog("@Error: %@", error)
        }
    }
}
