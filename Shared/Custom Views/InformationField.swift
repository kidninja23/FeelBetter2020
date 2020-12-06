//
//  InformationField.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 11/6/20.
//

import SwiftUI

struct InformationField: View {
        var label: String
        var info: String

        var body: some View {
            HStack {
                Text("\(label): ")
                    .bold()
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .padding(.leading)
                        
                Spacer()
                Text(info)
                    .bold()
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .padding()
                }
            .frame(width: .infinity, height: .infinity, alignment: .center)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.leading)
                .padding(.trailing)
                .padding(.bottom, 5)
                
            }
    }



    struct InformationField_Previews: PreviewProvider {
        static var myStore = ClericStore.shared
        static var child = myStore.activePatient!
        static var myLabel: String = myStore.childDetailLabels["SPECIALIST"] ?? "Unspecified"
        static var myInfo: String  = myStore.fetchSpecialistList(child: child)
        static var previews: some View {
            InformationField(label: myLabel, info: myInfo).environmentObject(myStore)
        }
    }

