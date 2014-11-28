//
//  MoreViewController.swift
//  YNSlidingViewController
//
//  Created by Tommy on 14/11/27.
//  Copyright (c) 2014年 xu_yunan@163.com. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(rgbValue: 0xcc3300)
        
        // for test
        let indexButton = UIButton(frame: CGRectMake(0, 100, 200, 40))
        indexButton.setTitle("Index Page", forState: UIControlState.Normal)
        indexButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        indexButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Highlighted)
        indexButton.addTarget(self, action: "indexButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(indexButton)
        
        let button = UIButton(frame: CGRectMake(100, 220, 200, 40))
        button.setTitle("Setting Page", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.redColor(), forState: UIControlState.Highlighted)
        button.addTarget(self, action: "settingButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    func indexButtonClicked(id: UIButton) {
        let vc = IndexViewController()
        let centerNavContrller = UINavigationController(rootViewController: vc)
        centerNavContrller.navigationBar.barTintColor = UIColor(rgbValue: 0x0099cc)
        self.slidingViewController?.centerViewController = centerNavContrller
    }
    
    func settingButtonClicked(id: UIButton) {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.orangeColor()
        vc.title = "Setting"
        let centerNavContrller = UINavigationController(rootViewController: vc)
        centerNavContrller.navigationBar.barTintColor = UIColor(rgbValue: 0x0099cc)
        self.slidingViewController?.centerViewController = centerNavContrller
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
