import SwiftUI
import CoreLocation

struct ContentView: View {
    @State var selection = 1
    @State public var AlarmList: [String] = []
    @State private var alarmStates: [Bool] = []
    var body: some View {
        
        VStack {
            TabView(selection: $selection){
                SaveRouteView(alarmStates: $alarmStates,all_stationList: $AlarmList).tabItem{Label("経路",systemImage: "mappin.and.ellipse")}.tag(1)
                Alarm(AlarmList: $AlarmList,alarmStates: $alarmStates).tabItem{Label("乗り過ごし",systemImage: "bell.and.waves.left.and.right.fill")}.tag(2)
                norikae().tabItem{Label("時刻表",systemImage: "map.fill")}.tag(3)
                Setting().tabItem{Label("その他",systemImage: "ellipsis")}.tag(4)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0,maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
