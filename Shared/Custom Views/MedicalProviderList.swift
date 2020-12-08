//
//  MedicalProviderList.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 12/7/20.
//

import SwiftUI
import CareKitStore

struct MedicalProviderList: View {
    @EnvironmentObject var store: ClericStore
    @Binding var showMedicalProviderList: Bool
    @State var availableProviders: [OCKContact]
    @Binding var primaryExists: Bool
    @Binding var makeSecondary: Bool
    @State var showAlert: Bool = false
    @Binding var makePrimary: Bool
    @State var selectedProvider: OCKContact
    @State var showCreateNewProvider: Bool = false
    @State var check: String = "nothing yet"
    @State var redraw:Bool = false
    
    var body: some View {
        VStack (spacing: 0) {
            VStack (spacing: 0) {
                Text("Available Providers").font(.title)
                VStack {
                    Picker(selection: self.$selectedProvider, label: Text("Available Providers")) {
                        ForEach (availableProviders, id:\.self) {provider in
                            let providerDetails = store.fetchMedicalProviderDetails(provider: provider)
                            HStack {
                                Text("\(providerDetails?[0] ?? "Unknown")")
                            }
                        }
                    }
                }
                Button(action: {
                    self.makePrimary.toggle()
                    
                }, label: {
                    HStack {
                        Spacer()
                        Text("Make Primary Provider")
                        if makePrimary {
                            Image(systemName: "checkmark.circle.fill")
                                .padding(.trailing)
                        } else {
                            Image(systemName: "circle")
                                .padding(.trailing)
                        }
                    }
                }).buttonStyle(PlainButtonStyle())
                Button(action: {
                    self.showCreateNewProvider.toggle()
                }, label: {
                    HStack {
                        Spacer()
                        Text("Create New Provider")
                        Image(systemName: "plus.circle")
                    }.padding()
                }).buttonStyle(PlainButtonStyle())
            }.frame(width: .infinity, height: .infinity, alignment: .center)
            .background(Color.white)
            .cornerRadius(10)
            .padding(.leading)
            .padding(.trailing)
            .shadow(radius: 5)
            
            HStack {
                Spacer()
                Button(action: {
                    if primaryExists && makePrimary {
                        self.showAlert.toggle()
                    }
                    else if !primaryExists && makePrimary {
                        self.store.tempPhysician = self.selectedProvider
                        self.makeSecondary = false
                        self.showMedicalProviderList = false
                    }
                    else {
                        self.store.tempPhysician = self.selectedProvider
                        self.makeSecondary = true
                        self.showMedicalProviderList = false
                    }
                }, label: {
                    Text("Confirm").font(.title2)
                }).buttonStyle(CarePlanStyle())
                Spacer()
                Button(action: {
                   
                    self.showMedicalProviderList = false
                    
                }, label: {
                    Text("Cancel").font(.title2)
                }).buttonStyle(CancelStyle())
                Spacer()
            }.padding()
        }.onAppear(perform: {
            if self.availableProviders.isEmpty {
                self.availableProviders = store.fetchAllMedicalProviders()
            }
            self.selectedProvider = availableProviders[0]
        })
        .sheet(isPresented: $showCreateNewProvider, onDismiss: {
            self.availableProviders = store.familyDetails["PHYSICIAN_LIST"] as! [OCKContact]
            self.selectedProvider = self.availableProviders[0]
            
        }, content: {
            CreateNewProvider(availableProviders: availableProviders)
        })
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Primary Previously Assigned"), message: Text("Each child may only be assigned one primary physician. Assigning this physician as a primary will replace the previously assigned physician."), primaryButton: Alert.Button.destructive(Text("Replace"), action: {
                    self.store.tempPhysician = self.selectedProvider
                    self.makeSecondary = false
                    self.showMedicalProviderList = false
            }), secondaryButton: .default(Text("Cancel")))
        })
        
    }
}

struct ProviderPicker: View {
    @EnvironmentObject var store: ClericStore
    @Binding var availableProviders: [OCKContact]
    @Binding var selectedProvider: OCKContact
    var body: some View {
        
        VStack {
            Picker(selection: self.$selectedProvider, label: Text("Available Providers")) {
                ForEach (availableProviders, id:\.self) {provider in
                    let providerDetails = store.fetchMedicalProviderDetails(provider: provider)
                    HStack {
                        Text("\(providerDetails?[0] ?? "Unknown")")
                    }
                }
            }
        }
        
    }
}

#if DEBUG
struct MedicalProviderList_Previews: PreviewProvider {
    @State static var store = ClericStore.shared
    @State static var myProviders = store.familyDetails["PHYSICIAN_LIST"] as! Array<OCKContact>
    static var previews: some View {
        MedicalProviderList(showMedicalProviderList: .constant(true), availableProviders: myProviders, primaryExists: .constant(false), makeSecondary: .constant(false), makePrimary: .constant(false), selectedProvider: store.defaultContact).environmentObject(store)
    }
}
#endif
