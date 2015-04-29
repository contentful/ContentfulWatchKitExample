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
        CLLocationManager().requestWhenInUseAuthorization()

        mapView.delegate = self
        mapView.showsUserLocation = true

        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        delegate.currentLocationCallback = { (location) in
            self.locations.fetchEntries(location) { (locations) in
                if self.locations.usesDefaultCoordinate {
                    self.mapView.showsUserLocation = false

                    if (self.presentedViewController != nil) {
                        return
                    }

                    let alert = UIAlertController(title: "Unsupported city", message: "Great that you like to use Brew, but locations are currently limited to Berlin, San Francisco and New York. To give you a preview, we are showing you some bars in Berlin.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }

                self.places = locations
                self.refresh()
            }
        }
    }

    // MARK: MKMapViewDelegate

    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        if let details = storyboard?.instantiateViewControllerWithIdentifier("DetailsViewController") as? DetailsViewController, view = view {
            let annotation = unsafeBitCast(view.annotation, NSObject.self)
            let identifier = annotation.valueForKey("identifier") as! NSString

            if let location = (places?.filter { $0.entry.identifier == identifier }.first) {
                details.location = location
                presentViewController(details, animated: true) {
                    self.mapView.deselectAnnotation(view.annotation, animated: false)
                }
            }
        }
    }
}
