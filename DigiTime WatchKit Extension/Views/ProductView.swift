//
//  ProductView.swift
//  DigiTime WatchKit Extension
//
//  Created by Richard Kay on 24/06/2021.
//

import SwiftUI
import StoreKit

struct ProductView: View {
    @EnvironmentObject var unlockManager: UnlockManager
    let product: SKProduct
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Upgrade to premium so that complications with gauges fill up based on the percentage of the day that has been completed. Premium also adds the option to have the compliation display decimal time.")
                
                Button("Buy: \(product.localizedPrice)", action: unlock)
                
                Button("Restore Purchases", action: unlockManager.restore)
            }
        }
    }
    
    func unlock() {
        unlockManager.buy(product: product)
    }
}
