//
//  AppDelegate.swift
//  Swfit59
//
//  Created by chengbin on 2023/6/27.
//

import UIKit
import UMCommon
import Flutter
import FlutterPluginRegistrant

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {

    private(set) var appCoordinator: AppCoordinator!

    lazy var engine: FlutterEngine = {
       let result = FlutterEngine.init(name: "Books")
       // This could be `run` earlier in the app to avoid the overhead of doing it the first time the
       // engine is needed.
       result.run(withEntrypoint: nil, initialRoute: "login_module")
       return result
     }()
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GeneratedPluginRegistrant.register(with: self.engine);
        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController")
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start()
        return true
    }


}

