import SwiftUI

// 透明なView
struct TransparentView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // do nothing
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background { // 拡張したいタップ領域
                TransparentView() // Coler.clearなどは実態がなくなるため代替
                    .frame(width: 300, height: 300)
            }
    }
}

var button: some View {
    Button {
        print("ボタン押したで")
    } label: {
        Text("ラベル")
    }
    .buttonStyle(CustomButtonStyle())
}
