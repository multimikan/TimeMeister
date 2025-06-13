import SwiftUI

struct AlarmTest: View {
    @State var showSheet: Bool = false
    @Binding var AlarmList: [String]
    @Binding var alarmStates: [Bool]
    @State private var isToggled: Bool = false
    //@StateObject var locationEngine = AlarmViewModel()
    
    var body: some View {
        
            NavigationStack() {
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
                                SelectStation(AlarmList: $AlarmList,alarmStates: $alarmStates,showSheet: $showSheet)
                            }
                        } else {
                            ForEach(0..<AlarmList.count, id: \.self) { index in
                                Toggle( getValue(forStationCode: String(AlarmList[index]),columnName: "station_name")!, isOn: $alarmStates[index])
                                    .onChange(of: alarmStates[index]) { newValue in
                                        setAlarm(for: AlarmList[index], isSet: newValue)
                                    }
                                    .frame(height: 40)
                            }
                            .onDelete{ (offsets) in self.AlarmList.remove(atOffsets: offsets)}
                            
                            Button(action:{
                                showSheet.toggle()
                            }){
                                Text("+ 駅を追加")
                            }
                            .frame(height: 40)
                            .sheet(isPresented: $showSheet) {
                                SelectStation(AlarmList: $AlarmList,alarmStates: $alarmStates,showSheet: $showSheet)
                            }
                        }
                    } header: {
                        Label("アラームON",systemImage: "bell.fill").font(.title)
                    }
                    
                    Section {
                        Text("西日暮里").frame(height: 30)
                        Text("新宿").frame(height: 30)
                        Text("北野").frame(height: 30)
                    } header: {
                        Text("最近利用した駅").font(.title)
                    }
                }
                .navigationTitle("アラーム")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    func setAlarm(for alarm: String, isSet: Bool) {
            // アラーム設定のロジックをここに記述
            print("\(alarm) \(isSet ? "set" : "unset")")
        }
    }

