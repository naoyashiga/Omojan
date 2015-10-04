//
//  ViewController.swift
//  Omojan
//
//  Created by naoyashiga on 2015/01/17.
//  Copyright (c) 2015年 naoyashiga. All rights reserved.
//

import UIKit
import Social
import SwiftyJSON

class ViewController: UIViewController,GADInterstitialDelegate {
    var interstitial:GADInterstitial = GADInterstitial()
    @IBOutlet var pieLabelCollection: [UIButton]!
    var pieArray:[PFObject]!
    var pieJSON:JSON = ""
    var adCounter = 0
    let INTERSTITIAL_COUNT = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ud = NSUserDefaults.standardUserDefaults()
        if(ud.objectForKey("counter") == nil){
            //カウンター
            adCounter = 0
            ud.setObject(adCounter, forKey: "adCounter")
        }else{
            //2回目以降起動時
            adCounter = ud.integerForKey("adCounter")
        }
        
        interstitial.adUnitID = "ca-app-pub-9360978553412745/8062034318"
        interstitial.delegate = self
        interstitial.loadRequest(GADRequest())
        
        readJson()
    }

    //重複なし乱数の配列を作成
    func createRndArray(maxNum:UInt32) -> [Int]{
        var pieIndexArray:[Int] = []
        
        while(pieIndexArray.count < pieLabelCollection.count){
            //乱数
            let randNum = Int(arc4random_uniform(maxNum))
            //重複なし検索
            let filtered = pieIndexArray.filter{ $0 == randNum}
            
            if(filtered.count == 0){
                //重複なし、要素を追加
                pieIndexArray.append(randNum)
            }else{
                //重複あり
            }
        }
        
        return pieIndexArray
    }
    
    //シャッフル
    @IBAction func shuffleBtn(sender: UIButton) {
        jsonParse()
        
        adCounter = adCounter + 1
        if(adCounter % INTERSTITIAL_COUNT == 0){
            if(interstitial.isReady){
                interstitial.presentFromRootViewController(self)
            }
            
            //次の広告の準備
            interstitial = GADInterstitial()
            interstitial.adUnitID = "ca-app-pub-9360978553412745/8062034318"
            interstitial.delegate = self
            interstitial.loadRequest(GADRequest())
        }
        
    }
    
    func readJson(){
//        let path : String = NSBundle.mainBundle().pathForResource("Pie", ofType: "json")!
//        let fileHandle : NSFileHandle = NSFileHandle(forReadingAtPath: path)!
//        let data : NSData = fileHandle.readDataToEndOfFile()
//        
//        json = NSJSONSerialization.JSONObjectWithData(data,
//            options: NSJSONReadingOptions.AllowFragments,
//            error: nil) as NSDictionary
        
        if let path = NSBundle.mainBundle().pathForResource("Pie", ofType: "json") {
            if let data = NSData(contentsOfFile: path) {
                pieJSON = JSON(data: data, options: NSJSONReadingOptions.AllowFragments, error: nil)
            }
        }
    }
    
    func jsonParse(){
//        if let results = json.objectForKey("results") as? NSArray {
        if let results = pieJSON["results"].array {
            let pieIndexArray = createRndArray(UInt32(results.count))
            var counter = 0
            
            for pieIndex in pieIndexArray {
//                println(results[pieIndex].objectForKey("name") as? String)
//                let pieName:String = results[pieIndex].objectForKey("name") as! String
                if let pieName = results[pieIndex].string {
                    pieLabelCollection[counter].setTitle(pieName, forState: .Normal)
                }
//                pieLabelCollection[counter]. = UIFont(name: "ShinGoPro-Bold", size: 30.0)
                
                counter = counter + 1
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tweetButtonTapped(sender: UIButton) {
        let vc:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        var shareText:String = "お題牌:"
        var count = 0
        
        for odai in pieLabelCollection{
            print(odai.titleLabel?.text)
            if(count == 0){
                shareText = shareText + String(odai.titleLabel!.text!) + "\n\n"
                shareText = shareText + "配牌\n\n"
            }else{
                shareText = shareText + String(odai.titleLabel!.text!) + "\n"
                
            }
            
            count = count + 1
        }
        
        shareText = shareText + "\n#ひとり面雀"
        
        //投稿画像を設定
        vc.addImage(createScreenCapture())
        //テキストを設定
        vc.setInitialText(shareText)
        //投稿画像を設定
        self.presentViewController(vc,animated:true,completion:nil)
    }

    func createScreenCapture() -> UIImage{
        //キャプチャを作成
        UIGraphicsBeginImageContextWithOptions(UIScreen.mainScreen().bounds.size, false, 0);
        self.view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

