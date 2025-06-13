import SwiftUI
import CoreLocation

class SettingEngine: ObservableObject {
    @Published var distance: CLLocationDistance {
        didSet {
            // `distance`が変更されたときにUserDefaultsに保存
            UserDefaults.standard.set(distance, forKey: "savedDistance")
        }
    }
    
    init() {
        // 初期化時にUserDefaultsから保存された`distance`を読み込み
        let savedDistance = UserDefaults.standard.double(forKey: "savedDistance")
        self.distance = savedDistance > 0 ? savedDistance : 1000 // 保存された値がない場合はデフォルト1000m
    }
    
    // 新しい距離を設定するメソッド
    func setDistance(newDistance: CLLocationDistance) {
        distance = newDistance
    }
}
