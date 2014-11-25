//
//  BaseInterfaceController.swift
//  WatchKitExample
//
//  Created by Boris Bügling on 25/11/14.
//  Copyright (c) 2014 Contentful GmbH. All rights reserved.
//

import WatchKit

class BaseInterfaceController: WKInterfaceController {
    let context:CDAEntry

    override func contextForSegueWithIdentifier(identifier: String) -> AnyObject? {
        return context
    }

    override init(context: AnyObject?) {
        self.context = context as CDAEntry
        super.init(context: context)
    }

    @IBAction func homeTapped() {
        self.popToRootController()
    }
}
