//
//  InsuranceDetails.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 11/20/20.
//

import SwiftUI

struct InsuranceDetails: View {
    @EnvironmentObject var store: ClericStore
    @Environment(\.presentationMode) var presentationMode
    
    var insurance: InsuranceProvider
    @State var saveNeeded: Bool = false
    
    @State var providerName: String = "Not Specified"
    @State var planTitle: String = "Not Specified"
    @State var healthPlan: String = "Not Specified"
    @State var memberID: String = "Not Specified"
    @State var groupNumber: String = "Not Specified"
    @State var providerContact: String = "Not Specified"
    @State var memberContact: String = "Not Specified"
    @State var claimsAddress: String = "Not Specified"
    @State var dependents: [String] = [String]()
    @State var insuranceType: String = "Not Specified"
    @State var rxNumber: String = "Not Specified"
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("Insurance Provider Details")
                    .font(.largeTitle)
                    .padding(.bottom, 30)
                Spacer()
                Text("Review and edit any of the fields below.")
                ScrollView {
                    EditableLabeledData(label: "Provider:", saveNeeded: $saveNeeded, detail: $providerName).padding(.top, 10)
                    EditableLabeledData(label: "Plan Name:", saveNeeded: $saveNeeded, detail: $planTitle)
                    EditableLabeledData(label: "Health Plan:", saveNeeded: $saveNeeded, detail: $healthPlan)
                    EditableLabeledData(label: "Member ID:", saveNeeded: $saveNeeded, detail: $memberID)
                    EditableLabeledData(label: "Group Number:", saveNeeded: $saveNeeded, detail: $groupNumber)
                    EditableLabeledData(label: "Provider Contact:", saveNeeded: $saveNeeded, detail: $providerContact)
                    EditableLabeledData(label: "Member Contact:", saveNeeded: $saveNeeded, detail: $memberContact)
                    EditableLabeledData(label: "Claims:", saveNeeded: $saveNeeded, detail: $claimsAddress)
                    EditableLabeledData(label: "Insurance:", saveNeeded: $saveNeeded, detail: $insuranceType)
                    EditableLabeledData(label: "RX Number:", saveNeeded: $saveNeeded, detail: $rxNumber)
                }
                .frame(width: .infinity, height: geo.size.height * 0.8, alignment: .center)
                Spacer()
                if saveNeeded {
                    HStack {
                        Button(action: {
                            UpdateInsuranceProvider()
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Save").font(.title2)
                        }).buttonStyle(CarePlanStyleCompact())
                        .padding(.leading)
                        Spacer()
                        Button(action: {self.presentationMode.wrappedValue.dismiss()}, label: {
                            Text("Cancel")
                                .font(.title2)
                        }).buttonStyle(CancelStyle())
                        .padding(.trailing)
                    }.padding(.trailing)
                    .padding(.bottom)
                }
                
            }
            .onAppear(perform: {
                providerName = insurance.ProviderName
                healthPlan = insurance.HealthPlan
                memberID = insurance.MemberID ?? ""
                groupNumber = insurance.GroupNumber ?? ""
                providerContact = insurance.ProviderContact
                memberContact = insurance.MemberContact
                claimsAddress = insurance.ClaimsAddress
                dependents = insurance.Dependents ?? [String]()
                insuranceType = insurance.InsuranceType
                planTitle = insurance.PlanTitle ?? ""
                rxNumber = insurance.RXnumber
            })
        }
    }
    //Current version does not handle secondary insurance types
    func UpdateInsuranceProvider() {
        let provider = self.insurance
        provider.ProviderName = self.providerName
        provider.HealthPlan = self.healthPlan
        provider.MemberID = self.memberID
        provider.GroupNumber = self.groupNumber
        provider.ProviderContact = self.providerContact
        provider.MemberContact = self.memberContact
        provider.ClaimsAddress = self.claimsAddress
        provider.Dependents = self.dependents
        provider.InsuranceType = self.insuranceType
        provider.PlanTitle = self.planTitle
        provider.RXnumber = self.rxNumber
        store.insuranceProviderDetails["MEDICAL"] = provider
    }
}

struct EditableLabeledData: View {
    var label: String
    @Binding var saveNeeded: Bool
    @Binding var detail: String
    @State var edit: Bool = false
    @State var originalValue: String = ""
    
    var body: some View {
        Group {
            if !edit {
                HStack (alignment: .top ){
                    Text(label)
                        .font(.title3)
                    Spacer()
                    Text(detail)
                        .font(.title3)
                    Spacer()
                    Button(action: {
                        self.originalValue = detail
                        self.edit.toggle()
                    }, label: {
                        Image(systemName: "pencil")
                    })
                }.padding(21)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            } else {
                HStack{
                    Text(label).font(.title3)
                    Spacer()
                    TextField("", text: $detail).textFieldStyle(RoundedBorderTextFieldStyle())
                    Spacer()
                    Button(action: {
                        if self.originalValue != self.detail {
                            self.saveNeeded = true
                        }
                        self.edit.toggle()
                        
                    }, label: {
                        Image(systemName: "checkmark.circle")
                    })
                    
                }.padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            }
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
        .padding(.bottom)
    }
}

#if DEBUG
struct InsuranceDetails_Previews: PreviewProvider {
    static var myInsurance = InsuranceProvider(id: UUID(), ProviderName: "United Health Care", HealthPlan: "911-87726-09", PlanTitle: "Mega Boss", MemberID: "859173444", GroupNumber: "700408", ProviderContact: "877-842-3210", MemberContact: "866-348-1286", ClaimsAddress: "PO Box 30555\nSalt Lake City, UT 84130", AccountHolder: "Jackson Bice", Dependents: ["Amy Bice", "Julie Bice", "Allister Bice"], InsuranceType: "Medical")
    static var previews: some View {
        InsuranceDetails(insurance: myInsurance).environmentObject(ClericStore.shared)
    }
}
#endif


