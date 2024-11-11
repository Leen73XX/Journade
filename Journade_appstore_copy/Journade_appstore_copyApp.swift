//
//  Journade_appstore_copyApp.swift
//  Journade_appstore_copy
//
//  Created by Leen Almejarri on 05/05/1446 AH.
//

import SwiftUI
import TipKit

@main
struct Journade_appstore_copyApp: App {
    init() {
        NotificationManager.shared.requestNotificationPermission()
       try? Tips.configure()
    }
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}
