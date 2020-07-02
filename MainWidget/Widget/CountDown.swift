//
//  CountDown.swift
//  MainWidgetExtension
//
//  Created by Littleor on 2020/7/2.
//
import WidgetKit
import SwiftUI
import Intents

/**
 扩展Date
 daysBetweenDate: 计算两天差距天数
 */
extension Date {
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
}

struct CountDownProvider: IntentTimelineProvider {
    //    typealias Entry = CountDownEntry
    public func snapshot(for configuration: CountDownIntent, with context: Context, completion: @escaping (CountDownEntry) -> ()) {
        let entry = CountDownEntry(date: Date(),data: CountDown(date: Date(),title: "Title"))
        completion(entry)
    }
    
    public func timeline(for configuration: CountDownIntent, with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
        let configureDate = configuration.date?.date ?? Date()
        let entry = CountDownEntry(date: currentDate,data: CountDown(day: Date().daysBetweenDate(toDate: configureDate),date: configureDate,title: configuration.title ?? "请配置标题" ))
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
    }
}
struct CountDown {
    var day:Int = 0
    var date:Date
    var title:String
}

struct CountDownEntry: TimelineEntry {
    public let date: Date
    public let data: CountDown
}

struct CountDownEntryView : View {
    //这里是Widget的类型判断
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: CountDownProvider.Entry
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall: CountDownView(title: entry.data.title,day: entry.data.day)
        case .systemMedium: CountDownView(title: entry.data.title,day: entry.data.day)
        default: CountDownView(title: entry.data.title,day: entry.data.day)
        }
    }
}

struct CountDownWidget: Widget {
    private let kind: String = "CountDownWidget"
    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: CountDownIntent.self, provider: CountDownProvider(), placeholder: PlaceholderView()) { entry in
            CountDownEntryView(entry: entry)
        }
        .configurationDisplayName("倒计时")
        .description("重要事情随时提醒")
        .supportedFamilies([.systemSmall])
        
    }
}
