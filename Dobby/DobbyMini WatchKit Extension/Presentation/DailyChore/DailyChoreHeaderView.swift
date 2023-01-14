//
//  DailyChoreHeaderView.swift
//  DobbyMini Watch App
//
//  Created by yongmin lee on 1/9/23.
//

import SwiftUI

struct DailyChoreHeaderView: View {
    
    @ObservedObject var viewModel: ChoreViewModel
    
    init(viewModel: ChoreViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.currentDate.toStringWithFormat())
                    .fontWeight(.bold)
                    .foregroundColor(Color("mainBlue"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .gesture(
                        DragGesture(
                            minimumDistance: 0,
                            coordinateSpace: .local
                        )
                        .onEnded({ value in
                            if value.translation.width < 0 {
                                // next day
                                self.updateDate(diffDate: 1)
                            }
                            if value.translation.width > 0 {
                                // previous day
                                self.updateDate(diffDate: -1)
                            }
                        })
                    )
            }
        }
        .frame(height: 40)
    }
    
    func updateDate(diffDate: Int) {
        guard let newDate = viewModel.currentDate.calculateDiffDate(diff: diffDate) else {return}
        viewModel.currentDate = newDate
        viewModel.getChoreList()
    }
}

struct DailyChoreHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
