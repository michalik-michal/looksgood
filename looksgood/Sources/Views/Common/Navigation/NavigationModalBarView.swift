import SwiftUI

struct NavigationModalBarView<Content>: View where Content: View {

    @Binding var showModal: Bool
    let content: Content

    var body: some View {
        NavigationView {
            content
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            showModal = false
                        }, label: {
                            SystemImage(.xmark)
                                .frame(width: 24, height: 24, alignment: .center)
                                .foregroundColor(.gray)
                        })
                    }
                })
        }
    }
}
