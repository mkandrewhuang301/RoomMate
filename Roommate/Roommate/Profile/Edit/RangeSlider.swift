//
//  RangeSlider.swift
//  Roommate
//
//  Created by Spring2024 on 4/3/24.
//

import SwiftUI

// a double end range slider
struct RangeSlider: View {
    @State var width: CGFloat = 0
    @State var widthToW: CGFloat = 15
    let offsetValue: CGFloat = 40
    @State var totalIScreen: CGFloat = 0
    var maxValue: CGFloat = 0
    
    @State var isDraggingLeft = false
    @State var isDraggingRight = false
    
    @Binding var lowerValue: Int
    @Binding var upperValue: Int
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10).foregroundColor(.gray)
                            .opacity(0.3)
                            .frame(height: 6)
                            .padding(.horizontal, 6)
                        
                        Rectangle().foregroundColor(.accentColor)
                            .frame(width: widthToW - width, height: 6)
                            .offset(x: width + 20)
                        
                        HStack(spacing: 0) {
                            // DraggableCircle views are assumed to be defined elsewhere in your project
                            DraggableCircle(isLeft: true, isDragging: $isDraggingLeft, position: $width, otherPosition: $widthToW, limit: totalIScreen)
                            DraggableCircle(isLeft: false, isDragging: $isDraggingRight, position: $widthToW, otherPosition: $width, limit: totalIScreen)
                        }
                        
                    }
                }
                .frame(width: geometry.size.width, height: 130)
                .onAppear {
                    totalIScreen = geometry.size.width - offsetValue
                }
            }
             .frame(height: 130)
             .padding(.horizontal, 30)
             .background(.white)
             .padding(.horizontal, 10)
             .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 0)
        }
        .ignoresSafeArea()
        .onChange(of: width)  {
            lowerValue = Int(map(value: width, from: 0...totalIScreen, to: 0...maxValue))
        }
        .onChange(of: widthToW) {
            upperValue = Int(map(value: widthToW, from: 0...totalIScreen, to: 0...maxValue))
        }
        .onAppear(){
            width = CGFloat(lowerValue) * totalIScreen / maxValue
            widthToW = CGFloat(upperValue) * totalIScreen / maxValue
        }
    }
    func map(value: CGFloat, from: ClosedRange<CGFloat>, to: ClosedRange<CGFloat>) -> CGFloat {
            let inputRange = from.upperBound - from.lowerBound
            guard inputRange != 0 else { return 0 }
            let outputRange = to.upperBound - to.lowerBound
            return (value - from.lowerBound) / inputRange * outputRange + to.lowerBound
    }
}

        
struct DraggableCircle: View {
    var isLeft: Bool
    @Binding var isDragging: Bool
    @Binding var position: CGFloat
    @Binding var otherPosition: CGFloat
    var limit: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 25, height: 25)
                .foregroundColor(Color.accentColor)
            Circle()
                .frame(width: 15, height: 15)
                .foregroundStyle(.white)
        }
        .offset(x: position + (isLeft ? 0 : -5))
        .gesture(
            DragGesture()
                .onChanged({ value in
                    withAnimation {
                        isDragging = true
                    }
                    if isLeft {
                        position = min(max(value.location.x, 0), otherPosition)
                    } else {
                        position = min(max(value.location.x, otherPosition), limit)
                    }
                })
                .onEnded({ value in
                    withAnimation {
                        isDragging = false
                    }
                })
        )
    }
}

//#Preview {
//    RangeSlider()
//}
