//
//  DetailInterfaceController.swift
//  WatchKitExample
//
//  Created by Boris Bügling on 19/11/14.
//  Copyright (c) 2014 Contentful GmbH. All rights reserved.
//

import WatchKit

func +=(left: NSMutableAttributedString, right: String) -> NSMutableAttributedString {
    left.appendAttributedString(NSAttributedString(string: right))
    return left
}

class DetailInterfaceController: BaseInterfaceController {
    let footnoteColor = UIColor(red: 55.0/255.0, green: 108.0/255.0, blue: 191.0/255.0, alpha: 1.0)

    @IBOutlet weak var textLabel: WKInterfaceLabel!
    @IBOutlet weak var titleLabel: WKInterfaceLabel!

    override func awakeWithContext(context: AnyObject!) {
        super.awakeWithContext(context);

        nextButton.setTitle("Photos")
        titleLabel.setText(self.context.fields["nameOfBar"] as? String)

        var labelText = NSMutableAttributedString(string: "")

        for field in ["typeOfPlace", "useopeninghours", "beerTypesServed"] {
            if let value: AnyObject = self.context.fields[field] {
                if (field == "beerTypesServed") {
                    labelText += "🍻 "
                }

                let location = labelText.length

                labelText += value as String
                labelText += "\n"

                if (field == "useopeninghours") {
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .Center
                    let textRange = NSMakeRange(location, value.length)

                    labelText.addAttribute(NSForegroundColorAttributeName, value: footnoteColor, range: textRange)
                    labelText.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(12.0), range: textRange)
                    labelText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: textRange)
                }
            }
        }

        labelText += "\n"

        if let value: AnyObject = self.context.fields["smoking"]  {
            if (value as! NSNumber).boolValue {
                labelText += "🚬 allowed\n"
            } else {
                labelText += "No smoking 🚫\n"
            }
        }

        if let value: AnyObject = self.context.fields["MG5chCyoh2miXeaz"]  {
            if (value as! NSNumber).boolValue {
                labelText += "Sit outdoors? 👍\n"
            } else {
                labelText += "Sit outdoors? 👎\n"
            }
        }

        textLabel.setAttributedText(labelText)
    }
}