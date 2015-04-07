//
//  AppDelegate.swift
//  WatchKitExample
//
//  Created by Boris Bügling on 19/11/14.
//  Copyright (c) 2014 Contentful GmbH. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

typealias WatchKitReply = (([NSObject : AnyObject]!) -> Void)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var locationManager: CLLocationManager?
    var reply: WatchKitReply?
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        locationManager = CLLocationManager()
        locationManager!.delegate = self;
        locationManager!.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager!.distanceFilter = 1000
        locationManager!.requestAlwaysAuthorization()
        locationManager!.startUpdatingLocation()
        return true
    }

    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {

        if let reply = reply {
            if let location = locationManager?.location {
                var coordinate = location.coordinate
                reply(["currentLocation": NSData(bytes: &coordinate, length: sizeof(CLLocationCoordinate2D))])
            } else {
                self.reply = reply
            }
        }
    }

    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        if newLocation == nil {
            return
        }

        var location = newLocation!.coordinate

        if let reply = reply {
            reply(["currentLocation": NSData(bytes: &location, length: sizeof(CLLocationCoordinate2D))])
        }

        locationManager?.stopUpdatingLocation()
    }
}

