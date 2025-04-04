//
//  ContentView.swift
//  app
//
//  Created by Onni Nevala on 4.4.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: LoginView()) {
                    Text("Sign in")
                }.buttonStyle(.borderedProminent)
                    
            }
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
