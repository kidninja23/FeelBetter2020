//
//  GuardianAvatarSelectionScreen.swift
//  FeelBetter (iOS)
//
//  Created by Jason on 10/18/20.
//

import SwiftUI
import CareKit
import CareKitUI
import CareKitStore

struct GuardianAvatarSelectionScreen: View {
    @EnvironmentObject var store: ClericStore
    var guardian: OCKContact
    @State var showConfirm: Bool = false
    @State var selectedAvatar: String = ""
    @Binding var showAvatarChooser: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Text("Choose an Avatar")
                    .bold()
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .padding(.bottom, 30)
                HStack {
                    Button(action: {
                            self.selectedAvatar = "Avatar01"
                            self.showConfirm.toggle()}, label: {
                        AvatarCellView(imageName: "Avatar01")
                        
                    }).buttonStyle(ScaleStyle())
                    Button(action: {
                            self.selectedAvatar = "Avatar02"
                            self.showConfirm.toggle()}, label: {
                        AvatarCellView(imageName: "Avatar02")
                        
                    }).buttonStyle(ScaleStyle())
                    Button(action: {
                            self.selectedAvatar = "Avatar03"
                            self.showConfirm.toggle()}, label: {
                        AvatarCellView(imageName: "Avatar03")
                        
                    }).buttonStyle(ScaleStyle())
                }
                HStack {
                    Button(action: {
                            self.selectedAvatar = "Avatar04"
                            self.showConfirm.toggle()}, label: {
                        AvatarCellView(imageName: "Avatar04")
                        
                    }).buttonStyle(ScaleStyle())
                    Button(action: {
                            self.selectedAvatar = "Avatar05"
                            self.showConfirm.toggle()}, label: {
                        AvatarCellView(imageName: "Avatar05")
                        
                    }).buttonStyle(ScaleStyle())
                    Button(action: {
                            self.selectedAvatar = "Avatar06"
                            self.showConfirm.toggle()}, label: {
                        AvatarCellView(imageName: "Avatar06")
                        
                    }).buttonStyle(ScaleStyle())
                }.padding(.top, 10)
                HStack {
                    Button(action: {
                            self.selectedAvatar = "Avatar07"
                            self.showConfirm.toggle()}, label: {
                        AvatarCellView(imageName: "Avatar07")
                        
                    }).buttonStyle(ScaleStyle())
                    Button(action: {
                            self.selectedAvatar = "Avatar08"
                            self.showConfirm.toggle()}, label: {
                        AvatarCellView(imageName: "Avatar08")
                        
                    }).buttonStyle(ScaleStyle())
                    Button(action: {
                            self.selectedAvatar = "Avatar09"
                            self.showConfirm.toggle()}, label: {
                        AvatarCellView(imageName: "Avatar09")
                        
                    }).buttonStyle(ScaleStyle())
                }.padding(.top, 10)
                HStack {
                    Button(action: {
                            self.selectedAvatar = "Avatar10"
                            self.showConfirm.toggle()}, label: {
                        AvatarCellView(imageName: "Avatar10")
                        
                    }).buttonStyle(ScaleStyle())
                    Button(action: {
                            self.selectedAvatar = "Avatar11"
                            self.showConfirm.toggle()}, label: {
                        AvatarCellView(imageName: "Avatar11")
                        
                    }).buttonStyle(ScaleStyle())
                    Button(action: {
                            self.selectedAvatar = "Avatar12"
                            self.showConfirm.toggle()}, label: {
                        AvatarCellView(imageName: "Avatar12")
                        
                    }).buttonStyle(ScaleStyle())
                }.padding(.top, 10)
                Button(action: {self.showAvatarChooser = false}, label: {
                    Text("Cancel")
                }).buttonStyle(CancelStyle())
            }.if(showConfirm){ $0.blur(radius: 3.0) }
            if showConfirm {
                ZStack{
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(Color(UIColor.systemGray6))
                        .opacity(0.3)
                    VStack {
                        Spacer()
                        AvatarCellView(imageName: selectedAvatar).scaleEffect(2.5)
                        Spacer()
                        HStack {
                            Button(action: {
                                assignAvatar(imageName: selectedAvatar)
                            }, label: {
                                Text("Confirm")
                            }).buttonStyle(CarePlanStyle())
                            Button(action: {
                                self.showConfirm.toggle()
                                self.selectedAvatar = ""
                            }, label: {
                                Text("Cancel")
                            }).buttonStyle(CancelStyle())
                        }
                        Spacer()
                    }
                }
            }
        }
    }
    
    private func assignAvatar(imageName: String) {
        ClericStore.shared.guardianImages![guardian] = imageName
        self.showAvatarChooser = false
        self.showConfirm = false
    }
}

struct AvatarCellView: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100, alignment: .center)
            .shadow(radius: 5)
            .padding()
    }
}

struct GuardianAvatarSelectionScreen_Previews: PreviewProvider {
    static var guardian1 = ClericStore.shared.guardianMembers[0]
    
    static var previews: some View {
        GuardianAvatarSelectionScreen(guardian: guardian1!, showAvatarChooser: .constant(false)).environmentObject(ClericStore.shared)
    }
}
