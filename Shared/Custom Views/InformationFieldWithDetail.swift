//
//  InformationField.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 11/6/20.
//

import SwiftUI

struct InformationFieldWithDetail<DetailView: View>: View {
    @EnvironmentObject var store: ClericStore
    @State var showDetail: Bool = false
    var label: String
    var info: String
    let detailView: DetailView?
    
    var body: some View {
        ZStack (alignment: .topTrailing) {
            HStack (alignment: .top){
                Text("\(label): ")
                    .bold()
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .frame(width: 120, height: .infinity, alignment: .leading)
                    .padding()
                Spacer()
                Text(info)
                    .bold()
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .padding(.trailing, 25)
                    .padding()
            }
            .frame(width: .infinity, height: .infinity, alignment: .center)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.leading)
            .padding(.trailing)
            
            Image(systemName: "info.circle")
                .offset(x: -22, y: 5)
        }
        .onTapGesture(count: 2) {showDetail.toggle()}
        .sheet(isPresented: $showDetail, content: {
            detailView
        })
    }
}


#if DEBUG
struct InformationFieldWithDetail_Previews: PreviewProvider {
    static var myStore = ClericStore.shared
    static var child = myStore.activePatient!
    static var myLabel: String = myStore.childDetailLabels["ALLERGIES"] ?? "Unspecified"
    static var myInfo: String  = (myStore.fetchAllAppointmentsString()).joined(separator: ",\n\n")
    static var moreInfo = myStore.fetchAllChildrenString()
    static var previews: some View {
        InformationFieldWithDetail(label: myLabel, info: moreInfo, detailView: AddAppointment()).environmentObject(myStore)
    }
}
#endif
