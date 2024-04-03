//
//  ProfileEditView.swift
//  Roommate
//
//  Created by Spring2024 on 4/2/24.
//

import SwiftUI


struct ProfileEditView: View {
    @Binding var user: User
    
    @State private var showAgeSheet = false
    @State private var showGradYearSheet = false
    @State private var showBudgetSheet = false
    @State private var showAwakeTimeSheet = false
    @State private var showAgeRangeSheet = false
    @State private var showInterestSheet = false
    
    var body: some View {
        List {
            Section(header: Text("MEDIA")
                .font(.custom("Helvetica Neue", size: 18))
                .fontWeight(.bold)
                .foregroundColor(.black)
            ) {
                EditPhotoMatrix(imageStrs: $user.photos)
                    .padding()
            }
            Section(header: Text("Basic")
                .font(.custom("Helvetica Neue", size: 18))
                .fontWeight(.bold)
                .foregroundColor(.black)
            ) {
                Picker("Gender", selection: $user.gender) {
                    ForEach(Gender.allCases, id: \.self) { gender in
                        if gender != .Unknown {
                            Text(gender.rawValue).tag(gender)
                        }
                    }
                }
                Button(action: {
                    withAnimation {
                        closeAllSheet()
                        self.showAgeSheet.toggle()
                    }
                }) {
                    HStack {
                        Text("Age")
                            .font(.custom("Helvetica Neue", size: 18))
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Section(header: Text("purpose")
                .font(.custom("Helvetica Neue", size: 18))
                .fontWeight(.bold)
                .foregroundColor(.black)
            ) {
                Picker("Purpose", selection: $user.purpose) {
                    ForEach(Purpose.allCases, id: \.self) { purpose in
                        Text(purpose.rawValue).tag(purpose)
                    }
                }
            }
            
            Section(header: Text("budget")
                .font(.custom("Helvetica Neue", size: 18))
                .fontWeight(.bold)
                .foregroundColor(.black)
            ) {
                Button(action: {
                    withAnimation {
                        closeAllSheet()
                        self.showBudgetSheet.toggle()
                    }
                }) {
                    HStack {
                        Text("Budget")
                            .font(.custom("Helvetica Neue", size: 18))
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Section(header: Text("academic")
                .font(.custom("Helvetica Neue", size: 18))
                .fontWeight(.bold)
                .foregroundColor(.black)
            ) {
                Picker("School", selection: $user.school) {
                    ForEach(School.allCases, id: \.self) { school in
                        Text(school.rawValue).tag(school)
                    }
                }
                Picker("Major", selection: $user.major) {
                    ForEach(Major.allCases, id: \.self) { major in
                        Text(major.rawValue).tag(major)
                    }
                }
                Button(action: {
                    withAnimation {
                        closeAllSheet()
                        self.showGradYearSheet.toggle()
                    }
                }) {
                    HStack {
                        Text("Grad Year")
                            .font(.custom("Helvetica Neue", size: 18))
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Section(header: Text("lifestyle")
                .font(.custom("Helvetica Neue", size: 18))
                .fontWeight(.bold)
                .foregroundColor(.black)
            ) {
                Button(action: {
                    withAnimation {
                        closeAllSheet()
                        self.showAwakeTimeSheet.toggle()
                    }
                }) {
                    HStack {
                        Text("I'm awaking at...")
                            .font(.custom("Helvetica Neue", size: 18))
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
                Toggle(isOn: $user.isSmoke) {
                    Text("Smoking")
                }
                Toggle(isOn: $user.havePets) {
                    Text("Pets")
                }
            }
            
            Section(header: Text("about me")
                .font(.custom("Helvetica Neue", size: 18))
                .fontWeight(.bold)
                .foregroundColor(.black)
            ) {
                TextEditor(text: $user.selfIntro)
                    .frame(height: 100)
            }
            
            Section(header: Text("interests")
                .font(.custom("Helvetica Neue", size: 18))
                .fontWeight(.bold)
                .foregroundColor(.black)
            ) {
                Button(action: {
                    withAnimation {
                        closeAllSheet()
                        self.showAwakeTimeSheet.toggle()
                    }
                }) {
                    HStack {
                        if user.interests.isEmpty {
                            Text("Add interests")
                                .font(.custom("Helvetica Neue", size: 18))
                                .foregroundColor(.black)
                        } else {
                            Text(user.interests.joined(separator: ", "))
                                .font(.custom("Helvetica Neue", size: 18))
                                .foregroundColor(.black)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Section(header: Text("Room")
                .font(.custom("Helvetica Neue", size: 18))
                .fontWeight(.bold)
                .foregroundColor(.black)
            ) {
            }
            
            Section(header: Text("preference")
                .font(.custom("Helvetica Neue", size: 18))
                .fontWeight(.bold)
                .foregroundColor(.black)
            ) {
                Picker("Prefer to find...", selection: $user.preference.gender) {
                    ForEach(Gender.allCases, id: \.self) { gender in
                        if gender != .Unknown {
                            Text(gender.rawValue).tag(gender)
                        }
                    }
                }
                Button(action: {
                    withAnimation {
                        closeAllSheet()
                        self.showAgeRangeSheet.toggle()
                    }
                }) {
                    HStack {
                        Text("Roommate age range")
                            .font(.custom("Helvetica Neue", size: 18))
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
                Toggle(isOn: $user.preference.sameSchool) {
                    Text("Filter only same school")
                }
                Toggle(isOn: $user.preference.sameMajor) {
                    Text("Filter only same major")
                }
            }
            
        }
        .listStyle(GroupedListStyle())
        .overlay(
            WheelPickerView(isPresented: $showAgeSheet, num: $user.age,from: 18, to: 100)
        )
        .overlay(
            WheelPickerView(isPresented: $showGradYearSheet, num: $user.gradYear,from: 2020, to: 2032)
        )
        .overlay(
            SliderPickerView(isPresented: $showBudgetSheet, maxValue: 10000, rangeType:.money, low: $user.budget.min, high: $user.budget.max)
        )
        .overlay(
            SliderPickerView(isPresented: $showAwakeTimeSheet, maxValue: 1440, rangeType:.time, low: $user.sleepSchedule.min, high: $user.sleepSchedule.max)
        )
        .overlay(
            SliderPickerView(isPresented: $showAgeRangeSheet, maxValue: 100, rangeType:.number, low: $user.preference.ageRange.min, high: $user.preference.ageRange.max)
        )
    }
    
    func closeAllSheet() {
        self.showAgeSheet = false
        self.showGradYearSheet = false
        self.showBudgetSheet = false
        self.showAwakeTimeSheet = false
        self.showAgeRangeSheet = false
        self.showInterestSheet = false
    }
}

//#Preview {
//    ProfileEditView()
//}
