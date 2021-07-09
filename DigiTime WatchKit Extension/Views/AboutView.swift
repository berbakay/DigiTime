//
//  AboutView.swift
//  DigiTime WatchKit Extension
//
//  Created by Richard Kay on 07/07/2021.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView() {
            VStack(alignment: .leading) {
                Text("Hi, I'm Rick, an independent iOS and watchOS developer from Manchester, UK.")
                    .padding(.bottom)
                
                Text("Thank you for downloading my app and supporting independent development on Apple's platforms.")
                    .padding(.bottom)
                
                Text("If you have any feedback on the app or would like to discuss a future project you can email me at:")
                Text("rick@berbakay.com")
                    .padding(.bottom)
                    .foregroundColor(.blue)
            }
            Text("© berbakay 2021")
                .foregroundColor(.gray)
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
