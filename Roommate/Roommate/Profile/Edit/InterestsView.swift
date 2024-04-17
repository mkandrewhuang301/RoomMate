//
//  InterestsView.swift
//  Roommate
//
//  Created by Spring2024 on 4/3/24.
//

import SwiftUI

//this is the view for choosing interests
struct InterestsView: View {
    @Binding var isPresented: Bool
    @Binding var selectedInterests: [String]
    @State private var searchText = ""
    
    var interests : [String] = load("interests.json")
   
    var filteredInterests: [String] {
        if searchText.isEmpty {
            return interests
        } else {
            return interests.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
   var body: some View {
       if isPresented {
           NavigationView {
               VStack {
                   ScrollView(.horizontal, showsIndicators: false) {
                       HStack {
                           ForEach(selectedInterests, id: \.self) { interest in
                               SelectedInterestTagView(interest: interest) {
                                   selectedInterests.removeAll(where: { $0 == interest })
                               }
                           }
                       }
                   }
                   .padding()
                   TextField("Search", text:$searchText)
                       .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                       .autocorrectionDisabled()
                       .padding()
                       .padding(.horizontal, 25)
                       .foregroundColor(.black)
                       .frame(
                        width: 350,
                        height: 40,
                        alignment: .center
                       )
                       .background(Color(.systemGray6))
                       .cornerRadius(10)
                       .overlay(
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 10)
                            .frame(minWidth:0, maxWidth: . infinity, alignment: .leading)
                       )
                       .padding(.horizontal, 10)
                   //ScrollView {
                       WrapView(items: filteredInterests
//                                , selectedItems: $selectedInterests
                       ) { interest in
                           InterestTagView(interest: interest, isSelected: selectedInterests.contains(interest)) {
                               if selectedInterests.contains(interest) {
                                   selectedInterests.removeAll(where: { $0 == interest })
                               } else {
                                   selectedInterests.append(interest)
                               }
                           }
                       }
                       .padding()
                   //}
                   //.frame(maxHeight: .infinity)
               }
               .navigationTitle("Interests")
               .navigationBarItems(trailing: Button("Done", action: {
                   withAnimation {
                       isPresented.toggle()
                   }
               }))
           }
           .transition(.move(edge: .bottom))
       }
   }
}


struct InterestTagView: View {
    let interest: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(interest)
                .foregroundColor(isSelected ? .black : .gray)
                .padding(.horizontal)
        }
        .padding(.vertical, 5)
        .background(.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isSelected ? Color.accentColor : .gray, lineWidth: 2)
        )
    }
}

struct SelectedInterestTagView: View {
    let interest: String
    var action: () -> Void

    var body: some View {
        HStack {
            Text(interest)
                .font(.custom("Helvetica Neue", size: 18))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.leading)
            Button(action: action) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding(.trailing)
            }
        }
        .padding(.vertical, 5)
        .background(Color.accentColor)
        .cornerRadius(20)
    }
}

struct WrapView<ItemView: View>: View {
    var items: [String]
    var content: (String) -> ItemView

    @State var totalHeight = CGFloat.infinity
    
    var body: some View {
        ScrollView {
            VStack {
                GeometryReader { geometry in
                    self.generateContent(in: geometry)
                }
            }
            .frame(height: totalHeight)
        }
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        var lastHeight = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(items, id: \.self) { item in
                self.content(item)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > geometry.size.width) {
                            width = 0
                            height -= lastHeight
                        }
                        let result = width
                        if item == items.last {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { d in
                        let result = height
                        if item == items.last {
                            height = 0
                        } else {
                            lastHeight = d.height
                        }
                        return result
                    })
                    .background(GeometryReader { geo in
                        Color.clear.preference(key: ViewHeightKey.self, value: geo.size.height)
                    })
            }
        }
        .onPreferenceChange(ViewHeightKey.self) { self.totalHeight = $0 }
    }
}

private struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { CGFloat.infinity }
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value = min(value, nextValue())
//    }
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

//#Preview {
//    InterestsView()
//}
