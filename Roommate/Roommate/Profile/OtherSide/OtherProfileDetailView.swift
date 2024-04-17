//
//  OtherProfileDetailView.swift
//  Roommate
//
//  Created by Spring2024 on 4/4/24.
//

import SwiftUI

// this is the profile detail view shown from other users' view
struct OtherProfileDetailView: View {
    @Binding var user: User
    @Binding var showDetail: Bool
    var body: some View {
        ZStack {
            HStack{
                Text("\(user.fName)")
                    .font(.custom("Helvetica Neue", size: 40))
                    .fontWeight(.black)
                    .foregroundStyle(.black)
                Text("\(user.age)")
                     .font(.custom("Helvetica Neue", size: 40))
                     .foregroundStyle(.black)
                Spacer()
            }
            .padding()
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        showDetail.toggle()
                    }
                }) {
                    Image(systemName: "arrowshape.down.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color("crystal"))
                        .padding(.trailing)
                }
            }
        }
        ScrollView {
            VStack (spacing: 0) {
                PhotosViewer(user: $user, showDetail: .constant(false), showName: false, showAge: false, showInterests: false, showDetailButton: false, cardStyle: false)
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("About me")
                            .font(.custom("Helvetica Neue", size: 20))
                            .fontWeight(.black)
                            .padding()
                        Text(user.selfIntro)
                            .font(.custom("Helvetica Neue", size: 20))
                            .frame(width: UIScreen.main.bounds.width - 60, alignment: .leading)
                            .padding()
                    }
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                    .frame(width: UIScreen.main.bounds.width - 30)
                    .fixedSize()
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Essentials")
                            .font(.custom("Helvetica Neue", size: 20))
                            .fontWeight(.black)
                            .padding()
                        InfoRow(title: "Budget", detail: "$\(user.budget.min) - $\(user.budget.max)")
                        InfoRow(title: "Purpose", detail: user.purpose.rawValue)
                    }
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                    .frame(width: UIScreen.main.bounds.width - 30)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Academics")
                            .font(.custom("Helvetica Neue", size: 20))
                            .fontWeight(.black)
                            .padding()
                        InfoRow(title: "School", detail: user.school.rawValue)
                        InfoRow(title: "Major", detail: user.major.rawValue)
                        InfoRow(title: "Graduation Year", detail: "\(user.gradYear)")
                    }
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                    .frame(width: UIScreen.main.bounds.width - 30)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Interest")
                            .font(.custom("Helvetica Neue", size: 20))
                            .fontWeight(.black)
                            .padding()
                        ScrollView {
                            WrapView(items: user.interests
//                                     , selectedItems: $user.interests
                            ) { interest in
                                InterestBulletView(interest: interest)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .frame(height: 200)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                    .frame(width: UIScreen.main.bounds.width - 30)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Lifestyle")
                            .font(.custom("Helvetica Neue", size: 20))
                            .fontWeight(.black)
                            .padding()
                        InfoRow(title: "Awake during", detail: "\(user.sleepSchedule.min/60):\((user.sleepSchedule.min%60 < 10) ? "0" : "")\(user.sleepSchedule.min%60) - \(user.sleepSchedule.max/60):\((user.sleepSchedule.max%60 < 10) ? "0" : "")\(user.sleepSchedule.max%60)")
                        InfoRow(title: "Smoking", detail: user.isSmoke ? "Smoker" : "Non-smoker")
                        InfoRow(title: "Pets", detail: user.isSmoke ? "Have Pets" : "No Pets")
                    }
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
                    .frame(width: UIScreen.main.bounds.width - 30)
                    .padding(.horizontal)
                    Spacer()
                }
                .frame(minHeight: UIScreen.main.bounds.height, maxHeight: .infinity)
                .padding(.vertical)
                .background(Color("crystal").opacity(0.9))
            }
        }
    }
}

struct InfoRow: View {
    var title: String
    var detail: String
    
    var body: some View {
        VStack {
            Divider()
            HStack {
                Text(title)
                    .font(.custom("Helvetica Neue", size: 20))
                Spacer()
                Text(detail)
                    .foregroundColor(.gray)
                    .font(.custom("Helvetica Neue", size: 20))
            }.padding()
        }
    }
}

//#Preview {
//    OtherProfileDetailView()
//}
