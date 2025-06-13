import SwiftUI
import CoreLocation
import UserNotifications
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var locationUpdateHandler: ((CLLocation) -> Void)?
    private var distanceThreshold: CLLocationDistance?
    private var targetLocation: CLLocation?
    
    @Published var currentLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
    
    // 位置情報を監視開始
    func startMonitoring(targetLat: Double, targetLon: Double, distanceThreshold: CLLocationDistance, locationUpdateHandler: @escaping (CLLocation) -> Void) {
        self.targetLocation = CLLocation(latitude: targetLat, longitude: targetLon)
        self.distanceThreshold = distanceThreshold
        self.locationUpdateHandler = locationUpdateHandler
        
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringVisits()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        
    }
    
    // 位置情報更新時の処理
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.currentLocation = location
        locationUpdateHandler?(location)
        
        // 現在地とターゲットの距離を計算
        if let targetLocation = targetLocation {
            let distance = location.distance(from: targetLocation)
            if distance <= distanceThreshold ?? 0 {
                sendNotification()
            }
        }
    }
    
    // 通知を送信する
    private func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "まもなく到着します"
        content.body = "通知をタップしてオフ"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}
