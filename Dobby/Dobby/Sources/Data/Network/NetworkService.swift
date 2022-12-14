//
//  NetworkService.swift
//  Dobby
//
//  Created by yongmin lee on 10/2/22.
//

import Foundation
import RxSwift
import Moya
import FirebaseCrashlytics

protocol NetworkService {
    func request<API>(api: API) -> Observable<DobbyResponse<API.Response>> where API: BaseAPI
}

final class NetworkServiceImpl: NetworkService {
    
    private let provider: MoyaProvider<MultiTarget>
    let localStorage: LocalStorageService
    static let shared = NetworkServiceImpl()
    var headers: [String: String] {
        var headers = ["content-type": "application/json;charset=UTF-8"]
        guard let accessToken = self.localStorage.read(
            key: .jwtAccessToken
        ) else { return headers }
        headers["authorization"] = "Bearer \(accessToken)"
        return headers
    }
    
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
    
    func request<API>(api: API) -> Observable<DobbyResponse<API.Response>> where API: BaseAPI {
        return self._request(api: api)
            .catch { [weak self] err -> Observable<Response>  in
                Crashlytics.crashlytics().record(error: err)
                if let urlErr = err as? URLError,
                   (urlErr.code == .timedOut || urlErr.code == .notConnectedToInternet) {
                    BeaverLog.verbose("unstable internet connection")
                    return .error(urlErr)
                }
                if let networkErr = err as? NetworkError,
                   networkErr == .invalidateAccessToken {
                    BeaverLog.verbose("invalidate AccessToken!")
                    guard let self = self else {
                        return .error(NetworkError.unknown(-1, "guard self"))
                    }
                    return self.refreshAccessToken()
                        .flatMap { auth -> Observable<Response> in
                            guard let newAccessToken = auth.accessToken,
                                  let newRefreshToken = auth.refreshToken
                            else {
                                return .error(NetworkError.invalidateRefreshToken)
                            }
                            BeaverLog.verbose("refreshed access token : \(newAccessToken)")
                            BeaverLog.verbose("refreshed refresh token : \(newRefreshToken)")
                            self.localStorage.write(
                                key: .jwtAccessToken, value: newAccessToken
                            )
                            self.localStorage.write(
                                key: .jwtRefreshToken, value: newRefreshToken
                            )
                            return self._request(api: api)
                        }
                        .catch { err in
                            BeaverLog.verbose("invalidate RefreshToken! -> logout")
                            Crashlytics.crashlytics().record(error: err)
                            self.localStorage.delete(key: .jwtAccessToken)
                            self.localStorage.delete(key: .jwtRefreshToken)
                            let appDelegate = UIApplication.shared.delegate as? AppDelegate
                            appDelegate?.rootCoordinator?.startSplash()
                            return .error(NetworkError.invalidateRefreshToken)
                        }
                }
                return .error(err)
            }
            .map { res -> DobbyResponse<API.Response> in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let response = try decoder.decode(DobbyResponse<API.Response>.self, from: res.data)
                return response
            }
            .catch { err in
                BeaverLog.error(err.localizedDescription)
                Crashlytics.crashlytics().record(error: err)
                return .error(err)
            }
    }
    
    private func _request<API>(api: API) -> Observable<Response> where API: BaseAPI {
        let endpoint = MultiTarget.target(api)
        return self.provider.rx.request(endpoint)
            .asObservable()
            .map { res -> Response in
                let statusCode = res.statusCode
                BeaverLog.verbose("Network response status code : \(statusCode)")
                guard !(statusCode == 401) else {
                    throw NetworkError.invalidateAccessToken
                }
                guard !(400..<405 ~= statusCode) else {
                    let errorRes = try? JSONDecoder().decode(
                        DobbyResponse<Bool>.self,
                        from: res.data
                    )
                    throw NetworkError.unknown(statusCode, errorRes?.message)
                }
                guard !(500..<600 ~= statusCode) else { throw NetworkError.server }
                return res
            }
    }
    
    private func refreshAccessToken() -> Observable<Authentication> {
        BeaverLog.verbose("start refresh AccessToken")
        guard let refreshToken = self.localStorage.read(key: .jwtRefreshToken) else {
            BeaverLog.verbose("device doesn't have refreshToken")
            return .error(NetworkError.invalidateRefreshToken)
        }
        return self._request(api: AuthRefreshAPI(refreshToken: refreshToken))
            .map { res in
                let statusCode = res.statusCode
                guard !(statusCode == 401) else {
                    throw NetworkError.invalidateRefreshToken
                }
                let resData = try JSONDecoder().decode(
                    DobbyResponse<AuthRefreshAPI.Response>.self,
                    from: res.data
                )
                return .init(
                    accessToken: resData.data?.accessToken,
                    refreshToken: resData.data?.refreshToken
                )
            }
    }
}
