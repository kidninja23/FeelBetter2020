//
//  AddDetailPopup.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 11/18/20.
//

import SwiftUI

struct AddDetailPopup: View {
    @Binding var someField: [String]
    @Binding var showAddDetail: Bool
    @State var notes: String = ""
    var instruction: String?
    var event: String?
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .opacity(0.5)
            VStack {
                Text(instruction ?? "Add Details")
            MultilineTextField((notes == "" ? "\(event ?? "Notes")" : ""), text: $notes, onCommit: {})
                .frame(width: 300, height: .infinity, alignment: .center)
                .border(Color.black)
                HStack {
                    Spacer()
                    Button(action: {
                        self.someField.append(notes)
                        self.showAddDetail = false
                    }, label: {
                        Text("Confirm \(event ?? "")")
                    })
                    .buttonStyle(CarePlanStyleCompact())
                    .padding(.leading)
                    Spacer()
                    Button(action: {self.showAddDetail = false}, label: {
                        Text("Cancel")
                    })
                    .buttonStyle(CancelStyle())
                    .padding(.trailing)
                    Spacer()
                }
                
            }
        }.frame(width: .infinity, height: 225, alignment: .center)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
        
        
    }
}

#if DEBUG
struct AddDetailPopup_Previews: PreviewProvider {
    static var myField: [String] = [String]()
    static var myInstruction = "Enter a new Medical Condition"
    static var myEvent = "Condition"
    static var previews: some View {
        AddDetailPopup(someField: .constant(myField), showAddDetail: .constant(false), instruction: myInstruction, event: myEvent)
    }
}
#endif
