//
//  ComplicationController.swift
//  DigiTime WatchKit Extension
//
//  Created by Richard Kay on 01/05/2021.
//

import ClockKit
import SwiftUI

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Complication Configuration
    
    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "DigiTime", supportedFamilies: [.graphicCircular, .utilitarianLarge, .circularSmall, .graphicCorner, .utilitarianSmall])
            // Multiple complication support can be added here with more descriptors
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }
    
    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        let endDate = Date().addingTimeInterval(86400)
        handler(endDate)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        getTimelineEntries(for: complication, after: Date(), limit: 1) {
            handler($0?.first)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        
        var entries = [CLKComplicationTimelineEntry]()
        
        for i in 0 ..< limit {
            let complicationDate = date.addingTimeInterval(Double(60 * i))
            let timeTemplate = template(for: complication.family, date: complicationDate)
            let entry = CLKComplicationTimelineEntry(date: complicationDate, complicationTemplate: timeTemplate)
            
            entries.append(entry)
        }
        handler(entries)
    }
    
    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        
        switch complication.family {
        case .graphicCircular:
            let template = CLKComplicationTemplateGraphicCircularView (
                ComplicationView(text: "9:18"))
            handler(template)
        case .utilitarianLarge:
            let text1 = CLKSimpleTextProvider(text: "9:18")
            let template = CLKComplicationTemplateUtilitarianLargeFlat(textProvider: text1)
            handler(template)
        case .circularSmall:
            let text1 = CLKSimpleTextProvider(text: "10:59")
            let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: text1)
            handler(template)
        case .graphicCorner:
            let GaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: .clear, fillFraction: .zero)
            let text = CLKSimpleTextProvider(text: "10:59")
            let template = CLKComplicationTemplateGraphicCornerGaugeText(gaugeProvider: GaugeProvider, outerTextProvider: text)
            handler(template)
        case .utilitarianSmall:
            let text = CLKSimpleTextProvider(text: "10:59")
            let template = CLKComplicationTemplateUtilitarianSmallFlat(textProvider: text)
            handler(template)
        default:
            handler(nil)
        }
    }
    
    func template(for family: CLKComplicationFamily, date:Date) -> CLKComplicationTemplate {
        let timeFormat = UserDefaults.standard.string(forKey: "timeFormat") ?? "12"
        var theTime: String
        if timeFormat == "24" {
            let Formatter = DateFormatter()
            Formatter.setLocalizedDateFormatFromTemplate("HH:mm")
            theTime = Formatter.string(from: date)
        } else if timeFormat == "12" {
            let Formatter = DateFormatter()
            Formatter.dateStyle = .none
            Formatter.timeStyle = .short
            theTime = Formatter.string(from: date)
        } else if timeFormat == "Decimal" {
            let milisecondsToday = Int(date.timeIntervalSince1970) % 86400
            let percentageToday = Double(milisecondsToday) / 86400
            let PercentageTodayString = String(percentageToday)
            let hour = PercentageTodayString.dropFirst(2)
            let hourDigit = hour.first!
            let minutes = hour.dropFirst()
            let minutesDigits = minutes.prefix(2)
            let decimalTime = "\(hourDigit):\(minutesDigits)"
            theTime = decimalTime
        } else {
            let Formatter = DateFormatter()
            Formatter.dateStyle = .none
            Formatter.timeStyle = .short
            theTime = String(Formatter.string(from: date).dropLast(3))
        }
        
        switch family {
        case .circularSmall:
            if timeFormat == "12" {
                let onlyTime = CLKSimpleTextProvider(text: String(theTime.dropLast(3)))
                let onlyLetters = CLKSimpleTextProvider(text: String(theTime.suffix(2)))
                let template = CLKComplicationTemplateCircularSmallStackText(line1TextProvider: onlyTime, line2TextProvider: onlyLetters)
                return template
            } else {
                let text = CLKSimpleTextProvider(text: theTime)
                let template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: text)
                return template
            }
        case .utilitarianLarge:
            let text = CLKSimpleTextProvider(text: theTime)
            let template = CLKComplicationTemplateUtilitarianLargeFlat(textProvider: text)
            return template
        case .graphicCorner:
            let mili = Int(date.timeIntervalSince1970) % 86400
            let percentage = Double(mili) / 86400
            let isUnlocked = UserDefaults.standard.bool(forKey: "fullVersionUnlocked")
            let GaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: .clear, fillFraction: isUnlocked ? Float(percentage) : .zero)
            let text = CLKSimpleTextProvider(text: theTime)
            let template = CLKComplicationTemplateGraphicCornerGaugeText(gaugeProvider: GaugeProvider, outerTextProvider: text)
            return template
        case .utilitarianSmall:
            let text = CLKSimpleTextProvider(text: theTime)
            let template = CLKComplicationTemplateUtilitarianSmallFlat(textProvider: text)
            return template
        default:
            let template = CLKComplicationTemplateGraphicCircularView (
                ComplicationView(text: theTime))
            return template
        }
    }
    
    struct ComplicationView: View {
        @State var text: String
        
        var body: some View {
            Text(text).multilineTextAlignment(.center)
        }
    }
}
