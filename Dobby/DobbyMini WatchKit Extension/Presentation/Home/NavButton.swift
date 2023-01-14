//
//  NavButton.swift
//  DobbyMini Watch App
//
//  Created by yongmin lee on 12/25/22.
//

import SwiftUI

struct NavButton: View {
    var image: String
    var title: String
    var rect: CGRect
    
    var body: some View{
        VStack(spacing: 8){
            Image(image)
                .aspectRatio(contentMode: .fit)
                .frame(
                    width: rect.width / 3,
                    height: rect.width / 3,
                    alignment: .center
                )
                .background(
//                    Color(image + "Color")
                    Color("navBtnBackground")
                )
                .clipShape(Circle())
            
            Text(title)
                .font(.system(size: 10))
                .foregroundColor(.white)
        }
    }
}

struct NavButton_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
