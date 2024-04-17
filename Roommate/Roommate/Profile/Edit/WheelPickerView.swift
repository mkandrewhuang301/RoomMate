//
//  PopUpView.swift
//  Roommate
//
//  Created by Spring2024 on 4/3/24.
//

import SwiftUI

// this is mainly for editing the age and
// graduation year
struct WheelPickerView: View {
    @Binding var isPresented: Bool
    let sheetHeight = UIScreen.main.bounds.height / 2
    @Binding var num: UInt
    var from: UInt
    var to: UInt
    
    var body: some View {
        if isPresented {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    self.isPresented.toggle()
                                }
                            }) {
                                Text("Done")
                                    .foregroundColor(.accentColor)
                                    .font(.custom("Helvetica Neue", size: 16))
                                    .fontWeight(.bold)
                            }
                        }
                        .padding()
                        Picker("Select a number", selection: $num) {
                            let range = from...to
                            ForEach(range, id: \.self) { num in
                                Text("\(String(num))").tag(num)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                    .background(.white)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(
                    Color.black.opacity(0)
                )
            }
            .edgesIgnoringSafeArea(.all)
            .transition(.move(edge: .bottom))
        }
    }
}

//#Preview {
//    PopUpView()
//}
