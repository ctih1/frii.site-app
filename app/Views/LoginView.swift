//
//  LoginView.swift
//  app
//
//  Created by Onni Nevala on 4.4.2025.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var buttonText: String = "Login"
    @State private var passwordShown: Bool = false
    @State private var warningMessageShown: Bool = false
    @State private var warningMessage: String = ""

    var body: some View {
        NavigationStack {
            VStack(alignment:.leading) {
                Text("Sign into your frii.site account.")
                
                Spacer().frame(height: 50)
                if warningMessageShown {
                    Text(warningMessage).foregroundColor(Color.red)
                }
                GroupBox {
                    Group {
                        Text("Username: ")
                            .font(.headline)
                        TextField("Username", text: $username)
                            .autocorrectionDisabled(true)
                            .autocapitalization(.none)
                    }
                    Spacer().frame(height: 20)
                    Group {
                        Text("Password: ")
                            .font(.headline)
                        HStack {
                            if !passwordShown {
                                SecureField("Password", text: $password)
                            } else {
                                TextField("Password", text: $password)
                            }
                            Spacer()
                            VStack {
                                Toggle(isOn: $passwordShown, label: {
                                    Image(systemName: (passwordShown ? "eye.fill" : "eye.slash.fill"))
                                })
                            }.frame(width: 80)
                            
                        }
                    }.background(Color(.systemGray6))
                    
                    
                }
                
                Spacer()
                Button() {
                    warningMessageShown = false
                    print("Login")
                    buttonText = "Logging in..."
                    APIService().createSession(username: username, password: password, callback: {success,statusCode,sessionId in
                        if success {
                            session = sessionId
                            buttonText = "Succesfully logged in"
                            
                        } else {
                            if statusCode == 403 || statusCode == 401 {
                                warningMessage = "Invalid password"
                            } else if statusCode == 404 {
                                warningMessage = "Account not found"
                            } else {
                                warningMessage = "Login failed with error code \(statusCode)"
                            }
                            
                            warningMessageShown = true
                            
                            buttonText = "Login"
                        }
                        
                        
                    })
                } label: {
                    Text(buttonText)
                        .frame(maxWidth: .infinity, maxHeight: 35)
                }.buttonStyle(.borderedProminent)
                    
                
            }
            .padding()
            .navigationTitle("Login")
            Spacer()
        }

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
