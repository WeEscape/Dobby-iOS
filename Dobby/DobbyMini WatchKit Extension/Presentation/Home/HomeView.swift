//
//  HomeView.swift
//  DobbyMini Watch App
//
//  Created by yongmin lee on 12/25/22.
//

import SwiftUI

struct HomeView: View {
    
    @State var showReLoginView = false
    
    var body: some View {
        GeometryReader { reader in
            let rect = reader.frame(in: .global)
            if showReLoginView {
                ShouldReLoginView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack(alignment: .center) {
                    HStack(spacing: 25) {
                        NavigationLink(
                            destination: DailyChoreView(
                                viewModel: DIContainer.shared.resolve(ChoreViewModel.self)
                            ),
                            label: {
                                NavButton(
                                    image: "dailyChore",
                                    title: "집안일",
                                    rect: rect
                                )
                            }
                        )
                        .buttonStyle(.plain)
                        
                        NavigationLink(
                            destination: MyPageView(),
                            label: {
                                NavButton(
                                    image: "profile",
                                    title: "마이페이지",
                                    rect: rect
                                )
                            }
                        )
                        .buttonStyle(.plain)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .shouldReLogin)) { _ in
            self.showReLoginView = true
        }
        .onReceive(NotificationCenter.default.publisher(for: .didReLogin)) { _ in
            self.showReLoginView = false
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
