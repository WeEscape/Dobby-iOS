//
//  ChoreViewModel.swift
//  DobbyMini Watch App
//
//  Created by yongmin lee on 12/25/22.
//

import Foundation

class ChoreViewModel: ObservableObject {
    
    @Published var currentDate: Date = Date()
    @Published var choreList: [Chore] = [
        Chore(choreId: "1", title: "mock1", categoryId: "", noticeEnable:0, executeAt: "", endAt: "", ownerList: [.init(userId: "1", isEnd: 0)]),
        Chore(choreId: "2", title: "mock2", categoryId: "", noticeEnable:0, executeAt: "", endAt: "", ownerList: [.init(userId: "2", isEnd: 1)]),
        Chore(choreId: "3", title: "mock3", categoryId: "", noticeEnable:0, executeAt: "", endAt: "", ownerList: [.init(userId: "3", isEnd: 1)]),
        Chore(choreId: "4", title: "mock4", categoryId: "", noticeEnable:0, executeAt: "", endAt: "", ownerList: [.init(userId: "4", isEnd: 0)])
    ]
    let choreUseCase: ChoreUseCase
    
    init(choreUseCase: ChoreUseCase) {
        self.choreUseCase = choreUseCase
    }
    
    func getChoreList(of date: Date) {
        currentDate = date
        print("debug : getChoreList")
    }
    
    func didTapEndToggle(_ chore: Chore) {
        print("debug : didTapEndToggle -> \(chore.title)")
    }
    
    func didTapDelete(_ chore: Chore) {
        print("debug : didTapDelete -> \(chore.title)")
    }
}
