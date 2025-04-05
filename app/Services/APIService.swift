//
//  APIService.swift
//  app
//
//  Created by Onni Nevala on 4.4.2025.
//

import Foundation
import CryptoKit

class APIService {
    var serverURL: String
    init() {
        serverURL = "https://beta.frii.site"
    }
    
    struct LoginResponse: Codable {
        let authToken: String
        
        enum CodingKeys: String,CodingKey {
            case authToken = "auth-token"
        }
    }
    
    public struct Domain: Codable {
        var ip: String
        let registered: Float32
        var type: String
        let id: String
    }
    
    struct DomainModifications: Encodable {
        let domain: String
        let value: String
        let type: String
    }
    
    private func sendRequest(req: URLRequest, callback: @escaping ((_ success: Bool, _ statusCode: Int, _ data: String)->Void)) {
        URLSession.shared.dataTask(with: req) {data, response, error in
            let statusCode: Int = (response as! HTTPURLResponse).statusCode
            let retrievedData: String = String(data: data!, encoding: .utf8)!
            
            callback(statusCode == 200, statusCode, retrievedData)
        }.resume()
    }
    
    
    public func createSession(username: String, password: String, callback: @escaping(Bool, Int, String) -> Void) {
        let usernameHash:String = SHA256.hash(data: Data(username.utf8)).map { String(format: "%02hhx", $0) }.joined()
        let passwordHash:String = SHA256.hash(data: Data(password.utf8)).map { String(format: "%02hhx", $0) }.joined()
        
        let loginToken: String = "\(usernameHash)|\(passwordHash)"
        
        let url = URL(string: serverURL + "/login")!
        
        var request = URLRequest(url: url)
        
        request.setValue(loginToken, forHTTPHeaderField: "x-auth-request")
        request.httpMethod = "POST"
        
        
        sendRequest(req: request) { success, statusCode, data in
            let loginResponse:LoginResponse = try! JSONDecoder().decode(LoginResponse.self, from: data.data(using:.utf8)!)
            callback(success,statusCode,loginResponse.authToken)
        }
        
    }
    
    public func getUserDomains(callback: @escaping (Bool, Int, [String: Domain]) -> Void) {
        let url = URL(string: serverURL + "/domain/get")!
        
        var request = URLRequest(url: url)
        
        request.setValue(session, forHTTPHeaderField: "x-auth-token")
        request.httpMethod = "GET"
        
        sendRequest(req: request) { success, statusCode, data in
            if statusCode != 200 {
                callback(success, statusCode, [:])
                return
            }
            let domainData:[String: Domain] = try! JSONDecoder().decode([String: Domain].self, from: data.data(using:.utf8)!)
            
            return callback(success,statusCode,domainData)
        }
    }
    
    public func modifyDomain(domain: String, value: String, type: String, callback: @escaping (Bool, Int) -> Void) {
        let body = try! JSONEncoder().encode(DomainModifications(domain: domain, value: value, type: type))
        
        let url = URL(string: serverURL + "/domain/modify")
        var request = URLRequest(url:url!)
        request.setValue(session, forHTTPHeaderField: "x-auth-token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        request.httpMethod = "PATCH"
        
        sendRequest(req: request) { success, statusCode, _ in
            callback(success,statusCode)
        }
    }
    
    public func deleteDomain(domain: String, callback: @escaping (Bool, Int) -> Void) {
        let url = URL(string: serverURL + "/domain/delete?domain=\(domain)")
        var request = URLRequest(url:url!)
        request.setValue(session, forHTTPHeaderField: "x-auth-token")
        request.httpMethod = "DELETE"
        
        sendRequest(req: request) { success, statusCode, _ in
            callback(success,statusCode)
        }
    }
}

