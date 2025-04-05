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
    
    func notificationReminder() -> Alert {
        Alert(
            title: Text(alertTitle),
            message: Text(alertDescription),
            dismissButton: .default(Text("Okay"))
        )
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Button("Retrieve domains") {
                    APIService().getUserDomains(callback: {success,statusCode,domainData in
                        if success {
                            domains = domainData
                        } else {
                            if statusCode == 460 {
                                alertTitle = "Login failed"
                                alertDescription = "Session expired. Please log back in."
                                showAlert = true
                            }
                        }
                        
                    })
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
                                Spacer()
                                Button("Save") {
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
                                }.buttonStyle(.borderedProminent)
                                Button("Delete", role: .destructive) {
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
                                    
                                }.buttonStyle(.borderedProminent)
                            }
                        }
                        
                    }
                }
                
            }
        }.padding().navigationTitle("Dashboard").alert(isPresented: self.$showAlert, content: { self.notificationReminder() })
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
