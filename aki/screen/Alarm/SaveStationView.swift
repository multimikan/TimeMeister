import SwiftUI
import CoreLocation

struct SaveStationView: View {
    //モーダルを閉じる
    @Environment(\.dismiss) private var dismiss
    @Binding var AlarmList: [String]
    @Binding var alarmStates: [Bool]
    @Binding var showSheet: Bool
    //@StateObject var locationEngine = AlarmViewModel()
    @StateObject var locationManager = LocationManager()
    @ObservedObject var settingEngine = SettingEngine()
    
    let stationCd: String
    
    var body: some View {
        let lat = Double( getValue(forStationCode: stationCd, columnName: "lat")!)!
        let lon = Double (getValue(forStationCode: stationCd, columnName: "lon")!)!
        let distance :CLLocationDistance = 10000
        VStack{
            NavigationStack{
                MapView(address: getValue(forStationCode: stationCd, columnName: "address")!)
            }
            .navigationTitle("確認")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                Button("追加"){
                    showSheet = false//モーダルを閉じる
                    alarmStates.append(true) // 新しいアラームの初期状態をtrueに設定
                    AlarmList.append(stationCd)
                    locationManager.startMonitoring(targetLat: lat, targetLon: lon, distanceThreshold: settingEngine.distance, locationUpdateHandler:  { location in
                        // 位置情報が更新されたときに呼ばれるクロージャ
                        print("現在地: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                    })
                }
            }
        }
    }
}
