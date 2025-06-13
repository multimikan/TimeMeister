import SwiftUI

struct Location: View {
    @State var AlarmList: [String] = []//追加された駅のリスト
    @State var alarmStates: [Bool] = [true]//アラームをオンにするかどうかのボタン
    @State private var path = NavigationPath()
    @State private var isToggled: Bool = true
    //@StateObject var locationEngine = AlarmViewModel()
    @StateObject var presetManager = PresetManager()
    
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section {
                    if AlarmList.isEmpty {
                        NavigationLink(destination: SaveRouteView( alarmStates: $alarmStates, all_stationList: $AlarmList)){
                            Text("経路を追加").foregroundColor(Color.blue)
                        }
                        .frame(height: 40)
                    } else {
                        ForEach(0..<AlarmList.count, id: \.self) { index in
                            Toggle(getValue(forStationCode: String(AlarmList[index]), columnName: "station_name")!, isOn: $alarmStates[index])
                                .onChange(of: alarmStates[index]) {
                                    
                                    Alarm.AlarmListHistory.append(AlarmList[index])
                                    
                                }
                                .frame(height: 40)
                        }
                        .onDelete { offsets in
                            self.AlarmList.remove(atOffsets: offsets)
                        }
                    }
                    
                }
                
            }
            .navigationTitle("経路登録")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    func checkAlarm(for alarm: String, isSet: Bool) {
        // アラーム設定のロジックをここに記述
        print("\(alarm) \(isSet ? "set" : "unset")")
    }
}

