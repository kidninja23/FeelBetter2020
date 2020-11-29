//
//  AddChildPopup.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 11/14/20.
//

import SwiftUI
import CareKitStore

struct AddChildPopup: View {
    @EnvironmentObject var store: ClericStore
    @Environment(\.presentationMode) var presentationMode
    
    @State var temp: String = ""
    
    ///Intermediate Processing Variable
    @State var heightData: [(String, [String])] = [
        ("Feet", Array(0..<8).map {"\($0)"}),
        ("Inches", Array(0..<13).map {"\($0)"})
    ]
    @State var heightMixed: [String] = [0, 0].map { "\($0)" }
    @State private var selectedGender = 0
    var genders = ["Male", "Female"]

    ///View Variable for dispalying items
    @State private var showingAdditionalOptions: Bool = false
    @State var showAddCondition: Bool = false
    @State var showAddAllergy: Bool = false
    @State var showHeightChooser: Bool = false
    @State var showWeightChooser: Bool = false
    @State var showEditCondition: Bool = false
    @State var showEditAllergy: Bool = false
    @State var confirmConditionDelete: Bool = false
    @State var confirmAllergyDelete: Bool = false
    @State var showSave: Bool = false
    
    ///Variables to pass to additional views
    @State var editCondition: String = ""
    @State var editAllergy: String = ""
    
    
    ///Variable for child creation
    @State var first: String = ""
    @State var middle: String = ""
    @State var otherName: [String] = [String]()
    @State var last: String = ""
    @State var gender: GenderValue = .other
    @State var birthdate: Date = Date()
    @State var weight: Int = 0
    @State var height: Int = 0
    @State var conditions: [String] = [String]()
    @State var allergies: [String] = [String]()
    @State var isActive: Bool = false
    @State var activeCarePlan: Bool = false
    @State var activePlanID: String = ""
    @State var primary: [OCKContact] = [OCKContact]()
    @State var specialist: [String: OCKContact] = [String: OCKContact]()
    @State var profileImage: String = "default_profile"
    @State var history: [String] = [String]()
    @State var upcoming: [AppointmentData] = [AppointmentData]()
    @State var other: [String: String] = [String: String]()
    
    
    
    var body: some View {
        ZStack {
            VStack {
                Text("Add Child")
                    .font(.title)
                
                    
                Form {
                    Section(header: Text("Name" ).font(.title2)) {
                        HStack {
                            Text("First: ")
                            TextField("Required", text: $first)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Text("Middle: ")
                            TextField("Optional", text: $middle)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Text("Last: ")
                            TextField("Required", text: $last)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    Section (header: Text("Birthdate").font(.title2)) {
                        DatePicker("Date:", selection: $birthdate, in: ...Date(), displayedComponents: [.date])
                    }
                    Section (header: Text("Gender").font(.title2)) {
                        Picker("", selection: $selectedGender) {
                            ForEach(0 ..< genders.count) {
                                Text(self.genders[$0])

                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    Section (header: Text("Additional Options").font(.title2)) {
                        Toggle(isOn: $showingAdditionalOptions, label: {
                            Text("Show Additional Options")
                        })
                    }
                        
                    if showingAdditionalOptions {
                        Section (header: Text("Body Measurements").font(.title2)) {
                            HStack {
                            Text("Weight: \(weight) lbs")
                                Spacer()
                                Button(action: {self.showWeightChooser.toggle()}, label: {
                                    if !showWeightChooser {
                                        Image(systemName: "chevron.right").padding(.trailing)
                                    }
                                    else {
                                        Image(systemName: "chevron.down").padding(.trailing)
                                    }
                                })
                            }
                            if showWeightChooser {
                                Picker(selection: $weight, label: Text("Weight")) {
                                    ForEach(0..<200) { value in
                                        Text("\(value) lbs")
                                    }
                                }.pickerStyle(WheelPickerStyle()).frame(height: 200)
                            }
                            HStack {
                                Text("Height: \(heightMixed[0]) feet \(heightMixed[1]) inches")
                                Spacer()
                                Button(action: {self.showHeightChooser.toggle()}, label: {
                                    if !showHeightChooser {
                                        Image(systemName: "chevron.right").padding(.trailing)
                                    }
                                    else {
                                        Image(systemName: "chevron.down").padding(.trailing)
                                    }
                                })
                            }
                            if showHeightChooser {
                                MultiPicker(data: heightData, selection: $heightMixed).frame(height: 200)
                            }
                        }//Section End
                        Section (header: Text("Medical Conditions").font(.title2)) {
                            
                            ForEach(conditions, id:\.self) {condition in
                                if condition != "" {
                                    HStack {
                                        Text(condition).font(.body)
                                        Spacer()
                                        Button(action: {
                                            self.editCondition = condition
                                            self.showEditCondition = true
                                        }, label: {
                                            Image(systemName: "pencil")
                                        })
                                    }
                                }
                            }
                            HStack {
                                Spacer()
                                Button(action: {
                                    self.showAddCondition = true
                                }, label: {
                                    Text("Add Condition").font(.title3)
                                    
                                }).buttonStyle(CarePlanStyleCompact())
                                Spacer()
                            }
                        }
                        
                        Section(header: Text("Allergies").font(.title2)) {
                            ForEach(allergies, id:\.self) {allergy in
                                if allergy != "" {
                                    HStack {
                                        Text(allergy).font(.body)
                                        Spacer()
                                        Button(action: {
                                            self.editAllergy = allergy
                                            self.showEditAllergy = true
                                        }, label: {
                                            Image(systemName: "pencil")
                                        })
                                    }
                                }
                            }
                            HStack {
                                Spacer()
                                Button(action: {
                                    self.showAddAllergy = true
                                }, label: {
                                    Text("Add Allergy").font(.title3)
                                    
                                }).buttonStyle(CarePlanStyleCompact())
                                Spacer()
                            }
                            
                        }
                    
                    }//if additional options end
                    
                }
                if showAddCondition {
                    AddDetailPopup(someField: self.$conditions, showAddDetail: self.$showAddCondition, instruction: "Enter a new medical condtion.", event: "Condition")
                }
                ZStack {
                    if showEditCondition {
                        EditDetailPopup(someField: self.$conditions, someFieldItem: self.$editCondition, showAddDetail: self.$showEditCondition, confirmDelete: self.$confirmConditionDelete, instruction: "Edit this medical condtion.", event: "Condition")
                    }
                    if confirmConditionDelete {
                        ConfirmFieldDelete(confirmDelete: self.$confirmConditionDelete, previousShowing: self.$showEditCondition, someField: self.$conditions, someFieldItem: self.$editCondition, deleteItemType: "condition")
                    }
                }
                if showAddAllergy {
                    AddDetailPopup(someField: self.$allergies, showAddDetail: self.$showAddAllergy, instruction: "Enter an allergy.", event: "Allergy")
                }
                ZStack {
                    if showEditAllergy {
                        EditDetailPopup(someField: self.$allergies, someFieldItem: $editAllergy, showAddDetail: self.$showEditAllergy, confirmDelete: self.$confirmAllergyDelete,  instruction: "Edit this allergy.", event: "Allergy")
                    }
                    if confirmAllergyDelete {
                        ConfirmFieldDelete(confirmDelete: self.$confirmAllergyDelete, previousShowing: self.$showEditAllergy, someField: self.$allergies, someFieldItem: self.$editAllergy, deleteItemType: "allergy")
                    }
                    
                HStack {
                    if (first != "") && (last != "") {
                        Button(action: {
                            computeChildValues()
                            self.store.addChild(first: first, middle: middle, otherName: otherName, last: last, gender: gender, birthdate: birthdate, weight: weight, height: height, conditions: conditions, allergies: allergies, primary: primary, specialist: specialist, profileImage: profileImage, history: history, upcoming: upcoming, other: other)
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Save New Child").font(.title2)
                        })
                        .buttonStyle(CarePlanStyle())
                        .padding(.leading)
                    }
                    Spacer()
                    Button(action: {self.presentationMode.wrappedValue.dismiss()}, label: {
                        Text("Cancel").font(.title2)
                    })
                    .buttonStyle(CancelStyle())
                    .padding(.trailing)
                }
                }//End main VStack
            } //End main ZStack
        }
    }
    
    func computeChildValues() {
        if self.selectedGender == 0 {
            self.gender = .male
        }
        else {
            self.gender = .female
        }
        self.height = (((Int(heightMixed[0]) ?? 0) * 12) + (Int(heightMixed[1]) ?? 0))
        let tempConditions = self.conditions.filter { $0 != "" }
        self.conditions = tempConditions
        
        let tempAllergies = self.allergies.filter { $0 != "" }
        self.allergies = tempAllergies
    }
}

struct CarePlanStyleCompact: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: 175, height: .infinity, alignment: .center)
            .background(Color(UIColor.systemRed))
            .foregroundColor(.white)
            .cornerRadius(5.0)
            .shadow(radius: 3)
            .scaleEffect(configuration.isPressed ? 1.08 : 1.0)
            
    }
}

struct MultiPicker: View  {

    typealias Label = String
    typealias Entry = String

    let data: [ (Label, [String]) ]
    @Binding var selection: [Entry]

    var body: some View {
        GeometryReader { geometry in
            HStack {
                ForEach(0..<self.data.count) { column in
                    Picker(self.data[column].0, selection: self.$selection[column]) {
                        ForEach(0..<self.data[column].1.count) { row in
                            Text(verbatim: "\(self.data[column].1[row]) \(self.data[column].0)")
                            .tag(self.data[column].1[row])
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: geometry.size.width / CGFloat(self.data.count), height: geometry.size.height)
                    .clipped()
                }
            }
        }
    }
}

#if DEBUG
struct AddChildPopup_Previews: PreviewProvider {
    static var previews: some View {
        AddChildPopup().environmentObject(ClericStore.shared)
    }
}
#endif
