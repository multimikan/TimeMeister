import Foundation
import SwiftUI

struct Preset: Identifiable, Codable {
    var id: UUID = UUID()  // 各プリセットを一意に識別するID
    var name: String       // プリセットの名前
    var settings: [String] // 設定の内容（任意の型の辞書として管理する例）
}

class PresetManager: ObservableObject {
    @Published var presets: [Preset] = [] // プリセットのリスト

    private let presetsKey = "presets_key"  // UserDefaultsで保存するためのキー

    init() {
        loadPresets()  // アプリ起動時にプリセットを読み込む
    }

    // プリセットを追加
    func addPreset(_ preset: Preset) {
        presets.append(preset)
        savePresets()
    }

    // プリセットを削除
    func removePreset(at offsets: IndexSet) {
        presets.remove(atOffsets: offsets)
        savePresets()
    }

    // プリセットを保存
    func savePresets() {
        if let encodedData = try? JSONEncoder().encode(presets) {
            UserDefaults.standard.set(encodedData, forKey: presetsKey)
        }
    }

    // プリセットを読み込む
    private func loadPresets() {
        if let savedData = UserDefaults.standard.data(forKey: presetsKey),
           let decodedPresets = try? JSONDecoder().decode([Preset].self, from: savedData) {
            presets = decodedPresets
        }
    }
}
