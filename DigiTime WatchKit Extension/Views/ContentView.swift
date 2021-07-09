//
//  ContentView.swift
//  DigiTime WatchKit Extension
//
//  Created by Richard Kay on 01/05/2021.
//

import SwiftUI
import Foundation
import ClockKit

struct ContentView: View {
    @StateObject var viewModel: ViewModel
    @State public var timeFormat = "24"
    @State private var showingUnlockView = false
    let timeFormatOptions = ["12", "24", "Minimal"]
    let extraFormatOptions = ["12", "24", "Minimal", "Decimal"]
    var premium: Bool
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(alignment: .leading) {
                    NavigationLink(destination: TimePickerView(unlocked: premium)) {
                        Text("Select Time Format")
                    }
                    Button("Unlock Premium") {
                        showingUnlockView.toggle()
                    }
                    NavigationLink(destination: AboutView()) {
                        Text("About")
                    }
                }
            }
        }
        .sheet(isPresented: $showingUnlockView) {
            UnlockView()
        }
        .navigationTitle("DigiTime")
    }
    
    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        
        _viewModel = StateObject(wrappedValue: viewModel)
        
        premium = dataController.fullVersionUnlocked
    }
}
