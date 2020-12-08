//
//  CreateNewProvider.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 12/7/20.
//

import SwiftUI
import CareKitStore
import Contacts

struct CreateNewProvider: View {
    @EnvironmentObject var store: ClericStore
    @State var availableProviders: [OCKContact]
    @Environment(\.presentationMode) var presentationMode
    @State var showStatePicker: Bool = false
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var title: String = ""
    @State var street1: String = ""
    @State var street2: String = ""
    @State var city: String = ""
    @State var state: String = ""
    @State var postalCode: String = ""
    @State var phone: String = ""
    @State var isContact: Bool = false
    @State var redraw: Bool = false
    
    let states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "C", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Required Details").font(.title2)) {
                        HStack {
                            Text("First Name: ")
                            TextField("", text: $firstName).textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Text("Last Name: ")
                        TextField("", text: $lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Text("Specialty: ")
                            TextField("Example \"Pediatrician\"", text: $title)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    Section(header: Text("Address").font(.title2)) {
                        HStack {
                            Text("Street: ")
                            TextField("", text: $street1)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Text("Street: ")
                            TextField("Optional", text: $street2)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Text("City: ")
                            TextField("", text: $city)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        Picker(selection: $state, label: Text("State: "), content: {
                            ForEach (states, id:\.self) {
                                choice in
                                HStack {
                                    Spacer()
                                    Text(choice)
                                    Spacer()
                                }
                            }
                        })
                        HStack {
                            Text("Postal Code: ")
                            TextField("", text: $postalCode)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    Section(header: Text("Contact").font(.title2)) {
                        HStack {
                            Text("Phone: ")
                            TextField("", text: $phone)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                }
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        if ValidContactCheck() {
                            self.store.tempPhysician = BuildProvider()
                            self.store.UpdatePhysicianList()
                            self.availableProviders = self.store.familyDetails["PHYSICIAN_LIST"] as! [OCKContact]
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }, label: {
                        Text("Confirm").font(.title3)
                    }).buttonStyle(CarePlanStyleCompact())
                    Spacer()
                    Button(action: {self.presentationMode.wrappedValue.dismiss()}, label: {
                        Text("Cancel").font(.title3)
                    }).buttonStyle(CancelStyle())
                    Spacer()
                }
            }.navigationTitle(Text("New Medical Provider").font(.title))
        }
    }
    func ValidContactCheck() -> Bool {
        if !self.firstName.isEmpty && !self.lastName.isEmpty && !self.title.isEmpty {
            self.isContact = true
            return true
        }
        return false
    }
    
    func ValidAddressCheck() -> Bool {
        if !self.street1.isEmpty && !self.city.isEmpty && !self.state.isEmpty && !self.postalCode.isEmpty {
            return true
        }
        return false
    }
    
    func BuildProvider() -> OCKContact? {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .long
        let id = formatter.string(from: today)
        if ValidContactCheck() {
            var newProvider = OCKContact(id: id, givenName: self.firstName, familyName: self.lastName, carePlanUUID: nil)
            newProvider.category = .careProvider
            newProvider.title = self.title
            if ValidAddressCheck() {
                let address = OCKPostalAddress()
                address.street = self.street1
                if !self.street2.isEmpty {
                    address.subLocality = self.street2
                }
                address.city = self.city
                address.state = self.state
                address.postalCode = self.postalCode
                newProvider.address = address
            }
            if !self.phone.isEmpty {
                newProvider.phoneNumbers = [OCKLabeledValue(label: CNLabelWork, value: self.phone)]
            }
            
            return newProvider
        }
        
        return nil
    }
}

struct CreateNewProvider_Previews: PreviewProvider {
    @State static var myCurrent = ClericStore.shared.familyDetails["PHYSICIAN_LIST"] as! Array<OCKContact>
    static var previews: some View {
        CreateNewProvider(availableProviders: myCurrent).environmentObject(ClericStore.shared)
    }
}
