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
    
    private func alertCreator() -> Alert {
        Alert(
            title: Text(alertTitle),
            message: Text(alertDescription),
            dismissButton: .default(Text("Okay"))
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: LoginView()) {
                    Text("Sign in")
                }.buttonStyle(.borderedProminent)
                
                NavigationLink(destination: DashboardView()) {
                    Text("Dashboard")
                }.buttonStyle(.borderedProminent)
                    
            }.alert(isPresented: self.$showAlert, content: { self.alertCreator() })
            .padding()
            .navigationTitle("frii.site")
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
