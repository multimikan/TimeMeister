/*import SwiftUI
 import CoreLocation
 import UserNotifications

 class AlarmEngine: LocationDelegate, ObservableObject {
     private let notificationIdentifier = "LocationNotification"
     @Published var la :Double
     @Published var lo :Double
     
     init(la: Double, lo: Double) {
         self.la = la
         self.lo = lo
     }
     
     func didUpdateLocation(latitude: Double, longitude: Double) {
         let distance = distance(current: (la:latitude,lo:longitude), target: (la: self.la, lo: self.lo))
         if distance < 5000 { // 5000メートル以内
             sendNotification()
         }
     }
     
     func distance(current: (la: Double, lo: Double), target: (la: Double, lo: Double)) -> Double {
         
         // 緯度経度をラジアンに変換
         let currentLa   = current.la * Double.pi / 180
         let currentLo   = current.lo * Double.pi / 180
         let targetLa    = target.la * Double.pi / 180
         let targetLo    = target.lo * Double.pi / 180
         
         // 赤道半径
         let equatorRadius = 6378137.0;
         
         // 算出
         let averageLat = (currentLa - targetLa) / 2
         let averageLon = (currentLo - targetLo) / 2
         let distance = equatorRadius * 2 * asin(sqrt(pow(sin(averageLat), 2) + cos(currentLa) * cos(targetLa) * pow(sin(averageLon), 2)))
         return distance / 1000
     }//球面三角法
     
     private func sendNotification() {
         let content = UNMutableNotificationContent()
         content.title = "位置通知"
         content.body = "登録した位置に近づきました！"
         content.sound = .default
         
         let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: nil)
         
         UNUserNotificationCenter.current().add(request) { error in
             if let error = error {
                 print("Error adding notification: \(error.localizedDescription)")
             }
         }
     }
 }

 /*
  let appDelegate = AppDelegate()
  let someOtherClass = SomeOtherClass()
  appDelegate.delegate = someOtherClass
  */
*/
