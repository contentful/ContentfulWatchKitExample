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

    override init(context: AnyObject?) {
        super.init(context: context)

        titleLabel.setText(self.context.fields["nameOfBar"] as? String)

        var labelText = ""

        for field in ["typeOfPlace", "useopeninghours", "beerTypesServed"] {
            if let value: AnyObject = self.context.fields[field] {
                if (field == "useopeninghours") {
                    labelText += "Open: "
                }

                if (field == "beerTypesServed") {
                    labelText += "🍻 "
                }

                labelText += value as String
                labelText += "\n"
            }
        }

        labelText += "\n"

        if let value: AnyObject = self.context.fields["smoking"]  {
            if (value as NSNumber).boolValue {
                labelText += "🚬 allowed\n"
            } else {
                labelText += "No smoking 🚫\n"
            }
        }

        if let value: AnyObject = self.context.fields["MG5chCyoh2miXeaz"]  {
            if (value as NSNumber).boolValue {
                labelText += "Sit outdoors? 👍\n"
            } else {
                labelText += "Sit outdoors? 👎\n"
            }
        }

        textLabel.setText(labelText)
    }
}