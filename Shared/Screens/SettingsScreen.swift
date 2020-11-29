//
//  SettingsScreen.swift
//  FeelBetter (iOS)
//
//  Created by Jason on 10/17/20.
//

import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject var store: ClericStore
    @State var backgroundStyle: String = ""
    @State var addChild: String = ""
    @State var editProfile = ""
    @State var notificationSettings: String = ""
    @State var agreedToTerms: Bool = true
    @State var showConnectedDevices: Bool = false
    @State var addDevice: Bool = false
    @State var allowNotifications: Bool = false
    @State var allowPhotoAccess: Bool = false
    @State var allowContacts: Bool = false
    @State private var selectedTheme = 0
    var themes = ["Light","Dark"]
    
    
    var body: some View {
        VStack {
            Text("Settings")
                .bold()
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .padding()
                .padding(.top, 20)
            Form {
                Toggle("Terms & Conditions", isOn: $agreedToTerms)
                Section(header:Text("Usage")) {
                    Toggle("Allow Notifications", isOn: $allowNotifications).disabled(!agreedToTerms)
                    
                    Toggle("Allow Photo Access", isOn: $allowPhotoAccess).disabled(!agreedToTerms)
                    Toggle("Allow Contact Access", isOn: $allowContacts).disabled(!agreedToTerms)
                }
                Section(header: Text("Connected Devices")) {
                    HStack {
                        Text("Add Device")
                        Spacer()
                        Button(action: {self.addDevice.toggle()}, label: {
                            Image(systemName: "plus")
                        })
                        .alert(isPresented: $addDevice, content: {
                            Alert(title: Text("Bluetooth Required"), message: Text("Please ensure bluetooth is turned on in Settings and try again."), dismissButton: .default(Text("OK")))
                        })
                        
                    }.disabled(!agreedToTerms)
                    HStack {
                        Text("Smart Devices")
                        Spacer()
                        Button(action: {showConnectedDevices.toggle()}, label: {
                            if !showConnectedDevices {
                                Image(systemName: "chevron.right")
                            } else {
                                Image(systemName: "chevron.down")
                            }
                        })
                    }.disabled(!agreedToTerms)
                    if showConnectedDevices {
                        VStack {
                            HStack {
                                Text("Temp Pal: ")
                                Spacer()
                                Text("Disconnected").foregroundColor(Color.red)
                            }.padding(.bottom)
                            HStack {
                                Text("Withings Scale: ")
                                Spacer()
                                Text("Connected").foregroundColor(Color.blue)
                                Image(systemName: "battery.25")
                            }
                        }
                        
                    }
                }
                
                Section(header: Text("Appearence")) {
                    Picker("", selection: $selectedTheme) {
                        ForEach(0 ..< themes.count) {
                            Text(self.themes[$0])

                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
            }
        }.background(Color(UIColor.systemGray6))
        .ignoresSafeArea()
        .if(selectedTheme == 1) { $0.environment(\.colorScheme, .dark)}
        
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen().environmentObject(ClericStore.shared)
    }
}
