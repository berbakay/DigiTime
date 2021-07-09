//
//  UnlockView.swift
//  DigiTime WatchKit Extension
//
//  Created by Richard Kay on 24/06/2021.
//

import StoreKit
import SwiftUI

struct UnlockView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var unlockManager: UnlockManager
    let isUnlocked = UserDefaults.standard.bool(forKey: "fullVersionUnlocked")
    
    var body: some View {
        VStack {
            if isUnlocked {
                Text("You already have the premium version of the app")
            } else {
                
                switch unlockManager.requestState {
                case .loaded(let product):
                    ProductView(product: product)
                case .failed(_):
                    Text("Sorry, there was an error loading the store. Please try again later.")
                case .loading:
                    ProgressView("Loading...")
                case .purchased:
                    Text("Thank you!")
                case .deferred:
                    Text("Thank you! Your request is pending approval, but you can carry on using the app in the meantime.")
                }
            }
        }
        .padding()
        .onReceive(unlockManager.$requestState) { value in
            if case .purchased = value {
                dismiss()
            }
        }
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}
