//
//  Requestable.swift
//  Github Users
//
//  Created by Vũ Nguyễn on 23/5/25.
//

import UIKit
import RxSwift
import Alamofire
import ObjectMapper

protocol Requestable: URLRequestConvertible {
    associatedtype Output
    
    var basePath: String { get }
    
    var endpoint: String { get }
    
    var httpMethod: HTTPMethod { get }
    
    var params: Parameters { get }
    
    var additionalHeaders: HTTPHeaders { get }
    
    var parameterEncoding: ParameterEncoding { get }
    
    var queue: DispatchQueue { get }
    
    func execute() -> Observable<Output>
    
    func decode(data: Any) -> Output
    
    func connectWithRequest(urlRequest: URLRequest, complete: @escaping (AFDataResponse<Data>) -> Void) -> DataRequest
}

extension Requestable {
    var basePath: String {
        return Constants.API_DOMAIN
    }
    
    var params: Parameters {
        return [:]
    }
    
    var additionalHeaders: HTTPHeaders {
        return [:]
    }
    
    var defaultHeaders: HTTPHeaders {
        var values: HTTPHeaders = [:]
        values["Accept"] = "application/json"
        return values
    }
    
    var urlPath: String {
        return basePath + endpoint
    }
    
    var url: URL {
        return URL(string: urlPath)!
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var queue: DispatchQueue {
        return DispatchQueue.global(qos: .default)
    }
    
    @discardableResult
    func execute() -> Observable<Output> {
        return toObservable()
    }

    private func toObservable() -> Observable<Output> {
        return Observable.create { observer in
            guard let urlRequest = try? self.asURLRequest() else {
                observer.onError(NSError(domain: "com.nwanvu.unknownError", code: 0))
                return Disposables.create()
            }
            debugPrint("--> \(urlRequest.method?.rawValue ?? "") \(urlRequest.url?.absoluteString ?? "")")
            let connect = self.connectWithRequest(urlRequest: urlRequest, complete: { response in
                do {
                    guard let dataResponse = response.data else {
                        if response.response?.statusCode == 500,
                           let dataResponse = response.data {
                            let message = String(data: dataResponse, encoding: .utf8)
                            let userInfo = [NSLocalizedDescriptionKey: message ?? ""]
                            observer.onError(NSError(domain: "com.nwanvu.apiError", code: 1, userInfo: userInfo))
                        } else {
                            observer.onError(NSError(domain: "com.nwanvu.mapperError", code: 2))
                        }
                        return
                    }
                    
                    let json = try JSONSerialization.jsonObject(with: dataResponse, options: .allowFragments)
                    
                    debugPrint("<-- \(response.response?.statusCode ?? 0)")
                    debugPrint(json)
                    
                    if response.response?.statusCode != 200 {
                        let userInfo = [NSLocalizedDescriptionKey: response.response?.description ?? ""]
                        observer.onError(NSError(domain: "com.nwanvu.apiError", code: 1, userInfo: userInfo))
                        return
                    }
                    observer.onNext(self.decode(data: json))
                    observer.onCompleted()
                } catch {
                    observer.onError(NSError(domain: "com.nwanvu.serverError", code: 2))
                }
            })
            
            return Disposables.create {
                connect.cancel()
            }
        }
    }
    
    func connectWithRequest(urlRequest: URLRequest, complete: @escaping (AFDataResponse<Data>) -> Void) -> DataRequest {
//        let oauthHandler = OAuth2Handler()
//        let sessionManager = Alamofire.SessionManager.default
//        if sessionManager.retrier == nil {
//            sessionManager.retrier = oauthHandler
//        }
//        sessionManager.adapter = oauthHandler
//        let request = sessionManager.request(urlRequest)
//
//        debugPrint(request)
//        request
//            .validate(statusCode: 200..<300)
//            .validate(contentType: ["application/json", "text/plain"])
//            .responseData(completionHandler: { response in
//                complete(response)
//            })
//
        
        return AF.request(urlRequest)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json", "text/plain"])
            .responseData(completionHandler: { response in
                complete(response)
            })
//        return request
    }

    fileprivate func buildURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.timeoutInterval = TimeInterval(Constants.API_TIMEOUT)
        
        urlRequest = try parameterEncoding.encode(urlRequest, with: params)
        
        defaultHeaders.forEach { e in
            urlRequest.addValue(e.value, forHTTPHeaderField: e.name)
        }
        
        additionalHeaders.forEach { e in
            urlRequest.addValue(e.value, forHTTPHeaderField: e.name)
        }
        return urlRequest
    }
}

// MARK: - Conform URLConvertible from Alamofire
extension Requestable {
    func asURLRequest() throws -> URLRequest {
        return try buildURLRequest()
    }
}
