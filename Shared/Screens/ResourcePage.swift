//
//  ResourcePage.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 11/15/20.
//

import SwiftUI

struct ResourcePage: View {
    @EnvironmentObject var store: ClericStore
    var details: SymptomResources
    
    
    var body: some View {
        let symptomName = self.details.title
        let description = self.details.description
        let causes = self.details.causes
        let source = self.details.source
        let symptoms = self.details.symptoms
        let medicalNeed = self.details.medicalNeed
        let relief = self.details.relief
        let showDescription = self.details.showDescription
        let showCauses = self.details.showCauses
        let showSource = self.details.showSource
        let showSymptoms = self.details.showSymptoms
        let showMedicalNeed = self.details.showMedicalNeed
        let showRelief = self.details.showRelief
        VStack {
            Text(symptomName)
                .font(.title)
                .bold()
                .padding()
            ScrollView {
                VStack (alignment: .leading) {
                    if showDescription {
                        Text("Description")
                            .font(.title)
                            .padding(.leading, 8)
                        Text(description)
                            .font(.title2)
                            .padding(.top)
                            .padding(.bottom)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                    }
                    if showSymptoms {
                        ResourceDataView(section: "Symptom", symptom: symptomName, subHeader: "is associated with the following symptoms:", info: symptoms)
                    }
                    
                    if showCauses {
                        ResourceDataView(section: "Causes", symptom: symptomName, subHeader: "may be caused by the following:", info: causes)
                    }
                    
                    if showRelief {
                        ResourceDataView(section: "Treatment Options", symptom: symptomName, subHeader: "is commonly treated with the following:", info: relief)
                    }
                    
                    if showMedicalNeed {
                        ResourceDataView(section: "Medical Attention", symptom: symptomName, subHeader: "may require assistance from a medical professional in following circumstances, please contact your medical provider for additional details:", info: medicalNeed)
                    }
                    if showSource {
                        ResourceDataView(section: "Resources", symptom: symptomName, subHeader: "information has been gathered from the following public resources:", info: source, link: true)
                    }
                }
            }// end scrollview
            HStack {
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("New Event")
                        .bold()
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                }).buttonStyle(CarePlanStyleCompact())
                .padding(.trailing).hidden()
            }
        }
    }
}

struct ResourceDataView: View {
    var section: String
    var symptom: String
    var subHeader: String
    var info: [String]
    var link: Bool = false
    
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(section)
                .font(.title)
                .padding(.leading, 8)
            Text("\(symptom) \(subHeader)")
                .font(.title2)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading, 10)
                .padding(.trailing, 10)
                .padding(.top)
                .padding(.bottom, 2)
            
            ForEach(info, id:\.self) { item in
                if link {
                    Link("\u{2022} \(item)", destination: URL(string: item)!)
                        .padding(.leading, 30)
                        .padding(.bottom, 8)
                }
                else{
                Text("\u{2022} \(item)")
                    .font(.body)
                    .padding(.leading, 30)
                }
            }
        }.padding(.bottom)
    }
}

#if DEBUG
struct ResourcePage_Previews: PreviewProvider {
    static var mySymptom = SymptomResources(bodyZone: .head, title: "Toothache", description: "A toothache is any pain in or around a tooth.", causes: ["Tooth decay", "Abscessed tooth", "Tooth fracture", "A damaged filling", "Repetitive motions such as chewing gum or grinding teeth", "Infected gums"], source: ["https://www.webmd.com/oral-health/guide/toothaches", "https://www.webmd.com/oral-health/home-remedies-toothache"], symptoms: ["Tooth pain that may be sharp, throbbing, or constant", "Swelling of the gms around the tooth", "Fever or headache"], medicalNeed: ["Symptoms lasting longer than 1 or 2 days", "Severe discomfort", "High fever", "Earache or pain upon opening the mouth wide"], relief: ["Saltwater rinse", "Hydrogen peroxide rinse", "Over the counter pain relievers", "Cold compress", "Ice", "Clove oil"], showDescription: true, showCauses: true, showSource: true, showSymptoms: true, showMedicalNeed: true, showRelief: true)
        
    static var previews: some View {
        ResourcePage(details: mySymptom).environmentObject(ClericStore.shared)
    }
}
#endif
