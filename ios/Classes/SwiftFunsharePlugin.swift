import Flutter
import UIKit
import MBProgressHUD

public class SwiftFunsharePlugin: NSObject, FlutterPlugin,URLSessionDownloadDelegate{
   
   
    var progress: Float = 0.0
    var task: URLSessionTask!
    
    var percentageWritten:Float = 0.0
    var taskTotalBytesWritten = 0
    var taskTotalBytesExpectedToWrite = 0
    
    lazy var session : URLSession = {
        let config = URLSessionConfiguration.default
        // config.allowsCellularAccess = false
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        return session
    }()
    
   
    // Constructor to Initialize FlutterPaytmPluginDelegate which accepts registrar and a viewController reference.
    
    
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    
    let channel = FlutterMethodChannel(name: "funshare_plugin", binaryMessenger: registrar.messenger())
    
    let instance = SwiftFunsharePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
    
   

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method == "shareImage"){
        self.shareImage(arguments: call.arguments)
    } else if(call.method == "shareText"){
        self.shareText(arguments: call.arguments)
    } else if(call.method == "shareVideo"){
       self.ShareVideo(arguments: call.arguments)
    } else {
        result(FlutterMethodNotImplemented)
    }
  }
    
    func shareText(arguments:Any?) -> Void {
        // prepare method channel args
        let argsMap = arguments as! NSDictionary
        let text:String = argsMap.value(forKey: "text") as! String
        
        // no use in ios
        //let title:String = argsMap.value(forKey: "title") as! String
        
        // set up activity view controller
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        // present the view controller
        let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        activityViewController.popoverPresentationController?.sourceView = controller.view
        
        controller.show(activityViewController, sender: self)
    }
    
    func shareImage(arguments:Any?) -> Void {
        // prepare method channel args
        let argsMap = arguments as! NSDictionary
        let fileName:String = argsMap.value(forKey: "fileName") as! String
        
        // no use in ios
        //let title:String = argsMap.value(forKey: "title") as! String
        
        // load the iage
        let docsPath:String = NSSearchPathForDirectoriesInDomains(.cachesDirectory,.userDomainMask , true).first!;
        let imagePath = NSURL(fileURLWithPath: docsPath).appendingPathComponent(fileName)
        let imageData:NSData? = NSData(contentsOf: imagePath!)
        let imageToShare:UIImage = UIImage(data: imageData! as Data)!
        
        // set up activity view controller
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        
        // present the view controller
        let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        activityViewController.popoverPresentationController?.sourceView = controller.view
        
        controller.show(activityViewController, sender: self)
    }
    
    
    func ShareVideo(arguments:Any?) -> Void {
        // prepare method channel args
        let argsMap = arguments as! NSDictionary
        let videoUrl:String = argsMap.value(forKey: "videoUrl") as! String
       
        // present the view controller
          let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        let hud =  MBProgressHUD.showAdded(to: controller.view, animated: true)
        // Set the bar determinate mode to show task progress.
        progress = 0.0
        hud.mode = MBProgressHUDMode.determinateHorizontalBar
        hud.isUserInteractionEnabled = true;
        hud.label.text = NSLocalizedString("Downloading...", comment: "HUD loading title")
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            // Do something useful in the background and update the HUD periodically.
            self.doSomeWorkWithProgress()
            DispatchQueue.main.async(execute: {() -> Void in
                //hud?.hide(true)
                hud.label.text = NSLocalizedString("Just Wait...", comment: "HUD loading title")
            })
        })
        
        
        let videoPath = videoUrl
        print(videoPath)
        //let urlData = NSData(contentsOf: NSURL(string:"\(getDataArray["video_url"] as! String)")! as URL)
        let s = videoPath
        let url = NSURL(string:s)!
        let req = NSMutableURLRequest(url:url as URL)
        let config = URLSessionConfiguration.default
        let task = self.session.downloadTask(with: req as URLRequest)
        self.task = task
        task.resume()
    }
    
    //MARK:- share video
    func doSomeWorkWithProgress() {
        // This just increases the progress indicator in a loop.
        while progress < 1.0 {
            progress += 0.01
            DispatchQueue.main.async(execute: {() -> Void in
                // Instead we could have also passed a reference to the HUD
                // to the HUD to myProgressTask as a method parameter.
                print("downloaded Prograss \(self.progress)")
                let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
                MBProgressHUD(for: controller.view)?.progress = self.progress
            })
            usleep(50000)
        }
    }
    
    //MARK:- URL Session delegat
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("downloaded \(100*totalBytesWritten/totalBytesExpectedToWrite)")
        taskTotalBytesWritten = Int(totalBytesWritten)
        taskTotalBytesExpectedToWrite = Int(totalBytesExpectedToWrite)
        percentageWritten = Float(taskTotalBytesWritten) / Float(taskTotalBytesExpectedToWrite)
        print(percentageWritten)
        //  let x = Double(percentageWritten).rounded(toPlaces: 2)
        let x = String(format:"%.2f", percentageWritten)
        print("downloaded x \(x)")
        self.progress = Float(x)!
        print("downloaded \(progress)")
        
    }

    
    private func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        // unused in this example
    }
    
    
    
    private func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("completed: error: \(String(describing: error))")
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished downloading!")
        let fileManager = FileManager()
        // this can be a class variable
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print(directoryURL)
        let docDirectoryURL = NSURL(fileURLWithPath: "\(directoryURL)")
        print(docDirectoryURL)
        // Get the original file name from the original request.
        //print(lastPathComponent)
        let destinationFilename = downloadTask.originalRequest?.url?.lastPathComponent
        print(destinationFilename!)
        // append that to your base directory
        let destinationURL =  docDirectoryURL.appendingPathComponent("\(destinationFilename!)")
        print(destinationURL!)
        /* check if the file exists, if so remove it. */
        if let path = destinationURL?.path {
            if fileManager.fileExists(atPath: path) {
                do {
                    try fileManager.removeItem(at: destinationURL!)
                    
                } catch let error as NSError {
                    print(error.debugDescription)
                }
                
            }
        }
        
        do
        {
            try fileManager.copyItem(at: location, to: destinationURL!)
        }
        catch {
            print("Error while copy file")
            
        }
         let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        DispatchQueue.main.async(execute: {() -> Void in
            MBProgressHUD.hide(for: controller.view, animated: true)
        })
        // let videoLink = NSURL(fileURLWithPath: filePath)
        let objectsToShare = [destinationURL!] //comment!, imageData!, myWebsite!]
        let activityVC = UIActivityViewController(activityItems: objectsToShare , applicationActivities: nil)
        activityVC.setValue("Video", forKey: "subject")
        //New Excluded Activities Code
        if #available(iOS 9.0, *) {
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.copyToPasteboard, UIActivityType.mail, UIActivityType.message, UIActivityType.openInIBooks, UIActivityType.postToTencentWeibo, UIActivityType.postToVimeo, UIActivityType.postToWeibo, UIActivityType.print]
        } else {
            // Fallback on earlier versions
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.copyToPasteboard, UIActivityType.mail, UIActivityType.message, UIActivityType.postToTencentWeibo, UIActivityType.postToVimeo, UIActivityType.postToWeibo, UIActivityType.print ]
        }
        
        controller.present(activityVC, animated: true, completion: nil)
    }

    
    
   
    
 
    
    
}
