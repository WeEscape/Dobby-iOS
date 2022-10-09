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
    static let shared = NetworkServiceImpl()
    
    private init() {
        self.provider = Self.createProvider()
    }
    
    private static func createProvider() -> MoyaProvider<MultiTarget> {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.urlCredentialStorage = nil
        let session = Session(configuration: configuration)
        return MoyaProvider<MultiTarget>(
            session: session,
            plugins: [NetworkLoggerPlugin()]
        )
    }
    
    func request<API>(api: API) -> Single<Result<API.Response, Error>> where API : BaseAPI {
        let endpoint = MultiTarget.target(api)
        return self.requestPreprocess(api: api)
            .map { res in
                let response = try JSONDecoder().decode(API.Response.self, from: res.data)
                return .success(response)
            }
            .catch { err in
                if let urlErr = err as? URLError,
                   (urlErr.code == .timedOut || urlErr.code == .notConnectedToInternet) {
                    return .just(.failure(urlErr))
                }
                if let networkErr = err as? NetworkError,
                   networkErr == .invalidateAccessToken
                {
                    
                }
                return .just(.failure(err))
            }
    }
    
    private func requestPreprocess<API>(api: API) -> Single<Response> where API: BaseAPI {
        let endpoint = MultiTarget.target(api)
        return self.provider.rx.request(endpoint)
            .map { res -> Response in
                let statusCode = res.statusCode
                BeaverLog.verbose("Network response status code : \(statusCode)")
                guard !(statusCode == 401) else { throw NetworkError.invalidateAccessToken }
                guard !(400..<500 ~= statusCode) else { throw NetworkError.client }
                guard !(500..<600 ~= statusCode) else { throw NetworkError.server }
                return res
            }
    }
}
