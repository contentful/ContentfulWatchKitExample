//
//  Locations.swift
//  WatchKitExample
//
//  Created by Boris Bügling on 09/04/15.
//  Copyright (c) 2015 Contentful GmbH. All rights reserved.
//

import CoreLocation

struct Location {
    let distance: Double
    let entry: CDAEntry
}

struct Locations {
    let defaultCoordinate = CLLocationCoordinate2D(latitude: 52.52191, longitude: 13.413215)
    let client: CDAClient

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
                let entries = array.items as [CDAEntry]

                if entries.count == 0 {
                    self.fetchEntries(self.defaultCoordinate, handler)
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
