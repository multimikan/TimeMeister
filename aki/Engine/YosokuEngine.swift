//
//  YosokuEngine.swift
//  aki
//
//  Created by tknooa on 2024/09/25.
import SwiftUI
/*
struct Yosoku: View{
    @ObservedObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            TextField("ここに駅名を入力", text: $viewModel.text)
                .padding()
            List {
                ForEach(viewModel.items, id: \.self) { item in
                    Text(item)
                }
            }
        }
    }
}
*/
class ViewModel: ObservableObject {
    @Published var text: String = ""
    private let allItems: [[String:String]] = loadCSV()

    var items: [[String: String]] {
        text.isEmpty ? allItems : allItems.filter {
            if let stationName = $0["station_name"] { // 駅名のラベルに合わせて変更
                return stationName.contains(text) // 駅名にテキストが含まれるか確認
            }
            return false // 駅名がない場合はフィルタしない
        }
    }
}
