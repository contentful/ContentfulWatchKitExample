//
//  BaseInterfaceController.swift
//  WatchKitExample
//
//  Created by Boris Bügling on 25/11/14.
//  Copyright (c) 2014 Contentful GmbH. All rights reserved.
//

import WatchKit

class BaseInterfaceController: WKInterfaceController {
    var context:Location! = nil

    @IBOutlet weak var nextButton: WKInterfaceButton!

    override init() {
        super.init()
    }

    override func contextForSegueWithIdentifier(identifier: String) -> AnyObject? {
        return context
    }

    override func awakeWithContext(context: AnyObject!) {
        self.context = context as! Location

        if let name = self.context.entry.fields["nameOfBar"] as? String {
            setTitle(name)
        } else {
            self.setTitle("🍻 Brew")
        }
    }

    @IBAction func homeTapped() {
        self.popToRootController()
    }
}
