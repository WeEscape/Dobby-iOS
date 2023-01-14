//
//  DailyChoreView.swift
//  DobbyMini Watch App
//
//  Created by yongmin lee on 12/22/22.
//

import SwiftUI

struct DailyChoreView: View {
    
    @ObservedObject var viewModel: ChoreViewModel
    
    init(viewModel: ChoreViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            DailyChoreHeaderView(viewModel: viewModel)
            
            if viewModel.currentChoreList.isEmpty {
                Text("집안일이 없습니다.")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(viewModel.currentChoreList, id: \.choreId) { chore in
                            DailyChoreRowView(
                                chore: chore,
                                viewModel: viewModel
                            )
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("집안일 현황")
        .onAppear(perform: {
            viewModel.getChoreList()
        })
    }
}

struct DailyChoreView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
