//
//  Widget.swift
//  Widget
//
//  Created by Charlotte Liang on 3/17/22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(
      date: Date(),
      configuration: ConfigurationIntent(),
      image: UIImage(imageLiteralResourceName: "coffee.png"),
      text: "Mini travel blog"
    )
  }

  func getSnapshot(for configuration: ConfigurationIntent, in context: Context,
                   completion: @escaping (SimpleEntry) -> Void) {
    let entry = SimpleEntry(
      date: Date(),
      configuration: ConfigurationIntent(),
      image: UIImage(imageLiteralResourceName: "coffee.png"),
      text: "Mini travel blog"
    )
    completion(entry)
  }

  func getTimeline(for configuration: ConfigurationIntent, in context: Context,
                   completion: @escaping (Timeline<Entry>) -> Void) {
    MiniPost.getPost(imageName: "currentImage.JPG") { image, text in
      var entries: [SimpleEntry] = []

      // Generate a timeline consisting of five entries an hour apart, starting from the current date.
      let currentDate = Date()
      for minuteOffset in 0 ..< 5 {
        let entryDate = Calendar.current.date(
          byAdding: .minute,
          value: minuteOffset,
          to: currentDate
        )!
        let entry = SimpleEntry(
          date: entryDate,
          configuration: configuration,
          image: image,
          text: text
        )
        entries.append(entry)
      }

      let timeline = Timeline(entries: entries, policy: .atEnd)
      completion(timeline)
    }
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationIntent
  var image: UIImage = .init()
  var text: String
}

struct PhotoWidgetEntryView: View {
  @Environment(\.widgetFamily) var family: WidgetFamily
  var entry: Provider.Entry
  var body: some View {
    VStack {
      switch family {
      case .systemSmall:
        VStack {
          Image(uiImage: entry.image).resizable()
            .aspectRatio(contentMode: .fit)
          Text(entry.text)
            .bold()
            .padding()
        }
      case .systemMedium:
        HStack {
          Image(uiImage: entry.image).resizable()
            .aspectRatio(contentMode: .fit)
          Text(entry.text)
            .bold()
            .padding()
        }
      case .systemLarge:
        VStack {
          Text(entry.date, style: .time)
            .bold()
            .padding()
          Image(uiImage: entry.image).resizable()
            .aspectRatio(contentMode: .fit)
          Text(entry.text)
            .bold()
            .padding()
        }
      default:
        Image(uiImage: entry.image).resizable()
      }
    }
  }
}

@main
struct PhotoWidget: Widget {
  let kind: String = "PhotoWidget"

  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self,
                        provider: Provider()) { entry in
      PhotoWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

struct PhotoWidget_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      PhotoWidgetEntryView(entry: SimpleEntry(
        date: Date(),
        configuration: ConfigurationIntent(),
        image: UIImage(imageLiteralResourceName: "coffee.png"),
        text: "Mini travel blog"
      ))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
      PhotoWidgetEntryView(entry: SimpleEntry(
        date: Date(),
        configuration: ConfigurationIntent(),
        image: UIImage(imageLiteralResourceName: "coffee.png"),
        text: "Mini travel blog"
      ))
      .previewContext(WidgetPreviewContext(family: .systemMedium))
      PhotoWidgetEntryView(entry: SimpleEntry(
        date: Date(),
        configuration: ConfigurationIntent(),
        image: UIImage(imageLiteralResourceName: "coffee.png"),
        text: "Mini travel blog"
      ))
      .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
  }
}
