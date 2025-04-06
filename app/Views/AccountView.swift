//
//  AccountView.swift
//  app
//
//  Created by Onni Nevala on 6.4.2025.
//

import SwiftUI

struct AccountView: View {
    @State var needsRelogin: Bool = false
    @State var showAlert = false
    @State var alertTitle: String = ""
    @State var alertDescription: String = ""
    
    func alertCreator() -> Alert {
        Alert(
            title: Text(alertTitle),
            message: Text(alertDescription),
            dismissButton: .default(Text("Okay"))
        )
    }
    var body: some View {
        if needsRelogin || session.isEmpty  {
            LoginView()
        } else {
            VStack(alignment: .leading) {
                List {
                    Text("Currently logged in")
                        .font(.title)
                        .fontWeight(.bold)
                    Button("Log out", role: .destructive){
                        APIService().logout { success, statusCode in
                            if success {
                                session = ""
                                needsRelogin = true
                                return
                            } else {
                                alertTitle = "Logging out failed"
                                alertDescription = "Logging out failed with status code \(statusCode)"
                                showAlert = true
                            }
                        }
                    }.buttonStyle(.borderedProminent)
                }

            }.navigationTitle("Account settings")
                .alert(isPresented: self.$showAlert, content: { self.alertCreator() })
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
