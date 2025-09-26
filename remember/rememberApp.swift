//
//  rememberApp.swift
//  remember
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 22.09.25.
//

import ComposableArchitecture
import SwiftUI
import GoogleMobileAds
import RevenueCat

@main
struct rememberApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            withDependencies {
                $0.appStyle = AppStyle()
            } operation: {
                AppView(
                    store: Store(
                        initialState: AppCore.State()
                    ) {
                        AppCore()
                    }
                )
                .statusBarHidden()
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        Task {
            await MobileAds.shared.start()
        }

        Purchases.configure(withAPIKey: "appl_IpMkPNRJDMzzWKoCwqcYhfNympS")

        return true
    }
}
