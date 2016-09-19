//
//  VideoBaseViewController.swift
//  VideoPlayer_Swift
//
//  Created by 张建军 on 16/9/19.
//  Copyright © 2016年 张建军. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

public enum ScalingMode {
    
    case Resize
    case ResizeAspect
    case ResizeAspectFill
    
}

class VideoBaseViewController: UIViewController {


    private let moviePlayer = AVPlayerViewController()
    
    private var moviePlayerSoundLevel: Float = 1.0
//   访问限制符：：可以访问自己模块中源文件里的任何实体，但是别人不能访问该模块中源文件里的实体。 
    internal var contentURL: NSURL = NSURL(){
      
        didSet {
            
            setMoviePlayer(contentURL)
            
        }
        
    }
    
    
    public var videoFrame: CGRect = CGRect()
    
    public var startTime: CGFloat = 0.0
    
    public var duration: CGFloat = 0.0
    
    public var backgroundColor: UIColor = UIColor.blackColor()
        {
            didSet {
                
               view.backgroundColor = backgroundColor
            }
    }
    
    
    public var sound: Bool = true {
       
        didSet {
            
            if sound {
                
                moviePlayerSoundLevel = 1.0
            }else{
            
                moviePlayerSoundLevel = 0.0
            
            }
            
        }
    
    }
    
    public var alpha: CGFloat = CGFloat() {
        
        didSet {
            
            moviePlayer.view.alpha = alpha
        }
    
    }
    
    
    public var  alwaysRepeat: Bool = true {
        
        didSet {
            
            if alwaysRepeat {
                
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VideoBaseViewController.playerItemDidReachEnd), name: AVPlayerItemDidPlayToEndTimeNotification, object: moviePlayer.player?.currentItem)
                
            }
            
        }
        
    }
    
    
    public var fillMode: ScalingMode = .ResizeAspectFill {
        
//    didSet这两个特性来监视属性的除初始化之外的属性值变化 在ScalingMode 的属性变化后做的处理
        didSet {
            switch fillMode {
            case .Resize:
                moviePlayer.videoGravity = AVLayerVideoGravityResize
            case .ResizeAspect:
                moviePlayer.videoGravity = AVLayerVideoGravityResizeAspect
            case .ResizeAspectFill:
                moviePlayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            }
 
            
        }
        
    }
    
    
    override public func viewDidAppear(animated: Bool) {
        moviePlayer.view.frame = videoFrame
        moviePlayer.showsPlaybackControls = false
        view.addSubview(moviePlayer.view)
        view.sendSubviewToBack(moviePlayer.view)
    }
    
    
    override public func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
    private func setMoviePlayer(url: NSURL) {
        
        
        let videoTool  = VideoTool()
        
        videoTool.cropVideoWithUrl(videoUrl: url, startTime: startTime, duration: duration) { (videoPath, error) in
            
            if let path  = videoPath as NSURL? {
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    
                   dispatch_async(dispatch_get_main_queue(), {
                    
                    self.moviePlayer.player = AVPlayer(URL: path)
                    
                    self.moviePlayer.player?.play()
                    self.moviePlayer.player?.volume  = self.moviePlayerSoundLevel
                    
                   })
                    
                }
                
                
            }
            
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func playerItemDidReachEnd() {
        moviePlayer.player?.seekToTime(kCMTimeZero)
        moviePlayer.player?.play()
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
