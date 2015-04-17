//
//  Locations.swift
//  WatchKitExample
//
//  Created by Boris Bügling on 09/04/15.
//  Copyright (c) 2015 Contentful GmbH. All rights reserved.
//

import CoreLocation

func +=(left: NSMutableAttributedString, right: String) -> NSMutableAttributedString {
    left.appendAttributedString(NSAttributedString(string: right))
    return left
}

class Location {
    let distance: Double
    let entry: CDAEntry

    init(distance: Double, entry: CDAEntry) {
        self.distance = distance
        self.entry = entry
    }

    let footnoteColor = UIColor(red: 55.0/255.0, green: 108.0/255.0, blue: 191.0/255.0, alpha: 1.0)

    var centerOpeningHours = true
    var longDescription: NSAttributedString {
        var labelText = NSMutableAttributedString(string: "")

        for field in ["typeOfPlace", "useopeninghours", "beerTypesServed"] {
            if let value: AnyObject = entry.fields[field] {
                if (field == "beerTypesServed") {
                    labelText += "🍻 "
                }

                let location = labelText.length

                labelText += value as! String
                labelText += "\n"

                if (field == "useopeninghours") {
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .Center
                    let textRange = NSMakeRange(location, value.length)

                    labelText.addAttribute(NSForegroundColorAttributeName, value: footnoteColor, range: textRange)
                    labelText.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(12.0), range: textRange)
                    if centerOpeningHours {
                        labelText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: textRange)
                    }
                }
            }
        }

        labelText += "\n"

        if let value: AnyObject = entry.fields["smoking"]  {
            if (value as! NSNumber).boolValue {
                labelText += "🚬 allowed\n"
            } else {
                labelText += "No smoking 🚫\n"
            }
        }

        if let value: AnyObject = entry.fields["MG5chCyoh2miXeaz"]  {
            if (value as! NSNumber).boolValue {
                labelText += "Sit outdoors? 👍\n"
            } else {
                labelText += "Sit outdoors? 👎\n"
            }
        }

        return labelText
    }
}

class Locations {
    let defaultCoordinate = CLLocationCoordinate2D(latitude: 52.52191, longitude: 13.413215)
    let client: CDAClient
    var usesDefaultCoordinate = false

    /* Valid locations:
        37.33170, -122          for SF
        40.75889, -73.98513     for NY
        52.52191, 13.413215     for Berlin
    */

    init() {
        client = CDAClient(spaceKey: "exembnlnz9oo", accessToken: "2ec43b32ffdda511b09abfd6a5b8ff65125cd19a4f6377d6a1e9540d34120052")
    }

    func fetchEntries(location: CLLocationCoordinate2D, handler: ([Location]) -> Void) {
        let userLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)

        client.fetchEntriesMatching(["content_type": "6LmYY0rGhOaUyweiwSm4m", "order": "-sys.createdAt", "fields.visible": true, "fields.location[within]": [ location.latitude, location.longitude, 1000 ] ],
            success: { (response, array) -> Void in
                let entries = array.items as! [CDAEntry]

                if entries.count == 0 {
                    self.usesDefaultCoordinate = true
                    self.fetchEntries(self.defaultCoordinate, handler: handler)
                    return
                }

                handler(sorted(entries.map { (entry) in
                    let placeLocation = entry.CLLocationCoordinate2DFromFieldWithIdentifier("location")
                    let distance = userLocation.distanceFromLocation(CLLocation(latitude: placeLocation.latitude, longitude: placeLocation.longitude))
                    return Location(distance: distance, entry: entry)
                }) { $0.distance < $1.distance })
            }) { (reponse, error) -> Void in
                NSLog("@Error: %@", error)
        }
    }
}
