//
//  ViewController.swift
//  WatchKitExample
//
//  Created by Boris Bügling on 19/11/14.
//  Copyright (c) 2014 Contentful GmbH. All rights reserved.
//

import UIKit

extension UIViewController {
    func refresh() {
        fatalError("Should never be called.")
    }
}

class WrappedItems: NSObject {
    var items: [AnyObject]!
}

class ViewController: CDAMapViewController, MKMapViewDelegate {
    let locations = Locations()
    var places: [Location]?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        coordinateFieldIdentifier = "location"
        titleFieldIdentifier = "nameOfBar"
    }

    func entries() -> WrappedItems {
        let w = WrappedItems()
        w.items = places?.map { $0.entry }
        return w
    }

    override func viewWillAppear(animated: Bool) {
        mapView.delegate = self
        mapView.showsUserLocation = true

        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        delegate.currentLocationCallback = { (location) in
            self.locations.fetchEntries(location) { (locations) in
                self.places = locations
                self.refresh()
            }
        }
    }

    // MARK: MKMapViewDelegate

    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        if let details = storyboard?.instantiateViewControllerWithIdentifier("DetailsViewController") as? DetailsViewController {
            let annotation = unsafeBitCast(view.annotation, NSObject.self)
            let identifier = annotation.valueForKey("identifier") as NSString
            details.location = places?.filter { $0.entry.identifier == identifier }.first
            presentViewController(details, animated: true, completion: nil)
        }
    }
}
