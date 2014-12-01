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

        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let location = self.context.CLLocationCoordinate2DFromFieldWithIdentifier("location")

        mapView.addAnnotation(location, withPinColor: .Red)
        mapView.setMapRect(MKMapRect(origin: MKMapPointForCoordinate(location),
            size: MKMapSize(width: 0.5, height: 0.5)))
        mapView.setCoordinateRegion(MKCoordinateRegion(center: location, span: coordinateSpan))
    }
}