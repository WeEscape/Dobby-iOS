//
//  HomeView.swift
//  DobbyMini Watch App
//
//  Created by yongmin lee on 12/25/22.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        GeometryReader { reader in
            let rect = reader.frame(in: .global)
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
