//
//  APIService.swift
//  app
//
//  Created by Onni Nevala on 4.4.2025.
//

import Foundation
import CryptoKit

class APIService {
    var serverURL: URL
    init() {
        self.serverURL = URL(string: "https://beta.frii.site/login")!
    }
    
    struct LoginResponse: Codable {
        let authToken: String
        
        enum CodingKeys: String,CodingKey {
            case authToken = "auth-token"
        }
    }
    
    
    public func createSession(username: String, password: String, callback: @escaping ((_ success: Bool, _ statusCode: Int?, _ sessionId: String?)->Void)) { // I'm sorry
        let usernameHash:String = SHA256.hash(data: Data(username.utf8)).map { String(format: "%02hhx", $0) }.joined()
        let passwordHash:String = SHA256.hash(data: Data(password.utf8)).map { String(format: "%02hhx", $0) }.joined()
        
        let loginToken: String = "\(usernameHash)|\(passwordHash)"
        
        var request = URLRequest(url: serverURL)
        
        request.setValue(loginToken, forHTTPHeaderField: "x-auth-request")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            let statusCode = (response as! HTTPURLResponse).statusCode
            print(statusCode)
            let dataString: String = String(data: data!, encoding: .utf8)!
            var sessionData: LoginResponse?
            do {
                sessionData = try JSONDecoder().decode(LoginResponse.self, from: dataString.data(using: .utf8)!)
            } catch _ {
                callback(false, statusCode, "")
            }
            
            
            callback(true, 200, sessionData!.authToken)

        }
        task.resume()

        
        
    }
}
