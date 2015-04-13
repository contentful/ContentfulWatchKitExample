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

    var bgTask: UIBackgroundTaskIdentifier?
    var currentLocationCallback: ((location: CLLocationCoordinate2D) -> Void)?
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

    func applicationDidEnterBackground(application: UIApplication) {
        if self.reply == nil {
            locationManager?.stopUpdatingLocation()
        }
    }

    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        if let reply = reply {
            self.reply = reply

            bgTask = application.beginBackgroundTaskWithExpirationHandler() {
                self.endBackgroundTaskForWatchKitExtension()
            }

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                self.handleBackgroundLocationRequest()
            }
        }
    }

    func endBackgroundTaskForWatchKitExtension() {
        self.reply = nil

        if self.bgTask == nil || self.bgTask! == UIBackgroundTaskInvalid {
            return
        }

        locationManager?.stopUpdatingLocation()

        dispatch_after(2 * dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            UIApplication.sharedApplication().endBackgroundTask(self.bgTask!)
            self.bgTask = UIBackgroundTaskInvalid
        }
    }

    func handleBackgroundLocationRequest() {
        if let location = locationManager?.location {
            var coordinate = location.coordinate
            self.reply?(["currentLocation": NSData(bytes: &coordinate, length: sizeof(CLLocationCoordinate2D))])
            endBackgroundTaskForWatchKitExtension()
        } else {
            if !CLLocationManager.locationServicesEnabled() ||
                CLLocationManager.authorizationStatus() != .AuthorizedAlways {
                self.reply?(nil)
                endBackgroundTaskForWatchKitExtension()
            }
        }
    }

    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        if newLocation == nil {
            return
        }

        var location = newLocation!.coordinate

        if let currentLocationCallback = currentLocationCallback {
            currentLocationCallback(location: location)
        }

        if let reply = reply {
            reply(["currentLocation": NSData(bytes: &location, length: sizeof(CLLocationCoordinate2D))])
            endBackgroundTaskForWatchKitExtension()
        }
    }
}

