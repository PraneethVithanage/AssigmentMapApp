//
//  AppService.swift
//  LocationApp
//
//  Created by MacBook on 2022-08-08.
//

import SwiftUI
import Foundation
import Combine

enum APIPath: String {
    case users = "/posts/1/comments"
    case photos = "/posts/1/photos"
    case albums = "/users/1/albums"
    case todos = "/users/1/todos"
    case posts = "/users/1/posts"
}

extension URLRequest {
    
    static let baseUrl = URL(string: "https://jsonplaceholder.typicode.com")!
    static let path = APIPath.self
    
    static public func getUserData() -> URLRequest {
        var component: URLComponents?
        component = URLComponents(url: baseUrl.appendingPathComponent(path.users.rawValue), resolvingAgainstBaseURL: true)
        var request = URLRequest(url: (component?.url)!)
        request.httpMethod = "GET"
        return request
    }
    
    static public func getPostData() -> URLRequest {
        var component: URLComponents?
        component = URLComponents(url: baseUrl.appendingPathComponent(path.photos.rawValue), resolvingAgainstBaseURL: true)
        var request = URLRequest(url: (component?.url)!)
        request.httpMethod = "GET"
        return request
    }
    static public func getAlbumsData() -> URLRequest {
        var component: URLComponents?
        component = URLComponents(url: baseUrl.appendingPathComponent(path.albums.rawValue), resolvingAgainstBaseURL: true)
        var request = URLRequest(url: (component?.url)!)
        request.httpMethod = "GET"
        return request
    }
    static public func getTodosData() -> URLRequest {
        var component: URLComponents?
        component = URLComponents(url: baseUrl.appendingPathComponent(path.todos.rawValue), resolvingAgainstBaseURL: true)
        var request = URLRequest(url: (component?.url)!)
        request.httpMethod = "GET"
        return request
    }
    
    static public func getPostsData() -> URLRequest {
        var component: URLComponents?
        component = URLComponents(url: baseUrl.appendingPathComponent(path.posts.rawValue), resolvingAgainstBaseURL: true)
        var request = URLRequest(url: (component?.url)!)
        request.httpMethod = "GET"
        return request
    }
    
}

extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
extension URLSession {
    static public func fetch(request: URLRequest, completion: @escaping(Result<String,MIError>)->()) {
        
        URLSession.shared.dataTask(with: request) { (data,resp,err) in
            
            if let err = err {
                completion(.failure(MIError(message: err.localizedDescription)))
                Functions.printdetails(msg: "|| Failed to retrieved data from \(request.url?.absoluteString ?? "") error is \(err)")
                return
            }
            if let response = resp as? HTTPURLResponse {
                // print the response
                print(response)
                if response.statusCode == 200 {
                    let response = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                    Functions.printdetails(msg: "|| Retrieved data from \(request.url?.absoluteString ?? "")")
                    completion(.success(response.removeXML))
                } else if response.statusCode == 404 {
                    completion(.failure(MIError(status: 404,message: "|| not found")))
                }
                else if response.statusCode == 400 {
                    completion(.failure(MIError(status: 400,message: "|| Bad Request")))
                }
                else if response.statusCode == 401 {
                    completion(.failure(MIError(status: 401,message: "|| Unauthorized access")))
                }
                else if response.statusCode == 500 {
                    completion(.failure(MIError(status: 500,message: "|| Bad Request")))
                }
            }
            
        }.resume()
    }
}
public class Functions {
    static public  func printdetails(msg: String) {
        
        let str = String(repeating: "=", count: (msg.count + 3))
        print(str)
        print("||\(String(repeating: " ", count: (msg.count - 2))) ||")
        print("\(msg) ||")
        print("||\(String(repeating: " ", count: (msg.count - 2))) ||")
        print(str)
        print("")
        print("")
    }
}
extension String {
    public var removeXML: String {
        let strData: String = self
        var startIndex:Range<String.Index>? = nil
        var endIndex:Range<String.Index>? = nil
        if strData.contains("</string>") {
            startIndex = strData.range(of: "<string xmlns=\"http://miserver.homeip.net\">")
            endIndex = strData.range(of: "</string>")
        } else if strData.contains("</int>") {
            startIndex = strData.range(of: "<int xmlns=\"http://miserver.homeip.net\">")
            endIndex = strData.range(of: "</int>")
        } else {
            return strData
        }
        
        let sub = strData[startIndex!.upperBound..<endIndex!.lowerBound]
        return String(sub)
    }
}


