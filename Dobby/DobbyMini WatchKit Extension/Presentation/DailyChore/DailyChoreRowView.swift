//
//  DailyChoreRowView.swift
//  DobbyMini Watch App
//
//  Created by yongmin lee on 12/25/22.
//

import SwiftUI

struct DailyChoreRowView: View {
    
    var chore: Chore
    @ObservedObject var viewModel: ChoreViewModel
    
    init(chore: Chore, viewModel: ChoreViewModel) {
        self.chore = chore
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                viewModel.didTapEndToggle(chore)
            } label: {
                Image(
                    systemName: isChoreEnd(chore) ? "checkmark.square.fill" : "square"
                )
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(
                    Color(isChoreEnd(chore) ? "textGray2" : "textGray1")
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            .frame(width: 12, height: 12)
            .padding(10)
            .buttonStyle(.plain)
            
            Button {
                viewModel.didTapEndToggle(chore)
            } label: {
                Text(chore.title)
                    .font(.caption2)
                    .fontWeight(.light)
                    .foregroundColor(
                        Color(isChoreEnd(chore) ? "textGray2" : "textWhite")
                    )
            }
            .frame(height: 40)
            .buttonStyle(.plain)
            
            Spacer()
            
            Button {
                viewModel.didTapDelete(chore)
            } label: {
                Image(systemName: "trash.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color("textGray1"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: 15, height: 15)
            .padding(10)
            .buttonStyle(.plain)
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(
                    Color("choreRowBackground")
                )
        }
    }
    
    func isChoreEnd(_ chore: Chore?) -> Bool {
        guard let isEnd = chore?.ownerList?.first?.isEnd else {
            return false
        }
        return isEnd == 1
    }
}

struct DailyChoreRowView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
