//
//  APIManager.swift
//
//  Created by Admin on 07/10/23.
//

import Foundation
import CryptoSwift
import CommonCrypto


struct APIURLS {
    let baseURL = "https://gateway.marvel.com:443"
    let charcterAPI = "/v1/public/characters"
    let comicsAPI = "/v1/public/comics"
}



class APIRequest {
        private let publicKey = "069c35ca9d8a62dbad131048a2a8900f"
        private let privateKey = "0f7053e6b5e86128af0c6cf206ce55ff84759e2a"
    
    func generateHash(timestamp: String) -> String {
           let input = "\(timestamp)\(privateKey)\(publicKey)"
           return input.md5
       }
    
    func callAPI<T: Codable>(URLstring: String, model: T.Type, queryParameters: [String: String] = [:],nameStartsWith:String = "", completion: @escaping (Bool, T?) -> ()) {
        
        let timestamp = String(Date().timeIntervalSince1970)
        let hash = generateHash(timestamp: timestamp)

        
        var components = URLComponents(string: APIURLS().baseURL + URLstring)
        var queryItems = [URLQueryItem]()
        
        
        for (key, value) in queryParameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        queryItems.append(URLQueryItem(name: "ts", value: timestamp))
        queryItems.append(URLQueryItem(name: "apikey", value: publicKey))
        queryItems.append(URLQueryItem(name: "hash", value: hash))
       
        //MARK: Search Query Handel
        if nameStartsWith != "" {
            queryItems.append(URLQueryItem(name: "nameStartsWith", value: nameStartsWith))
        }
       
        
        
        components?.queryItems = queryItems
        
        guard let modifiedURL = components?.url else {
            print("Invalid URL")
            completion(false, nil)
            return
        }
        
        var request = URLRequest(url: modifiedURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            if let data = data {
                
                do {
                    let jsonDecoder = JSONDecoder()
                    let userData = try! jsonDecoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(true, userData)
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        completion(false, nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(false, nil)
                }
            }
        }
        
        task.resume()
    }
}



struct APIFAILED {
    static var shared = APIFAILED()
    let APIERRORCODE1 = "NO_DATA_FOUND"
    let APIERRORCODE2 = "APIFAILED_PARSING"
}

extension String {
    var md5: String {
        let data = Data(self.utf8)
        var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ = data.withUnsafeBytes {
            CC_MD5($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
}
