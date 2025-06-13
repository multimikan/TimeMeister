import SwiftUI
import CoreLocation

struct LocationViewModel: View {
    @StateObject private var locationManager = LocationManager()
    
    // ターゲットの緯度・経度と範囲（メートル）
    @State private var targetLat: Double = 37.7749   // 例: サンフランシスコ
    @State private var targetLon: Double = -122.4194
    @State private var distanceThreshold: CLLocationDistance = 100  // 100メートル
    
    var body: some View {
        VStack {
            Text("ターゲットの座標を設定")
            
            VStack {
                TextField("緯度", value: $targetLat, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("経度", value: $targetLon, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("範囲 (メートル)", value: $distanceThreshold, formatter: NumberFormatter())
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            
            Button(action: {
                sendNotificationManually()
                locationManager.startMonitoring(
                    targetLat: targetLat,
                    targetLon: targetLon,
                    distanceThreshold: distanceThreshold
                ) { location in
                    print("現在地: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                }
            }) {
                Text("監視開始")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                if let error = error {
                    print("通知の許可エラー: \(error)")
                }
            }
        }
    }
    
    func sendNotificationManually() {
        let content = UNMutableNotificationContent()
        content.title = "テスト通知"
        content.body = "これは手動で送信された通知です。"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知送信エラー: \(error)")
            } else {
                print("通知送信成功")
            }
        }
    }

}

