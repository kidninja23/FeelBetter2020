//
//  MenuView.swift
//  FeelBetter (iOS)
//
//  Created by Jason on 10/17/20.
//

import SwiftUI

enum ActiveMenu {
    case profile, provider, settings, privacy
}

struct MenuView: View {
    @EnvironmentObject var store: ClericStore
    @State private var menuSelection: ActiveMenu?
    
    var body: some View {
        NavigationView {
        VStack (alignment: .leading){
            MenuSheetButton("ProfileCustomGray", "Profile") {
                ProfileScreen(guardian: ClericStore.shared.activeGuardian!).environmentObject(store)
            }
            .padding(.top, 80)
            MenuSheetButton("MedicalProvider", "Provider") {
                ProviderScreen().environmentObject(store)
            }
           .padding(.top, 20)
            MenuSheetButton("SettingsCustomGray", "Settings") {
                SettingsScreen()
            }
            .padding(.top, 20)
            MenuSheetButton("PrivacyCustomGray", "Privacy Policy") {
                PrivacyPolicyScreen()
            }
            .padding(.top, 20)
            MenuSheetButton("BookCustomGray", "Resources") {
                ResourceList(viewModel: ResourceViewModel())
            }
            .padding(.top, 20)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color(UIColor.systemTeal)]), startPoint: .leading, endPoint: .trailing))
        .navigationBarTitle("",displayMode: .inline)
        }
    }
}

struct MenuSheetButton<Content>: View where Content : View {
    var imageName: String
    var text: String
    var content: Content
    @State var isPresented = false

    init(_ imageName: String, _ text: String, @ViewBuilder content: () -> Content) {
        self.imageName = imageName
        self.text = text
        self.content = content()
    }

    var body: some View {
        Button(action: {
            self.isPresented.toggle()
        }, label: {
            Image(imageName)
            Text(text)
                .font(.headline)
                .bold()
                .foregroundColor(.white)
        })
        .sheet(isPresented: $isPresented) {
            self.content
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView().environmentObject(ClericStore.shared)
    }
}
