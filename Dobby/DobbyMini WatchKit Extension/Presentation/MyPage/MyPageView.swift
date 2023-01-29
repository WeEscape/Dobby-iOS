//
//  MyPageView.swift
//  DobbyMini Watch App
//
//  Created by yongmin lee on 12/22/22.
//

import SwiftUI

struct MyPageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: MyPageViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 8) {
                ProfileImage()
                NameText()
                GroupCodeText()
            }
            .padding(.top, 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("마이페이지")
        .task {
            viewModel.getMyInfo()
        }
        .onReceive(NotificationCenter.default.publisher(for: .shouldReLogin)) { _ in
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    @ViewBuilder
    func ProfileImage() -> some View {
        HStack(alignment: .center) {
            AsyncImage(url: URL(string: viewModel.profileUrl)) { img in
                img.resizable()
            } placeholder: {
                Rectangle()
                    .foregroundColor(.gray)
            }
            .cornerRadius(10)
            .frame(width: 50, height: 50)

        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    func NameText() -> some View {
        Text(viewModel.userName)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    func GroupCodeText() -> some View {
        Text(viewModel.groupCode)
            .font(.body)
            .fontWeight(.medium)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity)
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
