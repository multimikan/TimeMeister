import SwiftUI
import MapKit

struct SettingDistance: View {
    @State var tab = 1
    @ObservedObject var settingEngine = SettingEngine()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            Spacer()
            VStack(alignment: .center){
                Spacer()
                
                TabView(selection: $tab){
                    TokyoStationView(redius: 1000)
                        .padding()
                        .tabItem{
                            Label("1km",systemImage: "1.square")
                        }.tag(1)
                    
                    TokyoStationView(redius: 2000)
                        .padding()
                        .tabItem{Label("2km",systemImage: "2.square")
                        }.tag(2)
                    
                    TokyoStationView(redius: 5000)
                        .padding()
                        .tabItem{Label("5km",systemImage: "5.square")}.tag(3)
                    
                    TokyoStationView(redius: 10000)
                        .padding()
                        .tabItem{Label("10km",systemImage: "10.square")}.tag(4)
                }.font(.title)
                List{
                }
                .navigationTitle("距離").navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    Button("保存"){
                        settingEngine.setDistance(newDistance: CLLocationDistance(tab))
                        dismiss()
                    }
                }
            }
        }
    }
}

struct TokyoStationView: View {
    // 東京駅の座標
    let coordinate = CLLocationCoordinate2D(latitude: 35.681236, longitude: 139.767125)
    
    var redius: CLLocationDistance = 1000
    
    init(redius: CLLocationDistance){
        self.redius = redius
    }
    
    
    // MapCameraBoundsを計算
    var bounds: MapCameraBounds {
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 10000,
            longitudinalMeters: 10000
        )
        return MapCameraBounds(
            centerCoordinateBounds: region,
            minimumDistance: 10000,
            maximumDistance: 100000
        )
    }
    
    var body: some View {
        
        Map(bounds: bounds, interactionModes: .all) {
            // 吉祥寺駅を中心に半径500mの円を描画
            MapCircle(center: coordinate, radius: redius)
                .strokeStyle(style: .init(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: []))
                .foregroundStyle(.blue.opacity(0.3))
                .mapOverlayLevel(level: .aboveLabels)
            
            // 吉祥寺駅の位置にマーカーを追加
            Marker("東京駅", coordinate: coordinate)
        }
        .frame(height: 300)
    }
}
