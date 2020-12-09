//
//  ZonedZiagnosis.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 11/23/20.
//

import SwiftUI
import CareKitStore

struct ZonedZiagnosis: View {
    @EnvironmentObject var store: ClericStore
    @Environment(\.presentationMode) var presentationMode
    
    @State var zone: BodyZone
    @State var symptomSelected: Bool = false
    @State var selectionIs: String = "temp"
    @State var showCarePlan: Bool = false
    @State var preferGuideBook: Bool = false
    @State var preferCarePlan: Bool = false
    
    var child: OCKPatient
    
    let imageSymptoms: [BodyZone : [String]] = [
        .all: [""],
        .head: ["BrokenBone", "SoreThroat", "Headache", "RunnyNose", "EarInfection", "PinkEye"],
        .torso: ["BrokenBone", "Diarrhea", "Constipation", "GreenFace", "Wheezing", "StomachAche2"],
        .arm: ["BrokenBone", "Rash", "Pain", "Cramps", "Infection", "Injury"],
        .leg: ["BrokenBone", "AthletesFoot", "Rash", "Cramps", "Infection", "Injury"],
        .whole: ["Aches", "Fever", "Rash", "Fatigue", "Swelling", "Chills"],
        .illness: ["Covid", "Flu", "Strep", "Cold", "Rotovirus", "HandFootMouth"]
    ]
    
    let symptomResourceTitle: [String: String] = [
        
        "StomachAche2" : "Stomach Ache",
        "BrokenBone" : "Broken Bones",
        "SoreThroat" : "Sore Throat",
        "Headache" : "Headache",
        "RunnyNose" : "Runny Nose",
        "EarInfection" : "Ear Pain",
        "PinkEye" : "Pinkeye",
        "Diarrhea" : "Diarrhea",
        "Constipation" : "Constipation",
        "GreenFace" : "Vomiting",
        "Wheezing" : "Wheezing",
        "Rash" : "Rash",
        "Pain" : "Pain", //Pain goes nowhere
        "Cramps" : "Cramp",
        "Infection" : "Skin Infection",
        "Injury" : "Injury", //Injury
        "AthletesFoot" : "Athlete’s Foot",
        "Aches" : "Body Ache", //Need to add body aches resource
        "Fever" : "Fever",
        "Fatigue" : "Fatigue",
        "Swelling" : "Swelling",
        "Chills" : "Chills",
        "Covid" : "Coronavirus",
        "Flu" : "The Flu",
        "Strep" : "Strep Throat",
        "Cold" : "Cold",
        "Rotovirus" : "Rotavirus",
        "HandFootMouth" : "HFM Disease"
    ]
    
    var body: some View {
        let currentOptions = imageSymptoms[zone]
        VStack {
            Spacer()
            VStack (spacing: 5){
                Text("What's wrong with \(child.name.givenName!)?")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .frame(width: .infinity, height: 60, alignment: .center)
                    .padding()
                Text(selectionIs)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .frame(width: .infinity, height: 60, alignment: .center)
                    .if(!symptomSelected) { $0.hidden() }
            }.frame(width: .infinity, height: 120, alignment: .center)
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        MultiActionDiseaseButton(symptomSelected: $symptomSelected, selectionIs: $selectionIs, image: currentOptions![0], resourceName: symptomResourceTitle[currentOptions![0]]!).environmentObject(store)
                        Spacer()
                        MultiActionDiseaseButton(symptomSelected: $symptomSelected, selectionIs: $selectionIs, image: currentOptions![1], resourceName: symptomResourceTitle[currentOptions![1]]!).environmentObject(store)
                        Spacer()
                    }.padding(.top, 10)
                    HStack {
                        Spacer()
                        MultiActionDiseaseButton(symptomSelected: $symptomSelected, selectionIs: $selectionIs, image: currentOptions![2], resourceName: symptomResourceTitle[currentOptions![2]]!).environmentObject(store)
                        Spacer()
                        MultiActionDiseaseButton(symptomSelected: $symptomSelected, selectionIs: $selectionIs, image: currentOptions![3], resourceName: symptomResourceTitle[currentOptions![3]]!).environmentObject(store)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        MultiActionDiseaseButton(symptomSelected: $symptomSelected, selectionIs: $selectionIs, image: currentOptions![4], resourceName: symptomResourceTitle[currentOptions![4]]!).environmentObject(store)
                        Spacer()
                        MultiActionDiseaseButton(symptomSelected: $symptomSelected, selectionIs: $selectionIs, image: currentOptions![5], resourceName: symptomResourceTitle[currentOptions![5]]!).environmentObject(store)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {self.preferGuideBook = true}, label: {
                            VStack {
                                ZStack {
                                    Image("Illness")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .shadow(radius: 5)
                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                                        .frame(width: 130, height: 130, alignment: .center)
                                    Image(systemName: "info.circle")
                                        .offset(x: 50, y: 50)
                                }
                                .frame(width: 130, height: 130, alignment: .center)
                                Text("All Resources")
                                    .font(.title3)
                            }
                        }).buttonStyle(PlainButtonStyle())
                        Spacer()
                    }
                }
            }
            Spacer()
            HStack {
                Spacer()
                
                    Button(action: {
                        self.preferCarePlan = true
                        store.selectedPatient = child
                        store.clericStore.populateFeverCarePlan(child)
                        self.showCarePlan = true
                    }, label: {
                        Text("Start A Care Plan")
                            .bold()
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    }).if(!symptomSelected) { $0.hidden() }
                    .buttonStyle(CarePlanStyle())//.hidden()
                Spacer()
                Button(action: {self.presentationMode.wrappedValue.dismiss()}, label: {
                    Text("Cancel")
                        .bold()
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                })
                .buttonStyle(CancelStyle())
                Spacer()
            }.sheet(isPresented: $preferGuideBook, onDismiss: {self.preferGuideBook = false}, content: {
                ResourceList()
            })
            .if(preferCarePlan) {
                $0.sheet(isPresented: $showCarePlan, onDismiss: {self.preferCarePlan = false}, content: {
                    FeverViewWrapper().environmentObject(store)
                })
            }
            
        }
    }
}

struct MultiActionDiseaseButton: View {
    @EnvironmentObject var store: ClericStore
    @Binding var symptomSelected: Bool
    @Binding var selectionIs: String
    @State var showResource: Bool = false
    @State var resourceToShowDetail: SymptomResources?
    var image: String
    var resourceName: String
    
    var body: some View {
        VStack {
            ZStack {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .frame(width: 130, height: 130, alignment: .center)
                Image(systemName: "info.circle")
                    .offset(x: 50, y: 50)
            }
            .frame(width: 130, height: 130, alignment: .center)
            Text("\(resourceName)")
                .font(.title3)
            //Next line is super hacky to work around SwifUI bug not reading an existing value for resourceToShowDetail. May be due to nothing calling the variable so it still reads the original draw state.
            Text("\(resourceToShowDetail?.title ?? "Stil nil")").frame(width: 1, height: 1, alignment: .center).hidden()
        }.onTapGesture(count: 1, perform: {
            if symptomSelected && (resourceName != selectionIs) {
                self.selectionIs = resourceName
            }
            else if !symptomSelected {
                self.symptomSelected = true
                self.selectionIs = resourceName
            }
            else if symptomSelected && (resourceName == selectionIs){
                self.selectionIs = "temp"
                self.symptomSelected = false
            }
        })
        .onLongPressGesture {
            //self.resourceToShowDetail = getResourceValue(resourceTitle: resourceName)
            if resourceToShowDetail != nil {
                self.showResource = true
            }
        }
        .sheet(isPresented: $showResource, content: {
            if resourceToShowDetail != nil {
                ResourcePage(details: resourceToShowDetail!).environmentObject(store)
            } else {
                Text("No additional details.")
            }
        })
        .onAppear(perform: {
            self.resourceToShowDetail = getResourceValue(resourceTitle: resourceName)
        })
        .if(resourceName == selectionIs) { $0.shadow(color: Color.green, radius: 20)}
    }
    
    func getResourceValue(resourceTitle: String) -> SymptomResources? {
        let symptoms = store.resources.symptomList
        if let index = symptoms.firstIndex(where: { $0.title == resourceTitle}) {
            return symptoms[index]
        }
        return nil
    }
    
}

struct ZonedZiagnosis_Previews: PreviewProvider {
    static var myChild = (ClericStore.shared.familyDetails["CHILDREN"]! as! Array<OCKPatient>)[0]
    static var previews: some View {
        ZonedZiagnosis(zone: .whole, child: myChild).environmentObject(ClericStore.shared)
    }
}
