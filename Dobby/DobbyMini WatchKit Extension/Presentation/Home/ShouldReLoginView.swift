//
//  ShouldReLoginView.swift
//  DobbyMini WatchKit Extension
//
//  Created by yongmin lee on 1/14/23.
//

import SwiftUI

struct ShouldReLoginView: View {
    var body: some View {
        Text("모바일 앱에서 재로그인이 필요합니다.")
            .foregroundColor(.white) 
    }
}

struct ShouldReLoginView_Previews: PreviewProvider {
    static var previews: some View {
        ShouldReLoginView()
    }
}
