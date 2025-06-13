
import SwiftUI

import UserNotifications

@main
struct YourApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    // AppDelegateを設定できるようにする
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // アプリ起動時に通知の許可をリクエスト
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // 通知の許可を求める
        requestNotificationPermission()
        
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    // 通知の許可を求める
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        
        // リクエスト
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("通知の許可が得られました")
            } else {
                print("通知の許可が得られませんでした: \(error?.localizedDescription ?? "不明なエラー")")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // 通知が受信されたときの処理
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
