import SwiftUI

struct Alarm: View {
    @State var showSheet: Bool = false
    @Binding var AlarmList: [String]//追加された駅のリスト
    @State static var AlarmListHistory: [String] = []//最近利用した駅
    @Binding var alarmStates: [Bool]
    @State private var path = NavigationPath()
    @State private var isToggled: Bool = false
    //@StateObject var locationEngine = AlarmViewModel()
    
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section {
                    if AlarmList.isEmpty {
                        Button(action:{
                            showSheet.toggle()
                        }){
                            Text("+ 駅を追加")
                        }
                        .frame(height: 40)
                        .sheet(isPresented: $showSheet) {
                            SelectStation(AlarmList: $AlarmList,alarmStates: $alarmStates, showSheet: $showSheet)
                        }
                    } else {
                        ForEach(0..<AlarmList.count, id: \.self) { index in
                            Toggle(getValue(forStationCode: String(AlarmList[index]), columnName: "station_name")!, isOn: $alarmStates[index])
                                .onChange(of: alarmStates[index]) { 
                                    Alarm.AlarmListHistory.append(AlarmList[index])
                                    
                                }
                                .frame(height: 40)
                        }
                        .onDelete { offsets in
                            // アラーム状態を更新してから削除
                            for index in offsets {
                                // 対応する alarmStates の値を false に設定
                                alarmStates[index] = false
                            }
                            self.AlarmList.remove(atOffsets: offsets)
                        }
                        
                        Button(action:{
                            showSheet.toggle()
                        }){
                            Text("+ 駅を追加")
                        }
                        .frame(height: 40)
                        .sheet(isPresented: $showSheet) {
                            SelectStation(AlarmList: $AlarmList,alarmStates: $alarmStates, showSheet: $showSheet)
                        }
                    }
                } header: {
                    Label("アラームON",systemImage: "bell.fill").font(.title).foregroundColor(Color.black)
                }
                
                Section {
                    ForEach(0..<Alarm.AlarmListHistory.count, id: \.self) { index in
                        Text(Alarm.AlarmListHistory[index])
                    }
                    .onDelete { offsets in
                        Alarm.AlarmListHistory.remove(atOffsets: offsets)
                    }
                } header: {
                    Text("最近利用した駅").font(.title)
                }
            }
            .navigationTitle("乗り過ごし")
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .background(Color(UIColor(red: 0, green: 100/255, blue: 200/255, alpha: 0.15)))
        }
    }
    func checkAlarm(for alarm: String, isSet: Bool) {
        // アラーム設定のロジックをここに記述
        print("\(alarm) \(isSet ? "set" : "unset")")
    }
}

