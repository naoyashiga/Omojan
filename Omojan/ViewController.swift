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
import GoogleMobileAds

class ViewController: UIViewController {
    @IBOutlet var pieLabelCollection: [UIButton]!
    var interstitial:GADInterstitial?
    var pieJSON:JSON = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        interstitial = nil
        
        readJson()
    }

    //重複なし乱数の配列を作成
    func createRndArray(arrayLengthNum maxNum:UInt32) -> [Int]{
        var pieIndexArray:[Int] = []
        
        while pieIndexArray.count < pieLabelCollection.count {
            //乱数
            let randNum = Int(arc4random_uniform(maxNum))
            //重複なし検索
            let filtered = pieIndexArray.filter{ $0 == randNum}
            
            if filtered.isEmpty {
                //重複なし、要素を追加
                pieIndexArray.append(randNum)
            }
        }
        
        return pieIndexArray
    }
    
    //シャッフル
    @IBAction func shuffleBtn(sender: UIButton) {
        jsonParse()
        
        checkInterstitialAd()
    }
    
    func readJson(){
        if let path = NSBundle.mainBundle().pathForResource("Pie", ofType: "json") {
            if let data = NSData(contentsOfFile: path) {
                pieJSON = JSON(data: data, options: NSJSONReadingOptions.AllowFragments, error: nil)
                jsonParse()
            }
        }
    }
    
    func jsonParse(){
        if let results = pieJSON["results"].array {
            let pieIndexArray = createRndArray(arrayLengthNum: UInt32(results.count))
            var counter = 0
            
            for pieIndex in pieIndexArray {
                pieLabelCollection[counter].setTitle(results[pieIndex].stringValue, forState: .Normal)
                
                counter = counter + 1
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func tweetButtonTapped(sender: UIButton) {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        var shareText = "お題牌:"
        
        pieLabelCollection.enumerate().forEach {
            if $0.0 == 0 {
                shareText = shareText + String($0.1.titleLabel!.text!) + "\n\n配牌\n\n"
            } else {
                shareText = shareText + String($0.1.titleLabel!.text!) + "\n"
            }
        }
        
        shareText = shareText + "\n#ひとり面雀"
        
        //投稿画像を設定
        vc.addImage(createScreenCapture())
        //テキストを設定
        vc.setInitialText(shareText)
        //投稿画像を設定
        presentViewController(vc,animated:true,completion:nil)
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

