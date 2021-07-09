//
//  ProjectViewModel.swift
//  DigiTime WatchKit Extension
//
//  Created by Richard Kay on 25/06/2021.
//

import Foundation
import ClockKit

extension ContentView {
    class ViewModel: ObservableObject {
        let dataController: DataController
        
        init(dataController: DataController) {
            self.dataController = dataController
        }
        
        func reloadComplication() {
            let complicationServer = CLKComplicationServer.sharedInstance()
            
            for complication in complicationServer.activeComplications! {
                complicationServer.reloadTimeline(for: complication)
            }
        }
    }
}

extension TimePickerView {
    class ViewModel: ObservableObject {
        func reloadComplication() {
            let complicationServer = CLKComplicationServer.sharedInstance()
            
            for complication in complicationServer.activeComplications! {
                complicationServer.reloadTimeline(for: complication)
            }
        }
        
        func title(_ timeFormat: String) -> String {
            switch timeFormat {
            case "24": return "24-Hour"
            case "12" : return "12-Hour"
            case "Decimal" : return "Decimal Time"
            default : return "Minimal"
            }
        }
        
        func description(_ timeFormat: String) -> String {
            switch timeFormat {
            case "24": return "17:21"
            case "12" : return "3:27pm"
            case "Decimal" : return "7:85"
            default : return "4:28"
            }
        }
    }
}
