//
//  HeadSymptomDiagnosis.swift
//  FeelBetter (iOS)
//
//  Created by Jason Bice on 11/2/20.
//

import SwiftUI

struct HeadSymptomDiagnosis: View {
    var body: some View {
        ScrollView {
            VStack {
            Text("default_profile").bold()
                    .font(.system(size: 32, weight: .bold, design: .rounded))

            }
        }
    }
}

struct HeadSymptomDiagnosis_Previews: PreviewProvider {
    static var previews: some View {
        HeadSymptomDiagnosis()
    }
}
