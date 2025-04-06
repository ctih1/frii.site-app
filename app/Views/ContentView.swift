//
//  ContentView.swift
//  app
//
//  Created by Onni Nevala on 4.4.2025.
//

import SwiftUI

struct ContentView: View {
    @State public var showAlert = false
    @State public var alertTitle: String = ""
    @State public var alertDescription: String = ""
    @State private var signedIn: Bool = false;
    
    private func alertCreator() -> Alert {
        Alert(
            title: Text(alertTitle),
            message: Text(alertDescription),
            dismissButton: .default(Text("Okay"))
        )
    }
    
    
    
    var body: some View {
        ZStack {
            if signedIn {
                DashboardView()
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut, value: signedIn)
        
        .onAppear {
            withAnimation(.easeIn(duration: 1.0)) {
                signedIn = !session.isEmpty
            }
        }
        
        HStack {
            Spacer()
            NavigationLink(destination: AccountView()) {
                Image(systemName: "person")
                Text("Account")
            }
            Spacer()
        }

        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
