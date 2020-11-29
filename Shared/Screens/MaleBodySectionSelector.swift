//
//  MaleBodySectionSelector.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 11/2/20.
//

import SwiftUI
import CareKitStore

struct MaleBodySectionSelector: View {
    @EnvironmentObject var store: ClericStore
    @State var theProblem: String? = nil
    @State var SelectedPart = ""
    @State var HighlightHead = false
    @State var HighlightTorso = false
    @State var HighlightLeftArm = false
    @State var HighlightRightArm = false
    @State var HighlightLeftLeg = false
    @State var HighlightRightLeg = false
    @State var HighlightIllness = false
    @State var HighlightWhole = false
    @State var confirmHead: Bool = false
    @State var confirmLeftArm: Bool = false
    @State var confirmTorso: Bool = false
    @State var confirmRightArm: Bool = false
    @State var confirmLeftLeg: Bool = false
    @State var confirmRightLeg: Bool = false
    @State var confirmIllness: Bool = false
    @State var confirmWhole: Bool = false
    @State var redraw = false
    var child: OCKPatient
    
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Where is the problem for \(child.name.givenName ?? "Greg")?")
                    .bold()
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .padding()
                Text(theProblem ?? "")
                    .bold()
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .frame(width: .infinity, height: 40, alignment: .center)
            }
            Spacer()
            GeometryReader { geo in
                ScrollView {
                    VStack(alignment: .center) {
                        Button(action: {
                            HighlightSelected("Head")
                            if confirmHead == false {
                                theProblem = "Head"
                            } else {
                                theProblem = ""
                            }
                            confirmHead.toggle()
                        }, label: {
                            Image("MaleHead")
                                .resizable()
                                .scaledToFit()
                                .frame(width: .infinity, height: geo.size.height * 0.33, alignment: .center)
                                .cornerRadius(5)
                                
                        })
                        .offset(x: 0, y: 1)
                        .buttonStyle(BodySelectorStyle())
                        .if(HighlightHead){ $0.shadow(color: Color.green, radius: 20)}
                        HStack {
                            Button(action: {
                                HighlightSelected("RightArm")
                                if confirmRightArm == false {
                                    theProblem = "Right Arm"
                                } else {
                                    theProblem = ""
                                }
                                confirmRightArm.toggle()
                                
                            }, label: {
                                Image("MaleRightArm")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: .infinity, height: geo.size.height * 0.30, alignment: .center)
                                    .cornerRadius(5)
                            })
                            .offset(x: 8, y: -7)
                            .buttonStyle(BodySelectorStyle())
                            .if(HighlightRightArm){ $0.shadow(color: Color.green, radius: 20)}
                            Button(action: {
                                HighlightSelected("Torso")
                                if confirmTorso == false {
                                    theProblem = "Torso"
                                } else {
                                    theProblem = ""
                                }
                                confirmTorso.toggle()
                            }, label: {
                                Image("MaleTorso")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: .infinity, height: geo.size.height * 0.33, alignment: .center)
                                    .cornerRadius(5)
                            })
                            .offset(x: 0, y: -8)
                            .buttonStyle(BodySelectorStyle())
                            .if(HighlightTorso){ $0.shadow(color: Color.green, radius: 20)}
                            Button(action: {
                                HighlightSelected("LeftArm")
                                if confirmLeftArm == false {
                                    theProblem = "Left Arm"
                                } else {
                                    theProblem = ""
                                }
                                confirmLeftArm.toggle()
                            }, label: {
                                Image("MaleLeftArm")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: .infinity, height: geo.size.height * 0.30, alignment: .center)
                                    .cornerRadius(5)
                            })
                            .offset(x: -8, y: -7)
                            .buttonStyle(BodySelectorStyle())
                            .if(HighlightLeftArm){ $0.shadow(color: Color.green, radius: 20)}
                        }
                        HStack {
                            Button(action: {
                                HighlightSelected("RightLeg")
                                if confirmRightLeg == false {
                                    theProblem = "Right Leg"
                                } else {
                                    theProblem = ""
                                }
                                confirmRightLeg.toggle()
                            }, label: {
                                Image("MaleRightLeg")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: .infinity, height: geo.size.height * 0.31, alignment: .center)
                                    .cornerRadius(5)
                            })
                            .offset(x: 3, y: -16)
                            .buttonStyle(BodySelectorStyle())
                            .if(HighlightRightLeg){ $0.shadow(color: Color.green, radius: 20)}
                            Button(action: {
                                HighlightSelected("LeftLeg")
                                if confirmLeftLeg == false {
                                    theProblem = "Left Leg"
                                } else {
                                    theProblem = ""
                                }
                                confirmLeftLeg.toggle()
                            }, label: {
                                Image("MaleLeftLeg")
                                    .resizable()
                                    .scaledToFit()
                                    .scaledToFit()
                                    .frame(width: .infinity, height: geo.size.height * 0.31, alignment: .center)
                                    .cornerRadius(5)
                            })
                            .offset(x: -4, y: -16)
                            .buttonStyle(BodySelectorStyle())
                            .if(HighlightLeftLeg){ $0.shadow(color: Color.green, radius: 20)}
                        }
                        HStack{
                            Spacer()
                            Button(action: {
                                HighlightSelected("Illness")
                                if confirmIllness == false {
                                    theProblem = "Illness"
                                } else {
                                    theProblem = ""
                                }
                                confirmIllness.toggle()
                            }, label: {
                                Text("Illness")
                            }).buttonStyle(CarePlanStyleCompact())
                            
                            Spacer()
                            Button(action: {
                                HighlightSelected("Whole Body")
                                if confirmWhole == false {
                                    theProblem = "Whole Body"
                                } else {
                                    theProblem = ""
                                }
                                confirmWhole.toggle()
                            }, label: {
                                Text("Whole Body")
                            }).buttonStyle(CarePlanStyleCompact())
                            
                            Spacer()
                        }
                    }
                    

                }//.offset(x: geo.size.width * 0.1, y: 0)
            }
            Spacer()
            HStack {
                Spacer()
                switch theProblem {
                case "Head":
                    BodySelectionSheetButton() {
                        ZonedZiagnosis(zone: .head, child: child)
                    }
                case "Right Arm":
                    BodySelectionSheetButton() {
                        ZonedZiagnosis(zone: .arm, child: child)
                    }
                case "Torso":
                    BodySelectionSheetButton() {
                        ZonedZiagnosis(zone: .torso, child: child)
                    }
                case "Left Arm":
                    BodySelectionSheetButton() {
                        ZonedZiagnosis(zone: .arm, child: child)
                    }
                case "Right Leg":
                    BodySelectionSheetButton() {
                        ZonedZiagnosis(zone: .leg, child: child)
                    }
                case "Left Leg":
                    BodySelectionSheetButton() {
                        ZonedZiagnosis(zone: .leg, child: child)
                    }
                case "Illness":
                    BodySelectionSheetButton() {
                        ZonedZiagnosis(zone: .illness, child: child)
                    }
                case "Whole Body":
                    BodySelectionSheetButton() {
                        ZonedZiagnosis(zone: .whole, child: child)
                    }
                default:
                    Button(action: {}, label: {
                        Text("Choose Symptoms")
                            .bold()
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    })
                    .buttonStyle(CarePlanStyle())
                    .overlay(Color.gray)
                    .opacity(0.4)
                    .hidden()
                }
                Spacer()
                Button(action: {self.presentationMode.wrappedValue.dismiss()}, label: {
                    Text("Cancel")
                        .bold()
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                })
                .buttonStyle(CancelStyle())
                Spacer()
            }
        }
        
    }
    private func HighlightSelected(_ selected: String) {
        switch selected {
        case "Head":
            HighlightHead.toggle()
        case "RightArm":
            HighlightRightArm.toggle()
        case "Torso":
            HighlightTorso.toggle()
        case "LeftArm":
            HighlightLeftArm.toggle()
        case "RightLeg":
            HighlightRightLeg.toggle()
        case "LeftLeg":
            HighlightLeftLeg.toggle()
        case "Illness":
            HighlightIllness.toggle()
        case "Whole Body":
            HighlightWhole.toggle()
        default:
            deselecteOthers("")
        }
        deselecteOthers(selected)
    }
    
    private func deselecteOthers(_ selected: String) {
        if selected != "Head" {
            self.HighlightHead = false
            self.confirmHead = false
        }
        if selected != "RightArm" {
            self.HighlightRightArm = false
            self.confirmRightArm = false
        }
        if selected != "Torso" {
            self.HighlightTorso = false
            self.confirmTorso = false
        }
        if selected != "LeftArm" {
            self.HighlightLeftArm = false
            self.confirmLeftArm = false
        }
        if selected != "RightLeg" {
            self.HighlightRightLeg = false
            self.confirmRightLeg = false
        }
        if selected != "LeftLeg" {
            self.HighlightLeftLeg = false
            self.confirmLeftLeg = false
        }
        if selected != "Illness" {
            self.HighlightIllness = false
            self.confirmIllness = false
        }
    }
    
}

struct BodySelectionSheetButton<Content>: View where Content: View {
    var content: Content
    @State var isPresented = false
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        Button(action: {
            self.isPresented.toggle()
        }, label: {
            Text("Choose Symptoms")
                .bold()
                .font(.system(size: 24, weight: .bold, design: .rounded))
        }).buttonStyle(CarePlanStyle())
        .sheet(isPresented: $isPresented) {
            self.content
        }
    }
}

struct BodySelectorStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.0 : 1.0)
    }
}



struct BodySectionSelector_Previews: PreviewProvider {
    static var myChild = (ClericStore.shared.familyDetails["CHILDREN"]! as! Array<OCKPatient>)[0]
    static var previews: some View {
        MaleBodySectionSelector(child: myChild).environmentObject(ClericStore.shared)
    }
}
