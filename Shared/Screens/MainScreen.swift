//
//  MainScreen.swift
//  FeelBetter (iOS)
//
//  Created by Jason on 10/10/20.
//

import SwiftUI
import CareKit
import CareKitStore

struct MainScreen: View {
    @EnvironmentObject var store: ClericStore
    @Binding var showMenu: Bool
    
    var body: some View {
        let childList = store.familyDetails["CHILDREN"] as? Array<OCKPatient>
        NavigationView{
            VStack {
                Spacer()
                familyProfileImageView().padding(.top).padding(.top)
                Text("Welcome \(self.store.familyDetails["LAST"] as? String ?? "Default") Family")
                    .bold()
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .padding()
                ScrollView{
                    ForEach(childList!, id: \.self) { child in
                        CustomListRow(showMenu: $showMenu, patient: child)
                    }
                }
            }.background(Color(UIColor.systemTeal))
            .navigationBarTitle("",displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action: withAnimation {{self.showMenu.toggle()}},
                                           label: {
                Image(systemName: "line.horizontal.3")
            })
            .buttonStyle(PlainButtonStyle())
            )
        }
    }
    
}

struct familyProfileImageView: View {
    @EnvironmentObject var store: ClericStore
    
    let image: String? = nil
    var body: some View {
        Image(self.store.familyDetails["FAMILY_PROFILE_IMAGE"] as? String ?? "FamilyStockImage")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .shadow(radius: 5)
            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var store = ClericStore.shared
    static var previews: some View {
        MainScreen(showMenu: .constant(false)).environmentObject(store)
    }
}
