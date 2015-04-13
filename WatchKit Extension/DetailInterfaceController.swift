//
//  DetailInterfaceController.swift
//  WatchKitExample
//
//  Created by Boris Bügling on 19/11/14.
//  Copyright (c) 2014 Contentful GmbH. All rights reserved.
//

import WatchKit

class DetailInterfaceController: BaseInterfaceController {
    @IBOutlet weak var textLabel: WKInterfaceLabel!
    @IBOutlet weak var titleLabel: WKInterfaceLabel!

    override func awakeWithContext(context: AnyObject!) {
        super.awakeWithContext(context);

        nextButton.setTitle("Photos")
        textLabel.setAttributedText(self.context.longDescription)
        titleLabel.setText(self.context.entry.fields["nameOfBar"] as? String)
    }
}