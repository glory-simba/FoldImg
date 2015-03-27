//
//  ViewController.swift
//  FoldImg
//
//  Created by Aaron on 3/27/15.
//  Copyright (c) 2015 Aaron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var upView: UIView!
    @IBOutlet weak var downView: UIView!

    var initLocation = CGPoint()
    var foldView = UIView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let dogImg = UIImage(named: "dogImg")
        if let hasDogImg = dogImg
        {
            addSpriteImg(hasDogImg, contentRect: CGRectMake(0.0, 0.0, 1.0, 0.5), toLayer: upView.layer)
            addSpriteImg(hasDogImg, contentRect: CGRectMake(0.0, 0.5, 1.0, 0.5), toLayer: downView.layer)
            
            upView.layer.anchorPoint = CGPointMake(0.5, 1)
            downView.layer.anchorPoint = CGPointMake(0.5, 0)
        }
    }
    
    func addSpriteImg(img: UIImage, contentRect: CGRect, toLayer layer: CALayer)
    {
        layer.contents = img.CGImage
        layer.contentsGravity = kCAGravityResizeAspect
        layer.contentsRect = contentRect
    }
    
    @IBAction func pan(panGesture: UIPanGestureRecognizer)
    {
        let location = panGesture.locationInView(containerView)
        if  panGesture.state == .Began
        {
            initLocation = location
            if isinitLocationWithinUp()
            {
                foldView = upView
                upView.layer.zPosition = 100
                downView.layer.zPosition = 0
            }
            else
            {
                foldView = downView
                upView.layer.zPosition = 0
                downView.layer.zPosition = 100
            }
        }
        
        if (isLocation(location, inView: containerView))
        {
            let path = location.y - initLocation.y
            let angle: CGFloat = -path / 200 * CGFloat(M_PI)
            UIView.animateWithDuration(0.1){
                self.transform3d(self.foldView.layer, angle: angle)
            }
            if panGesture.state == .Ended ||
                panGesture.state == .Cancelled
            {
                reset(foldView.layer)
            }
        }
        else
        {
            reset(foldView.layer)
        }
    }
    
    func isLocation(location: CGPoint, inView view: UIView) -> Bool
    {
        if (location.x>0 && location.x<CGRectGetWidth(view.frame)) &&
           (location.y > 0 && location.y < CGRectGetHeight(view.frame))
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func isinitLocationWithinUp() -> Bool
    {
        if (initLocation.x>0 && initLocation.x<200) &&
           (initLocation.y>0 && initLocation.y<100)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func reset(layer: CALayer)
    {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.transform3d(layer, angle: 0)
            }){if $0{}}
    }
    
    func transform3d(layer: CALayer, angle: CGFloat)
    {
        var transform = CATransform3DIdentity
        transform.m34 = -1.0/500.0
        transform = CATransform3DRotate(transform, angle, 1, 0, 0)
        layer.transform = transform
    }
}

