import SwiftUI

struct SaveLocationView: View {
    //モーダルを閉じる
    
    @Binding var stationList: [String]
    @Binding var alarmStates: [Bool]
    @Binding var showSheet: Bool
    @Binding var editIndex: Int?
    @Binding var isEnabled: Bool
    
    let stationCd: String
    
    var body: some View {
        VStack{
            NavigationStack{
                MapView(address: getValue(forStationCode: stationCd, columnName: "address")!)
            }
            .navigationTitle("確認")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                Button("追加"){
                    showSheet = false
                    if (Enaveled(list: stationList) == true) && (stationList.count > 1){
                        isEnabled.toggle()
                    }
                    alarmStates.append(true) // 新しいアラームの初期状態をtrueに設定
                    stationList[editIndex!] = stationCd
                }
            }
        }
    }
    private func Enaveled(list: [String]) -> Bool {
        // 配列に空文字列が含まれていないかチェック
        return !list.contains { $0.isEmpty }
    }

}

