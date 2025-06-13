import SwiftUI
struct Setting: View {
    @State var isToggle = true
    
    var body: some View {
        NavigationStack{
            List{
                Section{
                    NavigationLink("距離を設定"){
                        SettingDistance()
                    }
                }
                Toggle(isOn: $isToggle){
                    Text("イヤホンをつけている時のみアラームを鳴らす")
                }
                Toggle(isOn: $isToggle){
                    Text("バッテリー節約モード")
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(UIColor(red: 0, green: 100/255, blue: 200/255, alpha: 0.15)))
            .navigationTitle("その他").navigationBarTitleDisplayMode(.inline)
        }
    }
}
