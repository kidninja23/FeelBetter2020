//
//  ChildListScreen.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 11/13/20.
//

import SwiftUI
import CareKit
import CareKitUI
import CareKitStore

struct ChildListScreen: View {
    @EnvironmentObject var store: ClericStore
    @State var addChild: Bool = false
    
    var body: some View {
        let childList = self.store.familyDetails["CHILDREN"] as? Array<OCKPatient>
        NavigationView {
            GeometryReader { geo in
                VStack (alignment: .center) {
                    Spacer()
                    Text("Children")
                        .bold()
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                    ScrollView {
                        ForEach(childList!, id: \.self) {child in
                            ChildPopoutButton(child: child)
                                .padding()
                        }
                    }.frame(width: .infinity, height: geo.size.height * 0.7, alignment: .center)
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {self.addChild.toggle()}, label: {
                            HStack (spacing: 1){
                                Image("AddChild")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50, alignment: .center)
                                    .padding(10)
                                    .background(Color.red)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }
                        })
                        .buttonStyle(ScaleStyle())
                        .padding()
                    }
                }
                .frame(width: .infinity, height: .infinity, alignment: .leading)
            }
            .background(Color(UIColor.systemTeal))
            .navigationBarTitle("", displayMode: .inline)
        }.sheet(isPresented: $addChild, content: {
            AddChildPopup().environmentObject(store)
        })
    }
}

struct ChildPopoutButton: View {
    @EnvironmentObject var store: ClericStore
    @State var showMenu: Bool = false
    var child: OCKPatient
    var body: some View {
        
        NavigationLink(destination: ChildScreen(showMenu: $showMenu, child: child), label: {
            ZStack (alignment: .leading){
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(radius: 5)
                HStack {
                    Image(self.store.fetchProfileImage(child: child))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                .frame(width: 180, height: 180, alignment: .center)
                    Spacer()
                    VStack {
                        Text("\(child.name.givenName!) \(child.name.familyName!)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        Text(self.store.fetchChildBirthdate(child: child))
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    }.padding()
                    Spacer()
            }
        }
        }).buttonStyle(ScaleStyle())
    }
}

#if DEBUG
struct ChildListScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChildListScreen().environmentObject(ClericStore.shared)
    }
}
#endif
