//
//  TimePicker.swift
//  DigiTime WatchKit Extension
//
//  Created by Richard Kay on 30/06/2021.
//

import SwiftUI
import Foundation
import ClockKit

struct TimePickerView: View {
    
    @State public var timeFormat = "24"
    @StateObject var viewModel: ViewModel
    let timeFormatOptions = ["12", "24", "Minimal"]
    let extraFormatOptions = ["12", "24", "Minimal", "Decimal"]
    let selectedColor = Color(red: 0, green: 0.55, blue: 0.25)
    var premium: Bool
    
    var body: some View {
        List {
            ForEach(premium ? extraFormatOptions : timeFormatOptions, id: \.self) { format in
                Button(action: {
                    timeFormat = format
                }, label: {
                    VStack(alignment: .leading) {
                        Text(viewModel.title(format))
                        Text(viewModel.description(format))
                            .italic()
                            .foregroundColor(.gray)
                    }
                }
                )
                .listItemTint(timeFormat == format ? selectedColor : .none)
            }
        }
        .onChange(of: timeFormat, perform: { value in
            UserDefaults.standard.set(timeFormat, forKey: "timeFormat")
            viewModel.reloadComplication()
        })
        .navigationTitle("Format")
    }
    
    init(unlocked: Bool) {
        let viewModel = ViewModel()
        
        _viewModel = StateObject(wrappedValue: viewModel)
        
        premium = unlocked
    }
}

struct TimePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TimePickerView(unlocked: true)
    }
}
