//
//  NetworkService.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import Foundation
import RxSwift
import Moya

protocol NetworkService {
    var provider:  MoyaProvider<MultiTarget> { get }
    func request<API>(api: API) -> Single<Result<API.Response, Error>> where API : BaseAPI
}

final class NetworkServiceImpl: NetworkService {
    var provider: MoyaProvider<MultiTarget>
    static let shared = NetworkServiceImpl(
        provider: MoyaProvider<MultiTarget>(
            plugins: [NetworkLoggerPlugin()]
        )
    )
    
    private init(provider: MoyaProvider<MultiTarget>) {
        self.provider = provider
    }
    
    
    func request<API>(api: API) -> Single<Result<API.Response, Error>> where API : BaseAPI {
        let endpoint = MultiTarget.target(api)
        return self.requestPreprocess(api: api)
            .map { res in
                let response = try JSONDecoder().decode(API.Response.self, from: res.data)
                return .success(response)
            }
            .catch { err in
                if let urlErr = err as? URLError {
                    return .just(.failure(urlErr))
                }
                return .just(.failure(err))
            }
    }
    
    private func requestPreprocess<API>(api: API) -> Single<Response> where API: BaseAPI {
        let endpoint = MultiTarget.target(api)
        return self.provider.rx.request(endpoint)
            .map { res -> Response in
                let statusCode = res.statusCode
                BeaverLog.debug("Network response status code : \(statusCode)")
                guard !(statusCode == 401) else { throw NetworkError.invalidateAccessToken }
                guard !(400..<500 ~= statusCode) else { throw NetworkError.client }
                guard !(500..<600 ~= statusCode) else { throw NetworkError.server }
                return res
            }
    }
}
