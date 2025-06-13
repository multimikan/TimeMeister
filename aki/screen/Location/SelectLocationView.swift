import SwiftUI

struct SelectLocation: View {
    @ObservedObject var viewModel = ViewModel()
    @Binding var stationList: [String]
    @Binding var alarmStates: [Bool]
    @Binding var showSheet: Bool
    @Binding var editIndex: Int?
    @Binding var isEnabled: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            NavigationStack {
                List {
                    if viewModel.text.count > 0 {
                        ForEach(uniqueStations(from: viewModel.items), id: \.self) { station in
                            if let stationName = station["station_name"],
                               let stationAddress = station["address"],
                               let stationCd = station["station_cd"] {
                                
                                NavigationLink(destination: SaveLocationView(stationList: $stationList, alarmStates: $alarmStates,showSheet: $showSheet,editIndex:$editIndex, isEnabled: $isEnabled, stationCd: stationCd)) {
                                    VStack(alignment: .leading) {
                                        Label(stationName, systemImage: "tram") // 駅名を表示
                                            .font(.headline) // 駅名のフォントスタイル
                                        Text("住所: \(stationAddress)") // 住所を表示
                                            .font(.subheadline) // 住所のフォントスタイル
                                            .foregroundColor(.gray) // 色を薄くする
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("駅名検索")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $viewModel.text)
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Button("キャンセル") {
                            dismiss()
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden) // List の外側に配置
        }
    }

    
    
    
    func uniqueStations(from stations: [[String: String]]) -> [[String: String]] {
        var seen: Set<String> = []
        return stations.filter { station in
            if let stationCd = station["station_g_cd"] {
                if seen.contains(stationCd) {
                    return false
                } else {
                    seen.insert(stationCd)
                    return true
                }
            }
            return false
        }
    }

}
