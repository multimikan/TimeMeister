import SwiftUI

struct DepartureView: View {
    @Binding var stationList: [String]
    @Binding var alameStates: [Bool]
    @Binding var all_stationList: [String]
    @State private var isToggle: Bool = false
    @State private var showSheet: Bool = true
    @State private var newPresetName = ""
    private let defaultText = "プリセット名(オプション)"
    @Environment(\.dismiss) private var dismiss
    @StateObject private var presetManager = PresetManager()
    
    var body: some View {
        let st = stationList[stationList.count-1]
        NavigationStack{
            ZStack{
            }
                VStack(alignment: .trailing){
                }
                List{
                    Section{
                        MapView(address: getValue(forStationCode: st, columnName: "address")!)
                            .frame(height: 300)
                    } header: {
                        Text("目的地").font(.title)
                    }
                    Section{
                        if isToggle {TextField(defaultText,text: $newPresetName)}
                    }
                    Section{
                        Toggle(isOn: $isToggle){Text("いつもの経路として保存")}
                    }
                }
                .presentationDetents([.medium])
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled()
            
            .navigationTitle("確認").navigationBarTitleDisplayMode(.inline)
            .toolbar{
                Button("保存"){
                    for i in 0..<stationList.count{
                        alameStates.append(true)
                        all_stationList.append(stationList[i])
                    }
                    if isToggle{addPreset()}
                    dismiss()
                }
            }
        }
    }
    private func addPreset() {
        let newPreset = Preset(name: newPresetName.isEmpty == true ?  "\(getValue(forStationCode: stationList[0],columnName: "station_name")!)〜\(getValue(forStationCode: stationList[stationList.count-1], columnName: "station_name")!)" : newPresetName, settings: stationList)
        presetManager.addPreset(newPreset)
        newPresetName = ""  // 入力フィールドをリセット
        //stationList = ["",""]  // 設定をリセット（必要に応じて変更）
    }
}
