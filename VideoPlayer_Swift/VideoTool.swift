//
//  VideoTool.swift
//  VideoPlayer_Swift
//
//  Created by 张建军 on 16/9/19.
//  Copyright © 2016年 张建军. All rights reserved.
//

import UIKit
import AVFoundation

// 定义一个扩展，返回一个字符串
extension String {
    
    var convert: NSString{return (self as NSString)}
    
}

//异步提交的任务立刻返回，在后台队列中执行

//同步提交的任务在执行完成后才会返回

//并行执行（全局队列）提交到一个队列的任务，比如提交了任务1和任务2，在任务1开始执行，并且没有执行完毕时候，任务2就可以开始执行。

//串行执行（用户创建队列） 提交到一个队列中的任务，比如提交了任务1和任务2，只有任务1结束后，任务2才可执行

//注意：提交到队列中的任务是串行执行，还是并行执行由队列本身决定。

public class VideoTool: NSObject {

    public func cropVideoWithUrl(videoUrl url: NSURL, startTime: CGFloat, duration: CGFloat, completion:((videoPath: NSURL?,error: NSError?) -> Void)?){
     //对于全局队列，默认有四个，分为四个优先级                     #define DISPATCH_QUEUE_PRIORITY_HIGH  优先级最高，在default,和low之前执行                                                     #define DISPATCH_QUEUE_PRIORITY_DEFAULT 默认优先级，在low之前，在high之后        
//       #define DISPATCH_QUEUE_PRIORITY_LOW 在high和default后执行          
//      #define DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN提交到这个队列的任务会在high优先级的任务和已经提交到background队列的执行完后执行
        // 设置全局队列的优先级【默认优先级】
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
//        typealias dispatch_queue_t = NSObject //轻量级的用来描述执行任务的队列
//        typealias dispatch_block_t = () -> Void //队列执行的闭包(Objective C中的block)
        
        
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            
       let asset = AVURLAsset(URL: url, options: nil)
   
            
    //AVAssetExportSession 是对AVAsset对象内容进行转码, 并输出到制定的路径
//            asset, 参数为要转码的asset 对象,  presetName, 该参数为要进行转码的方式名称, 为字符串类型, 系统有给定的类型值,
//            
//            
//            
//            AVAssetExportPresetLowQuality
//            
//            AVAssetExportPresetMediumQuality
//            
//            VAssetExportPresetHighestQuality
//            
//            AVAssetExportPreset640x480
//            
//            AVAssetExportPreset1280x720
//            
//            outputURL , 为输出内容的URL, (指定一个文件路径, 然后根据路径初始化一个URL, 赋给, outputURL)
//            
//            outputFileType, 为输出压缩后视频内容的格式类型
            

            
       let exportSession = AVAssetExportSession(asset: asset,presetName: "AVAssetExportPresetHighestQuality")
            
       
       // 创建路径
            let paths: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            
            var outputURL = paths.objectAtIndex(0) as! String
            
            let manager = NSFileManager.defaultManager()
            
            do {
                
                 try manager.createDirectoryAtPath(outputURL, withIntermediateDirectories: true, attributes: nil)
                
                
            }catch _ {
                
                
                
            }
           //将前面的路径格式和后面的普通的字符串格式链接在一起，并且以路径格式返回
            outputURL = outputURL.convert.stringByAppendingPathComponent("output.mp4")
            
            do {
            // 清除沙盒文件中，压缩后的视频
                try manager.removeItemAtPath(outputURL)
                
            } catch _ {
                
                
            }
            
            if let exportSession = exportSession as AVAssetExportSession? {
                
                
                exportSession.outputURL = NSURL(fileURLWithPath: outputURL)
                
                exportSession.shouldOptimizeForNetworkUse = true
               
                
                exportSession.outputFileType = AVFileTypeMPEG4
                
                let start = CMTimeMakeWithSeconds(Float64(startTime), 600)
                
                let duration = CMTimeMakeWithSeconds(Float64(duration), 600)
                
                let range = CMTimeRangeMake(start, duration)
                
                exportSession.timeRange = range
                
                exportSession.exportAsynchronouslyWithCompletionHandler{ () -> Void in
                    
                    switch exportSession.status {
                        
                    case AVAssetExportSessionStatus.Completed: completion?(videoPath: exportSession.outputURL, error: nil)
                        
                    print(exportSession.outputURL)
                        
                    case AVAssetExportSessionStatus.Failed:
                        print("Faild: \(exportSession.error)")
                    case AVAssetExportSessionStatus.Cancelled:
                        print("Faild: \(exportSession.error)")
                        
                    default:
                        
                    print("default case")
                        
                    }
                
                }
                
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                
                
                
            }
            
        }
        
        
        
        
    }
    
    
}
