//
//  YosokuEngine.swift
//  aki
//
/* Created by tknooa on 2024/09/25.
import SwiftUI

struct AddStation: View{
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

class AddStationEngine: ObservableObject {
    @Published var text: String = ""
    private let allItems: [String] = (0..<100000).map { "\($0)" }

    var items: [String] {
        text.isEmpty ? allItems : allItems.filter { $0.contains(text) }
    }
}
*/
