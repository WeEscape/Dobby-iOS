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
//    func request<API>(api: API) -> Single<API.Response> where API : BaseAPI
}

final class NetworkServiceImpl: NetworkService {
    
    var provider: MoyaProvider<MultiTarget>
    weak var localStorage: LocalTokenStorageService?
    static let shared = NetworkServiceImpl()
    
    private init() {
        self.provider = Self.createProvider()
        self.localStorage = UserDefaults.standard
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
    
    func request<API>(api: API) -> Single<API.Response> where API : BaseAPI {
        let endpoint = MultiTarget.target(api)
        return self.requestPreprocess(api: api)
            .map { res in
                let response = try JSONDecoder().decode(API.Response.self, from: res.data)
                return response
            }
            .catch { [weak self] err in
                if let urlErr = err as? URLError,
                   (urlErr.code == .timedOut || urlErr.code == .notConnectedToInternet) {
                    return .error(urlErr)
                }
                if let networkErr = err as? NetworkError,
                   networkErr == .invalidateAccessToken
                {
                    BeaverLog.debug("invalidate AccessToken!")
                    guard let self = self else {return}
                    return self.refreshAccessToken()
                        .do(onSuccess: { auth in
                            guard let newAccessToken = auth.accessToken else { return }
                            BeaverLog.verbose("new access token : \(newAccessToken)")
                            self.localStorage?.write(key: .accessToken, value: newAccessToken)
                        }).flatMap({ auth -> Single<API.Response> in
                            BeaverLog.verbose("resend api with new Access Token")
                            return self.requestPreprocess(api: api)
                        }).catch { err in
                            BeaverLog.debug("invalidate RefreshToken! -> logout")
                            self.localStorage?.delete(key: .accessToken)
                            self.localStorage?.delete(key: .refreshToken)
                            return .error(err)
                        }
                }
                return .error(err)
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
    
    private func refreshAccessToken() -> Single<Authentication> {
        BeaverLog.verbose("start refresh AccessToken")
        guard let refreshToken = self.localStorage?.read(key: .refreshToken) else {
            BeaverLog.verbose("device doesn't have refreshToken")
            return .error(NetworkError.invalidateRefreshToken)
        }
        return requestPreprocess(api: AuthRefreshAPI(refreshToken: refreshToken))
            .map { res in
                let statusCode = res.statusCode
                guard !(statusCode == 401) else { throw NetworkError.invalidateRefreshToken }
                let resData = try JSONDecoder().decode(AuthRefreshAPI.Response.self, from: res.data)
                return .init(
                    accessToken: resData.aceessToken,
                    refreshToken: resData.refreshToken
                )
            }
    }
}
