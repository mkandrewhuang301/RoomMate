//
//  EditPhotoMatrix.swift
//  Roommate
//
//  Created by Spring2024 on 4/3/24.
//

import SwiftUI

struct EditPhotoMatrix: View {
    @Binding var imageStrs: [String]
    
    var body: some View {
        VStack{
            HStack{
                if imageStrs.count > 0 {
                    EditPhotoItem(imageStr: $imageStrs[0])
                } else {
                    EditPhotoItem(imageStr: Binding.constant(""))
                }
                Spacer()
                    .frame(width: 40)
                if imageStrs.count > 1{
                    EditPhotoItem(imageStr: $imageStrs[1])
                } else {
                    EditPhotoItem(imageStr: Binding.constant(""))
                }
            }
            Spacer()
                .frame(height: 30)
            HStack{
                if imageStrs.count > 2{
                    EditPhotoItem(imageStr: $imageStrs[2])
                } else {
                    EditPhotoItem(imageStr: Binding.constant(""))
                }
                Spacer()
                    .frame(width: 40)
                if imageStrs.count > 3{
                    EditPhotoItem(imageStr: $imageStrs[3])
                } else {
                    EditPhotoItem(imageStr: Binding.constant(""))
                }
            }
        }
    }
}
//
//#Preview {
//    EditPhotoMatrix(imageStrs: ["hi", "hi", "hi", "hi"])
//}
