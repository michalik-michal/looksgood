//
//  ToastView.swift
//  Journ
//
//  Created by Michal Michalik on 29/03/2024.
//

import SwiftUI

struct Toast: Equatable {
    var message: String
    var image: String
    var duration: Double = 3.5
    var width: Double = .infinity
}

struct ToastView: View {

    var message: String
    var image: String
    var width = CGFloat.infinity

    @State private var symbol = "circle"
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: image)
                .foregroundStyle(.green)
                .contentTransition(.symbolEffect(.replace, options: .speed(10)))
            Text(message)
                .font(.subheadline)
                .foregroundColor(.white)
            Spacer()
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .background(Color(.systemGray3))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct Toastmodifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                ZStack {
                    mainToastView()
                        .offset(y: 10)
                }
                .animation(.spring(), value: toast)
            }
            .onChange(of: toast) {
                showToast()
            }
    }

    @ViewBuilder func mainToastView() -> some View {
        if let toast {
            VStack {
                ToastView(message: toast.message,
                          image: toast.image,
                          width: toast.width)
                Spacer()
            }
        }
    }

    private func showToast() {
        guard let toast else { return }
        
        if toast.duration > 0 {
            workItem?.cancel()
        }
        
        let task = DispatchWorkItem {
            dismissToast()
        }
        workItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration,
                                      execute: task)
    }

    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        workItem?.cancel()
        workItem = nil
    }
}

extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(Toastmodifier(toast: toast))
    }
}

#Preview {
    ToastView(message: "Test toast", image: "checkmark")
}
