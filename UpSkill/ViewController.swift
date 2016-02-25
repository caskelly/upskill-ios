//
//  ViewController.swift
//  UpSkill
//
//  Created by Christopher Skelly on 8/6/15.
//  Copyright (c) 2015 Fourthlock. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let url = NSURL (string: "http://upskill.us");
        let requestObj = NSURLRequest(URL: url!);
                
        webView.loadRequest(requestObj);
        webView.scrollView.bounces = false;
        webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
 
        webView.opaque = true;
        webView.backgroundColor = UIColor.blackColor();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

