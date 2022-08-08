//
//  LocationViewModel.swift
//  LocationApp
//
//  Created by MacBook on 2022-08-08.
//

import SwiftUI

class LocationViewModel: ObservableObject {
    
    @Published var postDetail :PostDetails?
    @Published var userLists : UserDetails?
    
    init() {
        getPosts()
    }
    
    func getUsers() {
        
        URLSession.fetch(request: URLRequest.getUserData(), completion: { resp in
            switch resp {
                
            case .success(let result):
                
                if let data = result.data(using: .utf8){
                    do {
                        let decodedResponse = try JSONDecoder().decode(UserDetails.self, from: data)
                        DispatchQueue.main.async {
                            self.userLists = decodedResponse
                        }
                    } catch let jsonError as NSError {
                        print("JSON decode failed: \(jsonError.localizedDescription)")
                    }
                    return
                }
                
            case .failure(_):
                print("Error")
                
            }
        })
    }
    
    func getPosts() {
        
        URLSession.fetch(request: URLRequest.getPostData(), completion: { resp in
            switch resp {
                
            case .success(let result):
                
                if let data = result.data(using: .utf8){
                    do {
                        let decodedResponse = try JSONDecoder().decode(PostDetails.self, from: data)
                        DispatchQueue.main.async {
                            self.postDetail = decodedResponse
                        }
                    } catch let jsonError as NSError {
                        print("JSON decode failed: \(jsonError.localizedDescription)")
                    }
                    return
                }
                
            case .failure(_):
                print("Error")
                
            }
        })
    }
}


