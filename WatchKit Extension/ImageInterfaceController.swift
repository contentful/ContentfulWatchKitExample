//
//  ImageInterfaceController.swift
//  WatchKitExample
//
//  Created by Boris Bügling on 25/11/14.
//  Copyright (c) 2014 Contentful GmbH. All rights reserved.
//

import WatchKit

class ImageInterfaceController:BaseInterfaceController {
    @IBOutlet weak var firstImage: WKInterfaceImage!
    @IBOutlet weak var secondImage: WKInterfaceImage!

    override init(context: AnyObject?) {
        super.init(context: context)

        if (self.context.fields["images"] == nil) {
            return
        }

        let images = self.context.fields["images"] as [CDAAsset]

        if images.count == 0 {
            return
        }

        fetchAsset(images[0], completionHandler: { (image) in
            if images.count == 1 {
                self.firstImage.setImage(image)
                return
            }

            self.fetchAsset(images[1], completionHandler: { (image2) in
                self.firstImage.setImage(image)
                self.secondImage.setImage(image2)
            })
        })
    }

    func fetchAsset(asset: CDAAsset, completionHandler: (UIImage!) -> Void) {
        if asset.URL == nil {
            return
        }

        let request = NSURLRequest(URL: asset.imageURLWithSize(CGSize(width: 200, height: 200)))

        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            (response, data, error) -> Void in
            if (data == nil) {
                return
            }

            completionHandler(UIImage(data: data))
        }
    }
}
