//
//  DetailsViewController.swift
//  WatchKitExample
//
//  Created by Boris Bügling on 09/04/15.
//  Copyright (c) 2015 Contentful GmbH. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UIViewControllerTransitioningDelegate {
    var location: Location?

    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var firstPhotoView: UIImageView!
    @IBOutlet weak var secondPhotoView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    func imageTapped(sender: UITapGestureRecognizer) {
        if sender.view == nil {
            return
        }

        let imageInfo = JTSImageInfo()
        imageInfo.image = (sender.view as! UIImageView).image
        imageInfo.referenceRect = sender.view!.frame
        imageInfo.referenceView = view

        let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: .Image, backgroundStyle: .Scaled)
        imageViewer.showFromViewController(self, transition: ._FromOriginalPosition)
    }

    func loadAsset(asset: CDAAsset, _ imageView: UIImageView) {
        var size = imageView.frame.size
        size.width *= UIScreen.mainScreen().scale
        size.height *= UIScreen.mainScreen().scale

        imageView.offlineCaching_cda = true
        imageView.cda_setImageWithAsset(asset, size: size)

        let tapGesture = UITapGestureRecognizer(target: self, action: "imageTapped:")
        imageView.addGestureRecognizer(tapGesture)
        imageView.userInteractionEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        transitioningDelegate = self

        if let location = location {
            location.centerOpeningHours = false
            let description = NSMutableAttributedString(attributedString: location.longDescription)

            let range = NSMakeRange(0, description.length)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 10
            description.addAttribute(NSParagraphStyleAttributeName, value: style, range: range)
            description.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(16.0), range: range)

            descriptionView.attributedText = description
            titleLabel.text = location.entry.fields["nameOfBar"] as? String

            let imageViews = [firstPhotoView, secondPhotoView]
            for (index, asset) in enumerate(location.entry.fields["images"] as! [CDAAsset]) {
                if imageViews.count > index {
                    loadAsset(asset, imageViews[index])
                }
            }
        }
    }

    // MARK: UIViewControllerTransitioningDelegate

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let controller = CEPortalAnimationController()
        controller.duration = 0.2
        return controller
    }
}
