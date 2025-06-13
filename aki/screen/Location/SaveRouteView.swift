import SwiftUI

struct SaveRouteView: View {
    
    @State private var showSheet: Bool = false
    @State private var isEnabled: Bool = false
    @State private var showAlert: Bool = false
    @State private var isPressed: Bool = false
    @State private var isAct: Bool = false
    let stringKey = "aaa"
    @State var stationList: [String] = ["",""] // 初期状態で発と着の位置を確保
    @State private var newPresetName = ""//Text fieldに使用
    @State private var newPresetSettings : [String:String] = [:]
    let defaultText: String = "駅を入力"
    @ObservedObject var viewModel = ViewModel()
    @StateObject private var presetManager = PresetManager()
    @State private var editingIndex: Int? // 編集している駅のインデックスを保持
    @Binding var alarmStates: [Bool]
    @Binding var all_stationList: [String]
    
    var body: some View {
        NavigationStack {
            List {
                Section{
                    //TextField("プリセット名(オプション)", text: $newPresetName)
                }
                Section{
                    HStack {
                        // 発ボタン
                        Button(action: {
                            editingIndex = 0
                            showSheet.toggle()
                        }) {
                            HStack {
                                Text("出発")
                                    .padding(.horizontal,10)
                                    .padding(.vertical,5)
                                    .bold()
                                    .foregroundStyle(Color.white)
                                    .background(Color.indigo)
                                    .cornerRadius(8)
                                Divider()
                                Text((stationList[0].isEmpty ? defaultText : getValue(forStationCode:stationList[0], columnName: "station_name"))!)
                                    .foregroundColor(stationList[0].isEmpty ? .gray : .black)
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .frame(height: 40)
                        Spacer() // 発と経路ボタンの間にスペースを追加
                        
                        // 経路を追加ボタン
                    }
                    // 中間の駅名を表示（ボタンで編集可能）
                    ForEach(1..<stationList.count - 1, id: \.self) { index in
                        Button(action: {
                            editingIndex = index
                            showSheet.toggle()
                        }) {
                            Image(systemName: "ellipsis").rotationEffect(Angle(degrees: 90))
                                .padding(.horizontal,16)
                                .padding(.vertical,5)
                            Divider()
                            Text((stationList[index].isEmpty ? defaultText : getValue(forStationCode: stationList[index], columnName: "station_name"))! )
                                .padding(.vertical,10)
                                .foregroundColor(stationList[index].isEmpty ? .gray : .black)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .frame(height: 40)
                    }
                    .onMove { indexSet, destination in
                        if let source = indexSet.first {
                            moveRow(from: source, to: destination)
                        }
                    }
                    .onDelete { indexSet in
                        if let index = indexSet.first {
                            rowRemove(at: index) // Int型のインデックスを取得して削除
                        }
                    }
                    // 着ボタン
                    HStack {
                        Button(action: {
                            editingIndex = stationList.count - 1
                            showSheet.toggle()
                        }) {
                            HStack {
                                Text("到着")
                                    .padding(.horizontal,10)
                                    .padding(.vertical,5)
                                    .foregroundColor(.white)
                                    .bold()
                                    .background(Color(red: 1.0, green: 0.2, blue: 0.37,opacity: 1.0))
                                    .cornerRadius(8)
                                
                                Divider()
                                Text(stationList[stationList.count - 1].isEmpty ? defaultText : getValue(forStationCode: stationList[stationList.count - 1], columnName: "station_name")!)
                                    .foregroundColor(stationList[stationList.count - 1].isEmpty ? .gray : .black)
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .frame(height: 40)
                    }
                    Text("+ 経由")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            editingIndex = stationList.count - 1 // 着の前に新しい駅を追加
                            stationList.insert("", at: editingIndex!)
                        }
                } header: {
                    //Text("経路").font(.title).foregroundStyle(Color.black)
                }
                Section{
                    HStack{
                        Spacer()
                        VStack{
                            Text("　　　　　　　　　決定　　　　　　　　　　")
                                .foregroundColor(.white)
                                .bold()
                                .onTapGesture {
                                    isPressed = true
                                    if stationList.contains(where: {$0.isEmpty}) == true {
                                        showAlert = true
                                        isPressed = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            isPressed = false
                                        }
                                    }
                                    else{
                                        isAct = true
                                        isPressed = false
                                        
                                    }
                                }
                                .alert(isPresented: $showAlert){
                                    Alert(title: Text("全ての駅名を埋めてください"))
                                }
                        }
                        Spacer()
                    }
                }
                .listRowBackground(isPressed ? Color.orange.opacity(0.6) : Color.orange)
                .foregroundColor(.white)
                
                
                Section{
                    ForEach(presetManager.presets) { preset in
                        Button(action: {
                            stationList = preset.settings
                        }){
                            Text(preset.name).foregroundColor(.black)
                        }
                        
                    }.onDelete{offsets in presetManager.presets.remove(atOffsets: offsets)
                        presetManager.savePresets()}
                    .frame(height: 30)
                }header: {
                    Text("いつもの経路").font(.title)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(UIColor(red: 0, green: 100/255, blue: 200/255, alpha: 0.15)))
            .navigationTitle("経路")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showSheet) {
                SelectLocation(stationList: $stationList, alarmStates: $alarmStates, showSheet: $showSheet,editIndex: $editingIndex,isEnabled: $isEnabled)
                    .scrollContentBackground(.hidden)
                    .background(Color(UIColor(red: 0, green: 100/255, blue: 200/255, alpha: 0.15)))
            }
            NavigationLink(destination: DepartureView(stationList: $stationList, alameStates: $alarmStates, all_stationList:$all_stationList),  isActive: $isAct ){}//出発を押した時の処理
            
            /*
             .toolbar {
             ToolbarItem() {
             Button(action: {
             isEnabled == true ? addPreset() : nil
             //保存処理 isEnabled.toggle()
             }) {
             Text("保存")
             .foregroundColor(isEnabled ? Color.blue: Color.gray)
             }
             }
             }
             */
            
        }
    }
    func moveRow(from source: Int, to destination: Int) {
        let item = stationList.remove(at: source)
        stationList.insert(item, at: destination > source ? destination-1 : destination)
    }
    func rowRemove(at  index: Int){//リスト削除用
        stationList.remove(at: index+1)
    }
    
    private func addPreset() {
        let newPreset = Preset(name: newPresetName.isEmpty == true ?  "\(getValue(forStationCode: stationList[0],columnName: "station_name")!)〜\(getValue(forStationCode: stationList[stationList.count-1], columnName: "station_name")!)" : newPresetName, settings: stationList)
        presetManager.addPreset(newPreset)
        newPresetName = ""  // 入力フィールドをリセット
        stationList = ["",""]  // 設定をリセット（必要に応じて変更）
    }
}

class testOb: ObservableObject{
    @Published var st = ""
    init(st: String = "") {
        self.st = st
    }
}


