//
//  MapInterfaceController.swift
//  WatchKitExample
//
//  Created by Boris Bügling on 25/11/14.
//  Copyright (c) 2014 Contentful GmbH. All rights reserved.
//

import WatchKit

class MapInterfaceController: BaseInterfaceController {
    @IBOutlet weak var mapView: WKInterfaceMap!

    override init(context: AnyObject?) {
        super.init(context: context)

        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
        let location = self.context.CLLocationCoordinate2DFromFieldWithIdentifier("location")

        mapView.addAnnotation(location, withPinColor: .Red)
        mapView.setCoordinateRegion(MKCoordinateRegion(center: location, span: coordinateSpan))
        mapView.setMapRect(MKMapRect(origin: MKMapPointForCoordinate(location),
            size: MKMapSize(width: coordinateSpan.latitudeDelta, height: coordinateSpan.latitudeDelta)))
    }
}