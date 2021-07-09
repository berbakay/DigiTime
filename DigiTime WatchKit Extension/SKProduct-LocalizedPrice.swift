//
//  SKProduct-LocalizedPrice.swift
//  DigiTime WatchKit Extension
//
//  Created by Richard Kay on 24/06/2021.
//

import StoreKit

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
