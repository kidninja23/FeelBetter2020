//
//  CreatePatientView.swift
//  FeelBetter
//
//  Created by Jason on 10/9/20.
//

import SwiftUI
import CareKit
import CareKitUI
import CareKitStore

struct CreatePatientView: View {
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var birthDate: Date = Date()
    @State var weight: String = ""
    @State var sampleText: String = "Sample"
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Form {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    DatePicker("Birth Date", selection: $birthDate, displayedComponents: .date)
                    TextField("Weight", text: $weight)
                        .keyboardType(.numberPad)
                    if self.validProfile() {
                        Button(action: {createProfile(storeManager: ClericStore.shared.storeManager, firstName: firstName, lastName: lastName, birthDate: birthDate, weight: weight)}, label: {
                            Text("Add Profile")
                        })
                    }

                }
                Spacer()
                
            }.navigationTitle(Text("Child Profile"))
        }
    }
    
    private func validProfile() -> Bool {
        let current = Date()
        if !firstName.isEmpty && !lastName.isEmpty && !weight.isEmpty && birthDate != current {
                return true
            }
            return false
        }
    
    private func createProfile(storeManager: OCKSynchronizedStoreManager, firstName: String, lastName: String, birthDate: Date, weight: String) {
        let store = ClericStore.shared
        let id = "\(firstName)-\(lastName)"
        var patient = OCKPatient(id: id, givenName: firstName, familyName: lastName)
        patient.birthday = birthDate
        if patient.userInfo == nil {
            patient.userInfo = Dictionary()
        }
        patient.userInfo!["_WEIGHT"] = weight
        store.memberIDs.append(id)
        storeManager.store.addAnyPatient(patient, callbackQueue: .main, completion: { result in
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
            case let .success(patient):
                let truePatient = patient as! OCKPatient
                ClericStore.shared.childMembers.append(truePatient)
            }
        })
    }
}


struct CreatePatientView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePatientView()
    }
}
