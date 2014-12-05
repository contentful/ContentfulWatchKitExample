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

    func generateLoadingAnimation() {
        let sheet = UIImage(named: "activity-medium")
        var images = [UIImage]()

        for (var currentX = 0; currentX < Int(sheet!.size.width); currentX += 30) {
            let splitRef = CGImageCreateWithImageInRect(sheet?.CGImage, CGRect(x: CGFloat(currentX), y: 0.0, width: 30.0, height: sheet!.size.height * 2))
            images.append(UIImage(CGImage: splitRef)!)
        }

        let image = UIImage.animatedImageWithImages(images, duration: 0.1)

        firstImage.setImage(image)
        firstImage.startAnimating()

        secondImage.setImage(image)
        secondImage.startAnimating()
    }

    override init(context: AnyObject?) {
        super.init(context: context)

        if (self.context.fields["images"] == nil) {
            return
        }

        let images = self.context.fields["images"] as [CDAAsset]

        if images.count == 0 {
            return
        }

        generateLoadingAnimation()

        fetchAsset(images[0], completionHandler: { (image) in
            if images.count == 1 {
                self.firstImage.stopAnimating()
                self.firstImage.setImage(image)
                return
            }

            self.fetchAsset(images[1], completionHandler: { (image2) in
                self.firstImage.stopAnimating()
                self.firstImage.setImage(image)

                self.secondImage.stopAnimating()
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
