//
//  EditPhotoMatrix.swift
//  Roommate
//
//  Created by Spring2024 on 4/3/24.
//

import SwiftUI

// this is the comonent showing the photos in the profile editing
// page, including 2x2 photos
struct EditPhotoMatrix: View {
    @Binding var imageStrs: [String]
    @State private var showActionSheet = false
    @State private var uploadingNum = -1
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    var body: some View {
        VStack {
            HStack {
                Button(action:{
                    uploadingNum = 0
                    showActionSheet = true
                }) {
                    if imageStrs.count > 0 {
                        EditPhotoItem(imageStr: $imageStrs[0])
                    } else {
                        EditPhotoItem(imageStr: Binding.constant(""))
                    }
                }
                Spacer()
                    .frame(width: 40)
                Button(action:{
                    uploadingNum = 1
                    showActionSheet = true
                }) {
                    if imageStrs.count > 1{
                        EditPhotoItem(imageStr: $imageStrs[1])
                    } else {
                        EditPhotoItem(imageStr: Binding.constant(""))
                    }
                }
            }
            Spacer()
                .frame(height: 30)
            HStack{
                Button(action:{
                    uploadingNum = 2
                    showActionSheet = true
                }) {
                    if imageStrs.count > 2{
                        EditPhotoItem(imageStr: $imageStrs[2])
                    } else {
                        EditPhotoItem(imageStr: Binding.constant(""))
                    }
                }
                Spacer()
                    .frame(width: 40)
                
                Button(action:{
                    uploadingNum = 3
                    showActionSheet = true
                }) {
                    if imageStrs.count > 3 {
                        EditPhotoItem(imageStr: $imageStrs[3])
                    } else {
                        EditPhotoItem(imageStr: Binding.constant(""))
                    }
                }
            }
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text("Upload Photo").bold(), buttons: [
                .default(Text("Camera"), action: {
                    requestCameraPermissions()
                    sourceType = .camera
                    showImagePicker = true
                }),
                .default(Text("Photo Library"), action: {
                    requestPhotoLibraryPermission()
                    sourceType = .photoLibrary
                    showImagePicker = true
                }),
                .cancel()
            ])
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: sourceType) { imageStr in
                if imageStrs.count > uploadingNum && uploadingNum >= 0 {
                    imageStrs[uploadingNum] = imageStr
                } else if imageStrs.count <= uploadingNum && uploadingNum < 4 {
                    imageStrs.append(imageStr)
                }
            }
        }
    }
}
//
//#Preview {
//    EditPhotoMatrix(imageStrs: ["hi", "hi", "hi", "hi"])
//}
