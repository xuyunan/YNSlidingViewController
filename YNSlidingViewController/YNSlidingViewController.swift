//
//  YNSlidingViewController.swift
//  YNSlidingViewController
//
//  Created by Tommy on 14/11/27.
//  Copyright (c) 2014年 xu_yunan@163.com. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var slidingViewController: YNSlidingViewController? {
        get {
            var parentViewController = self.parentViewController
            while let prarentVC = parentViewController {
                if prarentVC.isKindOfClass(YNSlidingViewController.self) {
                    return prarentVC as? YNSlidingViewController
                }
                parentViewController = prarentVC.parentViewController
            }
            return nil
        }
    }
}

enum YNSlidingState: Int {
    case Left
    case Center
}

class YNSlidingViewController: UIViewController {

    var leftViewController: UIViewController
    var centerViewController: UIViewController {
        willSet {
            centerViewController.willMoveToParentViewController(nil)
            centerViewController.removeFromParentViewController()
            centerViewController.view.removeFromSuperview()
        }
        didSet {
            let newCenterViewFrame = centerViewController.view.frame
            centerViewController.view.frame = CGRectMake(maximumLeftViewWidth, newCenterViewFrame.origin.y, newCenterViewFrame.width, newCenterViewFrame.height)
            self.addChildViewController(centerViewController)
            self.view.addSubview(centerViewController.view)
            
            openCenter()
        }
    }
    
    let panGesture = UIPanGestureRecognizer()
    let tapGesture = UITapGestureRecognizer()
    
    var enable: Bool = true {
        willSet {
            self.panGesture.enabled = newValue
        }
    }
    
    var centerPanRect: CGRect = CGRectNull      // centerViewContrller.view.Frame
    var translatedPoint: CGPoint = CGPointZero  // swipe distance (x, y)
    
    let screenSize = UIScreen.mainScreen().bounds.size
    var maximumLeftViewPercentWidth: CGFloat = 0.8
    
    var fullDuration : NSTimeInterval = 0.4
    
    var maximumLeftViewWidth: CGFloat {
        get {
            return maximumLeftViewPercentWidth * screenSize.width
        }
    }
    
    let minimumSwipeXVelocity: CGFloat = 500    // min velocity x value (gestureRecognizer.velocityInView())
    let minimumSwipeDistance: CGFloat = 60

    var state: YNSlidingState = YNSlidingState.Center
    
    init(leftViewController: UIViewController!, centerViewController: UIViewController!) {
        self.leftViewController = leftViewController
        self.centerViewController = centerViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.blackColor()
        
        self.addChildViewController(self.leftViewController)
        self.addChildViewController(self.centerViewController)
        self.view.addSubview(leftViewController.view)
        self.view.addSubview(centerViewController.view)
        
        var newFrame = self.leftViewController.view.frame
        newFrame.size.width = screenSize.width * maximumLeftViewPercentWidth
        self.leftViewController.view.frame = newFrame
        
        panGesture.addTarget(self, action: "handlePanGesture:")
        self.view.addGestureRecognizer(panGesture)
        tapGesture.addTarget(self, action: "handleTapGesture:")
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }

    func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {

        switch gestureRecognizer.state {
        case .Began:
            
            centerPanRect = centerViewController.view.frame
            translatedPoint = CGPointZero
            self.view.userInteractionEnabled = false
            
        case .Changed:
            
            translatedPoint = gestureRecognizer.translationInView(self.view)
            
            var newFrame = self.centerPanRect
            newFrame.origin.x = CGRectGetMinX(newFrame) +  translatedPoint.x
            newFrame = CGRectIntegral(newFrame)
            
            if newFrame.origin.x < 0 || newFrame.origin.x > maximumLeftViewWidth {
                return
            }

            centerViewController.view.frame = newFrame;
            
        case .Cancelled, .Ended:
            
            self.centerPanRect = CGRectNull
            
            let velocity = gestureRecognizer.velocityInView(self.view)
            self.finishAnimationForPanGestureWithXVelocity(velocity.x, xOffset: translatedPoint.x)
            
            self.view.userInteractionEnabled = true
            
        default:
            return
        }
    }
    
    func finishAnimationForPanGestureWithXVelocity(xVelocity: CGFloat, xOffset: CGFloat) {
        
        if xOffset > 0 && state == YNSlidingState.Left { return }

        var duration: NSTimeInterval = fullDuration * NSTimeInterval(currentSwipePercent())
        if xOffset > 0 && (xVelocity > minimumSwipeXVelocity || xOffset > minimumSwipeDistance) {    // open
            duration = fullDuration - duration
            openLeft()
        } else {            // close
            openCenter()
        }
    }
    
    func handleTapGesture(gestureRecognizer: UITapGestureRecognizer) {
        
        if state == YNSlidingState.Center { return }
        
        switch gestureRecognizer.state {
        case .Cancelled, .Ended:
            let touchPoint = gestureRecognizer.locationInView(self.view)
            if CGRectContainsPoint(centerViewController.view.frame, touchPoint) {
                openCenter()
            }
        default:
            return
        }
    }
    
    func openLeft() {
        
        state = YNSlidingState.Left
        
        var duration: NSTimeInterval = fullDuration * NSTimeInterval(currentSwipePercent())
        var newFrame = self.centerViewController.view.frame
        
        UIView.animateWithDuration(fullDuration - duration,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: { () -> Void in
                newFrame.origin.x = self.maximumLeftViewWidth
                newFrame = CGRectIntegral(newFrame)
                self.centerViewController.view.frame = newFrame
            },
            completion: { (finish) -> Void in
                
        })
    }
    
    func openCenter() {
        
        state = YNSlidingState.Center
        
        var duration: NSTimeInterval = fullDuration * NSTimeInterval(currentSwipePercent())
        var newFrame = self.centerViewController.view.frame
        
        UIView.animateWithDuration(duration,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: { () -> Void in
                newFrame.origin.x = 0
                newFrame = CGRectIntegral(newFrame)
                self.centerViewController.view.frame = newFrame
            },
            completion: { (finish) -> Void in
                
        })
    }
    
    func currentSwipePercent() -> CGFloat {
        return min(self.centerViewController.view.frame.origin.x, maximumLeftViewWidth) / maximumLeftViewWidth
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
