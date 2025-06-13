import Foundation

func loadCSV() -> [[String: String]] {
    guard let url = Bundle.main.url(forResource: "stations", withExtension: "csv") else {
        return []
    }

    do {
        let data = try Data(contentsOf: url)
        let content = String(data: data, encoding: .utf8)
        let lines = content?.components(separatedBy: .newlines) ?? []
        
        guard let header = lines.first?.components(separatedBy: ",") else {
            return []
        }
        
        var result: [[String: String]] = []
        
        for line in lines.dropFirst() {
            let values = line.components(separatedBy: ",")
            if values.count == header.count {
                let dict = Dictionary(uniqueKeysWithValues: zip(header, values))
                result.append(dict)
            }
        }
        
        return result
    } catch {
        print("Error loading CSV: \(error)")
        return []
    }
}

func getValue(forStationCode stationCode: String, columnName: String) -> String? {
    let csvData = loadCSV()
    
    // station_cd が一致する辞書を検索
    for row in csvData {
        if row["station_cd"] == stationCode {
            return row[columnName]
        }
    }
    
    // 一致する station_cd が見つからない場合は nil を返す
    return "not found station"
}
