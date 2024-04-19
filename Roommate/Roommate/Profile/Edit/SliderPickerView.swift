//
//  SliderPickerView.swift
//  Roommate
//
//  Created by Spring2024 on 4/3/24.
//

import SwiftUI

enum RangeType {
    case number, money, time
}

// this is the components used for editing 
// some range fields such as budget and awake time
struct SliderPickerView: View {
    @Binding var isPresented: Bool
    let sheetHeight = UIScreen.main.bounds.height / 2
    var maxValue: CGFloat = 100
    var rangeType: RangeType
    @Binding var low: Int
    @Binding var high: Int
    
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
                                    .foregroundColor(Color.accentColor)
                                    .font(.custom("Helvetica Neue", size: 16))
                                    .fontWeight(.bold)
                            }
                        }
                        .padding()
                        if rangeType == .money {
                            Text("$\(low) - $\(high)")
                                .font(.custom("Helvetica Neue", size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .background(.red)
                                .cornerRadius(10)
                        } else if rangeType == .time {
                            Text("\(low/60):\((low%60 < 10) ? "0" : "")\(low%60) - \(high/60):\((high%60 < 10) ? "0" : "")\(high%60)")
                                .font(.custom("Helvetica Neue", size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .background(.red)
                                .cornerRadius(10)
                        } else if rangeType == .number {
                            Text("\(low) - \(high)")
                                .font(.custom("Helvetica Neue", size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .background(.red)
                                .cornerRadius(10)
                        }
                        
                        RangeSlider(maxValue: maxValue, lowerValue: $low, upperValue: $high)
                        .padding()
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
//
//#Preview {
//    SliderPickerView(isPresented: .constant(true))
//}
