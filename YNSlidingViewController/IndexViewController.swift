//
//  IndexViewController.swift
//  YNSlidingViewController
//
//  Created by Tommy on 14/11/27.
//  Copyright (c) 2014年 xu_yunan@163.com. All rights reserved.
//

import UIKit

class IndexViewController: UIViewController {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.slidingViewController?.enable = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.slidingViewController?.enable = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Index"
        self.view.backgroundColor = UIColor.whiteColor()
        
        let leftItem = UIBarButtonItem(image: UIImage(named: "more.pdf"), style: UIBarButtonItemStyle.Plain, target: self, action: "barButtonClicked")
        self.navigationItem.leftBarButtonItem = leftItem
        
        // for test
        let button = UIButton(frame: CGRectMake(100, 220, 200, 40))
        button.setTitle("push", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.redColor(), forState: UIControlState.Highlighted)
        button.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    func barButtonClicked() {
        if let slidingVC = self.slidingViewController {
            slidingVC.openLeft()
        }
    }

    func buttonClicked(id: UIButton) {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.orangeColor()
        self.navigationController?.pushViewController(vc, animated: true)
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
