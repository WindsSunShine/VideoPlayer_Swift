//
//  ViewController.swift
//  VideoPlayer_Swift
//
//  Created by 张建军 on 16/9/19.
//  Copyright © 2016年 张建军. All rights reserved.
//

import UIKit

class ViewController: VideoBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
          setupVideoBackground()
    }
    
    
    func setupVideoBackground() {
        let url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("moments", ofType: "mp4")!)
        videoFrame = view.frame
        fillMode = .ResizeAspectFill
        alwaysRepeat = true
        sound = true
        startTime = 2.0
        alpha = 0.8
        contentURL = url
      
        view.userInteractionEnabled = false
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

