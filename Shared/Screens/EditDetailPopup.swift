//
//  EditDetailPopup.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 11/18/20.
//

import SwiftUI

struct EditDetailPopup: View {
    @Binding var someField: [String]
    @Binding var someFieldItem: String
    @Binding var showAddDetail: Bool
    @Binding var confirmDelete: Bool
    @State var notes: String = ""
    var instruction: String?
    var event: String?
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .opacity(0.5)
            VStack {
                Text(instruction ?? "Edit Details")
                MultilineTextField("", text: $notes, onCommit: {})
                .frame(width: 300, height: .infinity, alignment: .center)
                .border(Color.black)
                HStack {
                    Spacer()
                    Button(action: {
                        let index = someField.firstIndex(of: someFieldItem)!
                        self.someField[index] = notes
                        self.showAddDetail = false
                    }, label: {
                        Text("Confirm \(event ?? "")")
                    })
                    .buttonStyle(CarePlanStyleCompact())
                    Button(action: {self.showAddDetail = false}, label: {
                        Text("Cancel")
                    })
                    .buttonStyle(CancelStyle())
                    Button(action: {
                        self.confirmDelete = true
                    }, label: {
                        Image("Delete")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                    })
                    .buttonStyle(DeleteStyle())
                    Spacer()
                }
                
            }.onAppear(perform: {
                self.notes = someFieldItem
            })
        }
        .frame(width: .infinity, height: 225, alignment: .center)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
    }
}

struct ConfirmFieldDelete: View {
    @Binding var confirmDelete: Bool
    @Binding var previousShowing: Bool
    @Binding var someField: [String]
    @Binding var someFieldItem: String
    var deleteItemType: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
            VStack {
                Text("Are you sure you want to delete this \(deleteItemType)? This action can not be undone.")
                    .font(.body)
                    .frame(width: 300, height: 100, alignment: .center)
                    .background(Color.white)
                    .border(Color.red)
                    .shadow(radius: 5)
                    
                    
                HStack {
                    Button(action: {
                        let index = someField.firstIndex(of: someFieldItem)!
                        self.someField[index] = ""
                        self.confirmDelete = false
                        self.previousShowing = false
                    }, label: {
                        Text("Confirm")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    }).buttonStyle(CarePlanStyle()).padding(.leading)
                    Spacer()
                    Button(action: {self.confirmDelete = false}, label: {
                        Text("Cancel")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    }).buttonStyle(CancelStyle()).padding(.trailing)
                }
            }
            .frame(width: .infinity, height: 400, alignment: .center)
        }
    }
}

struct DeleteStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(6)
            .frame(width: .infinity, height: .infinity, alignment: .center)
            .background(Color(UIColor.systemGray5))
            .cornerRadius(5.0).shadow(radius: 3)
            .scaleEffect(configuration.isPressed ? 1.08 : 1.0)
            
    }
}

#if DEBUG
struct EditDetailPopup_Previews: PreviewProvider {
    static var myField: [String] = ["Condition 1", "Condition 2", "Condition 3"]
    static var myFieldItem = "Condition 2"
    static var myInstruction = "Edit a Medical Condition"
    static var myEvent = "Condition"
    static var previews: some View {
        EditDetailPopup(someField: .constant(myField), someFieldItem: .constant(myFieldItem), showAddDetail: .constant(false), confirmDelete: .constant(false), instruction: myInstruction, event: myEvent)
    }
}
#endif
