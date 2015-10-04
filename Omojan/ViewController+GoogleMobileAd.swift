//
//  ViewController+GoogleMobileAd.swift
//  Omojan
//
//  Created by naoyashiga on 2015/10/04.
//  Copyright © 2015年 naoyashiga. All rights reserved.
//

import Foundation
import GoogleMobileAds

extension ViewController: GADInterstitialDelegate {
    func settingInterstitialAd() {
        interstitial = GADInterstitial(adUnitID: AdConstraints.interstitialAdUnitID)
        interstitial!.delegate = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        //        request.testDevices = [AdConstraints.realDeviceID]
        interstitial!.loadRequest(request)
    }
    
    func checkInterstitialAd() {
        
        print(AdManager.counter)
        
        if AdManager.counter != 0 && AdManager.counter % AdManager.Cycle.top == 0{
            settingInterstitialAd()
        }
        
        AdManager.countUp(AdManager.keyName.adCounter)
    }
    
    func interstitialDidReceiveAd(ad: GADInterstitial!) {
        if let interstitial = interstitial {
            if(interstitial.isReady){
                interstitial.presentFromRootViewController(self)
            }
        }
    }
    
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        interstitial = nil
    }
    
}