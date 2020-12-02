//
//  API.swift
//  Appt
//
//  Created by Jan Jaap de Groot on 26/05/2020.
//  Copyright © 2020 Stichting Appt All rights reserved.
//

import Foundation
import Alamofire

class API {
    
    static let shared = API()
    
    private let decoder = JSONDecoder()
    
    private lazy var headers: [String: String] = [
        "Platform": "iOS",
        "Version": Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    ]
    
    private init() {
        // Access through shared property
    }
    
    // MARK: - Get articles
    
    func getArticles<T: Article>(type: ArticleType, page: Int, categories: [Category]? = nil, tags: [Tag]? = nil, callback: @escaping (Response<[T]>) -> ()) {
        var parameters: [String: Any] = [
            "_fields": "type,id,date,title",
            "page": page
        ]
    
        if let categoryIDs = categories?.selected.ids {
            parameters["categories"] = categoryIDs.joined(separator: ",")
        }
        
        if let tagIDs = tags?.selected.ids {
            parameters["tags"] = tagIDs.joined(separator: ",")
        }
       
        getObject(path: "\(type.path)?per_page=20", parameters: parameters, type: [T].self, callback: callback)
    }
    
    func getArticle<T: Article>(type: ArticleType, id: Int, callback: @escaping (Response<T>) -> ()) {
        getObject(path: "\(type.path)/\(id)", parameters: ["_fields": "type,id,date,modified,link,title,content,author,tags,categories"], type: T.self, callback: callback)
    }
    
    func getArticle<T: Article>(type: ArticleType, slug: String, callback: @escaping (Response<T>) -> ()) {
        getObject(path: "\(type.path)?per_page=1", parameters: ["slug": slug, "_fields": "type,id,date,modified,link,title,content,author,tags,categories"], type: [T].self) { (response) in
            if let article = response.result?.first {
                callback(Response(result: article, total: response.total, pages: response.pages, error: response.error))
            } else {
                callback(Response(error: response.error))
            }
        }
    }

    // MARK: - Get categories
    
    func getCategories(callback: @escaping (Response<[Category]>) -> ()) {
        getObject(path: "categories", parameters: ["_fields": "id,count,description,name"], type: [Category].self, callback: callback)
    }
    
    // MARK: - Get tags
       
    func getTags(callback: @escaping (Response<[Tag]>) -> ()) {
       getObject(path: "tags", parameters: ["_fields": "id,count,description,name"], type: [Tag].self, callback: callback)
    }
    
    // MARK: - Get filters
       
    func getFilters(callback: @escaping ([Category]?, [Tag]?, Error?) -> ()) {
        getCategories { (response1) in
            if let categories = response1.result {
                self.getTags { (response2) in
                    if let tags = response2.result {
                        callback(categories, tags, nil)
                    } else {
                        callback(nil, nil, response2.error)
                    }
                }
            } else {
                callback(nil, nil, response1.error)
            }
        }
    }
}

// MARK: - Networking

extension API {
    
    private func postObject<T: Decodable>(path: String, data: Encodable?, type: T.Type, callback: @escaping(Response<T>) -> ()) {
        let parameters = data?.asDictionary ?? nil
        retrieveObject(path: path, method: .post, parameters: parameters, encoding: JSONEncoding.default, type: type, callback: callback)
    }
    
    private func getObject<T: Decodable>(path: String, parameters: Parameters?, type: T.Type, callback:   @escaping(Response<T>) -> ()) {
        retrieveObject(path: path, method: .get, parameters: parameters, encoding: URLEncoding.default, type: type, callback: callback)
    }
    
    private func retrieveObject<T: Decodable>(path: String, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, type: T.Type, callback: @escaping(Response<T>) -> ()) {
        guard let url = URL(string: Config.endpoint + path) else { return }
        
        Alamofire.request(url,
                          method: method,
                          parameters: parameters,
                          encoding: encoding,
                          headers: self.headers
        ).validate(statusCode: 200..<300)
         .responseJSON { (response) in
            let response = Response<T>(response)
            callback(response)
        }
    }
}
