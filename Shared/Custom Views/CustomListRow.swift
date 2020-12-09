//
//  CustomListRow.swift
//  FeelBetter (iOS)
//
//  Created by Jason on 10/10/20.
//

import SwiftUI
import CareKitStore

struct CustomListRow: View {
    @EnvironmentObject var store: ClericStore
    @GestureState private var dragDistance = CGSize.zero
    @State private var newReveal: Bool = false
    @State private var position = CGSize.zero
    @State var showDiagnosis: Bool = false
    @State var showMale: Bool = false
    @State var showFemale: Bool = false
    @State var profileLinkActive = true
    @Binding var showMenu: Bool
    
    var child: OCKPatient
    
    
    var body: some View {
        let image = store.childDetails2[child]!["PROFILE_IMAGE"]
        ZStack {
            GeometryReader { geo in
                HStack{
                    Button(action: {
                        let gender = store.fetchChildGender(child: child)
                        if gender == "Male" {
                            self.showMale = true
                            self.showFemale = false
                            self.showDiagnosis = true
                        } else {
                            self.showMale = false
                            self.showFemale = true
                            self.showDiagnosis = true
                            
                        }
                        
                    }, label: {
                        Text("New Event")
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .padding()
                    })
                    .navigationBarBackButtonHidden(true)
                    .simultaneousGesture(TapGesture().onEnded(){self.position.width = 0.0})
                    .frame(width: .infinity, height: 80, alignment: .center)
                    .background(Color(UIColor.systemRed))
                    .cornerRadius(10)
                }
                .frame(width: geo.size.width * 0.95, height: 80, alignment: .trailing)
                .background(Color.white)
                .cornerRadius(10)
                }
            GeometryReader { geo in
                HStack {
                    Text("\(child.name.givenName!)")
                        .bold()
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .padding()
                    Text("\(String(showMale))\(String(showFemale))").frame(width: 1, height: 1, alignment: .center).hidden()
                    
                    //Circle to be replaced With User Profile
                    GeometryReader { geo in
                        if profileLinkActive {
                            NavigationLink( destination: ChildScreen( showMenu: $showMenu, child: child).environmentObject(store)) {
                                ProfileInRowImage(child: child, image: image).environmentObject(store)
                                    }
                            .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.9, alignment: .trailing).offset(x: 0, y: geo.size.height * 0.05)
                        } else {
                            ProfileInRowImage(child: child, image: image).frame(width: geo.size.width * 0.9, height: geo.size.height * 0.9, alignment: .trailing).offset(x: 0, y: geo.size.height * 0.05)
                        }
                    }.offset(x: 20, y: 0.0)
                }
                .frame(width: geo.size.width * 0.95, height: 80, alignment: .trailing)
                .background(Color.white)
                .cornerRadius(10)
                .offset(x: position.width + dragDistance.width, y: 0)
                .gesture(DragGesture().updating($dragDistance, body: { (value, state, transaction) in
                    if value.translation.width < 0 {
                        state = value.translation }
                })
                .onEnded({ (value) in
                    self.newReveal.toggle()
                    self.profileLinkActive.toggle()
                    if newReveal { self.position.width = -140 }
                    else {self.position.width = 0.0}
                })
                )
            }
        }
        .frame(width: .infinity, height: 80, alignment: .center).offset(x: 10.0, y: 0.0)
        .shadow(radius: 3)
        .sheet(isPresented: $showDiagnosis, onDismiss: { self.profileLinkActive = true }, content : {
            if showMale {
                MaleBodySectionSelector(child: child).environmentObject(store)
            }
            if showFemale {
                FemaleBodySectionSelector(child: child).environmentObject(store)
            }
        })
    }
    
}

struct ProfileInRowImage: View {
    @EnvironmentObject var store: ClericStore
    @State var child: OCKPatient
    @State var image: Any?
    var body: some View {
        if store.childDetails2[child] != nil {
            let theImage = store.childDetails2[child]!["PROFILE_IMAGE"]
            if let theImage = theImage as? String {
                if !theImage.isEmpty {
                    Image(theImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        .frame(width: 80, height: 80, alignment: .center)
                } else {
                    Image("default_profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        .frame(width: 80, height: 80, alignment: .center)
                }
            } else {
                (theImage as! Image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    .frame(width: 80, height: 80, alignment: .center)
            }
        }
    }
}
#if DEBUG
struct CustomListRow_Previews: PreviewProvider {
    static var myPatient = OCKPatient(id: "jb", givenName: "Fred", familyName: "B")
    static var previews: some View {
        CustomListRow(showMenu: .constant(false), child: myPatient).environmentObject(ClericStore.shared)
    }
}
#endif
