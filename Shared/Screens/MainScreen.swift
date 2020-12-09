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
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State var preferEditor: Bool = false
    
    var body: some View {
        let childList = store.familyDetails["CHILDREN"] as? Array<OCKPatient>
        NavigationView{
            VStack {
                Spacer()
                familyProfileImageView()
                    .environmentObject(store)
                    .onLongPressGesture {
                        self.preferEditor = true
                        self.showingImagePicker = true
                    }
                    .padding(.top)
                    .padding(.top)
                Text("Welcome \(self.store.familyDetails["LAST"] as? String ?? "Default") Family")
                    .bold()
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .padding()
                ScrollView{
                    ForEach(childList!, id: \.self) { child in
                        CustomListRow(showMenu: $showMenu, child: child)
                    }
                }
            }.if(preferEditor) {
                    $0.sheet(isPresented: $showingImagePicker, onDismiss: {
                    loadImage()
                } ,content: {
                    ImagePicker(selectedImage: $inputImage)
                })
            }
            .background(Color(UIColor.systemTeal))
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
    
    func loadImage() {
        self.preferEditor = false
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        store.familyDetails["FAMILY_PROFILE_IMAGE"] = image
        
    }
    
}

struct familyProfileImageView: View {
    @EnvironmentObject var store: ClericStore
    
    let image: String? = nil
    var body: some View {
        let theImage = self.store.familyDetails["FAMILY_PROFILE_IMAGE"]
        if let theImage = theImage as? String {
            Image(theImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .shadow(radius: 5)
            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
        } else {
            (theImage as! Image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .shadow(radius: 5)
            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var store = ClericStore.shared
    static var previews: some View {
        MainScreen(showMenu: .constant(false)).environmentObject(store)
    }
}
