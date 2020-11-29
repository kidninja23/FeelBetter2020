//
//  DiagnosisScreen.swift
//  FeelBetter (iOS)
//
//  Created by Jason on 10/10/20.
//

import SwiftUI
import CareKit
import CareKitUI
import CareKitStore

struct DiagnosisScreen: View {
    @EnvironmentObject var store: ClericStore
    @Binding var showDiagnosis: Bool
    @State var confirmOption1: Bool = false
    @State var confirmOption2: Bool = false
    @State var confirmOption3: Bool = false
    @State var confirmOption4: Bool = false
    @State var confirmOption5: Bool = false
    @State var confirmOption6: Bool = false
    @State var theProblem: String? = nil
    @State var symptomSelected: Bool = false
    @State var showCarePlan: Bool = false
    @State var redraw: Bool = false
    var carePlan: String = ""
    
    var body: some View {
        let patient = store.activePatient!
        VStack{
            Spacer()
            VStack {
                Text("What's wrong with \(patient.name.givenName!)?")
                    .bold()
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .frame(width: .infinity, height: 80, alignment: .center)
                    .padding()
                Text(theProblem ?? "")
                    .bold()
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .frame(width: .infinity, height: 80, alignment: .center)
            }
            Spacer()
            HStack {
                Spacer()
                if confirmOption1 == false{ Button(action: {
                    theProblem = "Fever?"
                    confirmOption1.toggle()
                    turnOffOthers(except: 1)
                    symptomSelected = true
                    
                }, label: {
                    DiagnosisImage(name: "Fever")
                })
                .buttonStyle(ScaleStyle())
                }
                else {
                    Button(action: {
                        confirmOption1.toggle()
                        theProblem = ""
                        symptomSelected = false
                    }, label: {
                        DiagnosisImage(name: "Confirm")
                    })
                    .buttonStyle(ScaleStyle())
                }
               
                Spacer()
                if confirmOption2 == false{ Button(action: {
                    theProblem = "Stomach Ache?"
                    confirmOption2.toggle()
                    turnOffOthers(except: 2)
                    symptomSelected = true
                    
                }, label: {
                    DiagnosisImage(name: "StomachAche")
                })
                .buttonStyle(ScaleStyle())
                }
                else {
                    Button(action: {
                        confirmOption2.toggle()
                        theProblem = ""
                        symptomSelected = false
                    }, label: {
                        DiagnosisImage(name: "Confirm")
                    })
                    .buttonStyle(ScaleStyle())
                }
                Spacer()
            }.padding()
            HStack {
                Spacer()
                if confirmOption3 == false{ Button(action: {
                    theProblem = "Rash?"
                    confirmOption3.toggle()
                    turnOffOthers(except: 3)
                    symptomSelected = true
                    
                }, label: {
                    DiagnosisImage(name: "Rash2")
                })
                .buttonStyle(ScaleStyle())
                }
                else {
                    Button(action: {
                        confirmOption3.toggle()
                        theProblem = ""
                        symptomSelected = true
                    }, label: {
                        DiagnosisImage(name: "Confirm")
                    })
                    .buttonStyle(ScaleStyle())
                }
                Spacer()
                if confirmOption4 == false{ Button(action: {
                    theProblem = "Cough?"
                    confirmOption4.toggle()
                    turnOffOthers(except: 4)
                    symptomSelected = true
                    
                }, label: {
                    DiagnosisImage(name: "Cough")
                })
                .buttonStyle(ScaleStyle())
                }
                else {
                    Button(action: {
                        confirmOption4.toggle()
                        theProblem = ""
                        symptomSelected = false
                    }, label: {
                        DiagnosisImage(name: "Confirm")
                    })
                    .buttonStyle(ScaleStyle())
                }
                Spacer()
            }.padding()
            HStack {
                Spacer()
                if confirmOption5 == false{ Button(action: {
                    theProblem = "Runny Nose?"
                    confirmOption5.toggle()
                    turnOffOthers(except: 5)
                    symptomSelected = true
                    
                }, label: {
                    DiagnosisImage(name: "RunnyNose")
                })
                .buttonStyle(ScaleStyle())
                }
                else {
                    Button(action: {
                        confirmOption5.toggle()
                        theProblem = ""
                        symptomSelected = false
                    }, label: {
                        DiagnosisImage(name: "Confirm")
                    })
                    .buttonStyle(ScaleStyle())
                }
                Spacer()
                if confirmOption6 == false{ Button(action: {
                    theProblem = "Vomiting?"
                    confirmOption6.toggle()
                    turnOffOthers(except: 6)
                    symptomSelected = true
                    
                }, label: {
                    DiagnosisImage(name: "GreenFace")
                })
                .buttonStyle(ScaleStyle())
                }
                else {
                    Button(action: {
                        confirmOption6.toggle()
                        theProblem = ""
                        symptomSelected = true
                    }, label: {
                        DiagnosisImage(name: "Confirm")
                    })
                    .buttonStyle(ScaleStyle())
                }
                Spacer()
            }.padding()
            Spacer()
            HStack {
                Spacer()
                if redraw == false {
                    Button(action: {
                        store.selectedPatient = patient
                        store.clericStore.populateFeverCarePlan(patient)
                        self.redraw = true
                        self.showCarePlan = true
                    }, label: {
                        Text("Start A Care Plan")
                            .bold()
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    })
                    .buttonStyle(CarePlanStyle())
                } else {
                    Button(action: {
                        self.showCarePlan.toggle()
                    }, label: {
                        Text("See Care Plan")
                            .bold()
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    })
                    .buttonStyle(CarePlanStyle())
                }
                Spacer()
                Button(action: {self.showDiagnosis.toggle()}, label: {
                    Text("Cancel")
                        .bold()
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                })
                .buttonStyle(CancelStyle())
                Spacer()
            }.sheet(isPresented: $showCarePlan, content: {
                FeverViewWrapper()
            })
        }
    }
    
    private func turnOffOthers(except: Int) {
        if except != 1 {
            self.confirmOption1 = false
        }
        if except != 2 {
            self.confirmOption2 = false
        }
        if except != 3 {
            self.confirmOption3 = false
        }
        if except != 4 {
            self.confirmOption4 = false
        }
        if except != 5 {
            self.confirmOption5 = false
        }
        if except != 6 {
            self.confirmOption6 = false
        }
    }
}

struct DiagnosisImage: View {
    var name: String
    
    var body: some View {
        Image(name)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(radius: 5)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
            .frame(width: 130, height: 130, alignment: .center)
    }
}

struct ScaleStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.08 : 1.0)
    }
}

struct CarePlanStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: 250, height: .infinity, alignment: .center)
            .background(Color(UIColor.systemRed))
            .foregroundColor(.white)
            .cornerRadius(5.0)
            .shadow(radius: 3)
            .scaleEffect(configuration.isPressed ? 1.08 : 1.0)
            
    }
}

struct CancelStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: .infinity, height: .infinity, alignment: .center)
            .background(Color(UIColor.systemGray5))
            .cornerRadius(5.0).shadow(radius: 3)
            .scaleEffect(configuration.isPressed ? 1.08 : 1.0)
            
    }
}

struct DiagnosisScreen_Previews: PreviewProvider {
    static var previews: some View {
        DiagnosisScreen(showDiagnosis: .constant(false)).environmentObject(ClericStore.shared)
    }
}
