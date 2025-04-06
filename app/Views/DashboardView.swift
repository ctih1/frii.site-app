//
//  DashboardView.swift
//  app
//
//  Created by Onni Nevala on 4.4.2025.
//

import SwiftUI

enum RecordTypes: String, CaseIterable, Identifiable {
    case a, cname, ns, txt
    var id: Self { self }
}

struct DashboardView: View {
    @State dynamic var domains: [String:APIService.Domain] = [:];
    @State var showAlert = false
    @State var alertTitle: String = ""
    @State var alertDescription: String = ""
    @State var loaded: Bool = false
    @State var loadingDescription: String = "Loading domains..."
    @State private var path = NavigationPath()
    @State var needsRelogin: Bool = false
    
    func getDomains() {
        APIService().getUserDomains(callback: {success,statusCode,domainData in
            loaded = true
            if success {
                domains = domainData
            } else {
                if statusCode == 460 {
                    session = ""
                    alertTitle = "Login failed"
                    alertDescription = "Your session has expired. Please log back in."
                    showAlert = true
                    needsRelogin = true
                    return
                }
                alertTitle = "Getting domains failed"
                alertDescription = "Retrieving domains failed with error code \(statusCode)"
                showAlert = true
            }
            
        })
    }
    
    
    func alertCreator() -> Alert {
        Alert(
            title: Text(alertTitle),
            message: Text(alertDescription),
            dismissButton: .default(Text("Okay"))
        )
    }
    
    var body: some View {
        if needsRelogin {
            LoginView()
        } else {
            ScrollView {
                VStack {
                    if !loaded {
                        Text(loadingDescription)
                        ProgressView().progressViewStyle(CircularProgressViewStyle())
                    }
                    ForEach(domains.map {(k,v) in (k,v)}, id: \.0) {key,val in
                        
                        GroupBox {
                            VStack {
                                HStack {
                                    Image(systemName: "globe")
                                    Text(key + ".frii.site").font(.headline)
                                    Spacer()
                                }
                                
                                HStack {
                                    TextField(
                                        "Content",
                                        text: Binding(
                                            get: { val.ip },
                                            set: { domains[key]!.ip = $0 }
                                        )
                                    ).textFieldStyle(.roundedBorder)
                                        .autocorrectionDisabled(true)
                                        .autocapitalization(.none)
                                    Spacer()
                                    Picker(
                                        "Type",
                                        selection: Binding(
                                            get: { val.type },
                                            set: { domains[key]!.type = $0 }
                                        )
                                    ) {
                                        Text("A").tag("A")
                                        Text("CNAME").tag("CNAME")
                                        Text("NS").tag("NS")
                                        Text("TXT").tag("TXT")
                                    }.pickerStyle(.menu)
                                        .buttonStyle(.bordered)
                                }
                                
                                HStack {
                                    Button(role: .destructive) {
                                        APIService().deleteDomain(domain: key) { success, statusCode in
                                            
                                            if success {
                                                alertTitle = "Success!"
                                                alertDescription = "Succesfully deleted domain"
                                                showAlert = true
                                                
                                                domains = domains.filter({ $0.key != key})
                                            } else {
                                                alertTitle = "Failed to delete domain!"
                                                alertDescription = "Deleting domain resulted in error code \(statusCode)"
                                                showAlert = true
                                            }
                                        }
                                        
                                    } label: {
                                        Image(systemName: "bin.xmark")
                                        Text("Delete")
                                    }.buttonStyle(.borderedProminent)
                                    
                                    Spacer()
                                    
                                    Button() {
                                        APIService().modifyDomain(
                                            domain: key,
                                            value: val.ip,
                                            type: val.type
                                        ) { success, statusCode in
                                            if success {
                                                alertTitle = "Success!"
                                                alertDescription = "Succesfully modified domain"
                                                showAlert = true
                                            } else {
                                                alertTitle = "Failed to modify domain!"
                                                alertDescription = "Modifying domain resulted in error code \(statusCode)"
                                                showAlert = true
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "doc")
                                        Text("Save")
                                    }.buttonStyle(.borderedProminent)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Dashboard")
            .alert(isPresented: self.$showAlert, content: { self.alertCreator() })
            .onAppear { getDomains() }
            
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
