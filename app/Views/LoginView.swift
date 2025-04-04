//
//  LoginView.swift
//  app
//
//  Created by Onni Nevala on 4.4.2025.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = "";
    @State private var password: String = "";
    @State private var buttonText: String = "Login"
    @State private var passwordShown: Bool = false;
    
    var body: some View {
        NavigationStack {
            VStack(alignment:.leading) {
                Text("Sign into your frii.site account.")
                
                Spacer().frame(height: 50)
                
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
                            VStack {
                                Toggle(isOn: $passwordShown, label: {
                                    Image(systemName: (passwordShown ? "eye.fill" : "eye.slash.fill"))
                                })
                            }.frame(maxWidth: 50)
                            
                        }
                    }.background(Color(.systemGray6))
                    
                    
                }
                
                    
                Spacer()
                Button() {
                    print("Login")
                    buttonText = "Loading..."
                    APIService().createSession(username: username, password: password, callback: {success,statusCode,sessionId in
                        if success {
                            session = sessionId!
                            Alert(
                                title:Text("Success!"),
                                message: Text("Succesfully signed into your frii.site account"),
                                dismissButton: .default(Text("Ok"))
                            )
                        } else {
                            print(statusCode!)
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
