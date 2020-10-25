//
//  FlickrAPIProvider.swift
//  FlickrImagesiOS
//
//  Created by Umut SERIFLER on 25/10/2020.
//

import Foundation

class FlickrAPIProvider: NSObject {
    
    let urlSession = URLSession.shared
    
    static let shared = FlickrAPIProvider()
    
    private func request<T : Decodable>(_ urlRequest : URLRequest, completionHandler: @escaping (Result<T, FlickrError>)->()) {
        let task = self.urlSession.dataTask(with: urlRequest) {(data, response, error) in
            guard let data = data else {
                if let err = error as NSError? {
                    completionHandler(.failure(FlickrError(msg: err.localizedDescription)))
                }
                return
            }
            if let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode,
               error == nil {
                do {
                    let decodedModel = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(decodedModel))
                } catch {
                    completionHandler(.failure(FlickrError(msg: "Parse Error")))
                }
            } else {
                completionHandler(.failure(FlickrError(msg: error?.localizedDescription)))
            }
        }
        task.resume()
    }
    
    private func getURLRequest(serviceName: String, requestType: HttpRequestType = .get, body: Data? = nil, completionHandler: @escaping (URLRequest) -> ()) {
        let validUrl =  serviceName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        var urlRequest = URLRequest(url: URL(string: validUrl!)!)
        switch requestType {
        case .get,
             .delete,
             .put:
            urlRequest.httpMethod = requestType.rawValue
        case .post:
            urlRequest.httpMethod = requestType.rawValue
            if body != nil {
                urlRequest.httpBody = body!
            }
        }
        completionHandler(urlRequest)
    }
    
    
    private func getRequest<T: Decodable>(serviceName: String, completionHandler: @escaping (Result<T, FlickrError>)->()) {
        
        ConnectionManager.isUnreachable { _ in
            completionHandler(.failure(FlickrError(msg: "No network connection..")))
            return
        }
        
        self.getURLRequest(serviceName: serviceName, requestType: .get) { (urlRequest) in
            self.request(urlRequest, completionHandler: completionHandler)
        }
    }
    
    func search(flickrSearch: FlickrSearch,completionHandler: @escaping (Result<FlickrResultModel, FlickrError>) ->()) {
        self.getRequest(serviceName: FlickrServices.searchService(word: flickrSearch.searchString, page: flickrSearch.page), completionHandler: completionHandler)
    }
    
    
    
    
    
}
