//
//  NetworkService.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import Foundation

protocol NetworkService {
    
}

final class NetworkServiceImpl: NetworkService {
    
    static let shared = NetworkServiceImpl()
}
