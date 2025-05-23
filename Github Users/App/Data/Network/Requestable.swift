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


/// A protocol defining a generic API request structure using Alamofire and RxSwift.
protocol Requestable: URLRequestConvertible {
    /// The expected output type after decoding the API response.
    associatedtype Output
    
    /// The base path for the request.
    var basePath: String { get }
    
    /// The endpoint path for the request.
    var endpoint: String { get }
    
    /// The HTTP method used for the request.
    var httpMethod: HTTPMethod { get }
    
    /// The query parameters to include in the API request.
    var params: Parameters { get }
    
    /// Additional HTTP headers to include in the request.
    var additionalHeaders: HTTPHeaders { get }
    
    /// The encoding strategy for the request parameters (e.g., URL or JSON encoding).
    var parameterEncoding: ParameterEncoding { get }
    
    /// The dispatch queue on which the response is observed.
    var queue: DispatchQueue { get }
    
    /// Executes the request and returns an observable that emits the decoded output.
    func execute() -> Observable<Output>
    
    /// Decodes the raw response data into the expected output type.
    ///
    /// - Parameter data: The raw response data to decode.
    /// - Returns: The decoded output of type `Output`.
    func decode(data: Any) -> Output
    
    /// Executes the network request using Alamofire and calls the completion handler with the response.
    ///
    /// - Parameters:
    ///   - urlRequest: The `URLRequest` to be executed.
    ///   - complete: A completion handler that receives the `AFDataResponse<Data>`.
    /// - Returns: The initiated `DataRequest` object.
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
        return AF.request(urlRequest)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json", "text/plain"])
            .responseData(completionHandler: { response in
                complete(response)
            })
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
