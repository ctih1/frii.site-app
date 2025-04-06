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
    @State private var signedIn: Bool = !session.isEmpty
    
    private func alertCreator() -> Alert {
        Alert(
            title: Text(alertTitle),
            message: Text(alertDescription),
            dismissButton: .default(Text("Okay"))
        )
    }
    
    var body: some View {
        if signedIn {
            DashboardView()
        } else {
            DashboardView()
        }
        Button("Dashboard") {
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
