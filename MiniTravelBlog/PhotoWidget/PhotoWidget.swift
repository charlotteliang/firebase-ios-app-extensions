//
//  Widget.swift
//  Widget
//
//  Created by Charlotte Liang on 3/17/22.
//

import WidgetKit
import SwiftUI
import Intents
import FirebaseAuth
import FirebaseCore
import FirebaseStorage

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
      SimpleEntry(date: Date(), configuration: ConfigurationIntent(), image:UIImage(imageLiteralResourceName: "coffee.png"))
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
      getImage(imageName: "currentImage.JPG") { image in
        let entry = SimpleEntry(date: Date(), configuration: configuration, image: image)
        completion(entry)
      }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
      getImage(imageName: "currentImage.JPG") { image in
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
          let entry = SimpleEntry(date: entryDate, configuration: configuration, image: image)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
      }
    }

  func getImage(imageName: String, completion: @escaping (UIImage) ->()) {
      FirebaseApp.configure()
//    do {
//      try Auth.auth().useUserAccessGroup("EQHXZ8M8AV.group.com.google.firebase.extensions")
//    } catch let error as NSError {
//      print("Error changing user access group: %@", error)
//    }
      let ref = Storage.storage().reference().child(imageName)
      ref.getData(maxSize: 20 * 1024 * 2048) { (data: Data?, error: Error?) in
        guard let data = data, error == nil else {return }
          let image = UIImage(data:data)!
          completion(image)
        }
    }
  
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    var image : UIImage = UIImage()

}

struct PhotoWidgetEntryView : View {
  @Environment(\.widgetFamily) var family: WidgetFamily
      var entry: Provider.Entry
      var body: some View {
        VStack{
          switch family {
            case .systemSmall:
              Text(entry.date, style: .time)
                .bold()
              ZStack {
                Image(uiImage: entry.image).resizable()
              }
            case .systemMedium:
              HStack {
                Text(entry.date, style: .time)
                  .bold()
                Image(uiImage: entry.image).resizable()
              }
            case .systemLarge:
              VStack {
                Text(entry.date, style: .time)
                  .bold()
                Image(uiImage: entry.image).resizable()
                Text("Have a good day!")
                  .bold()
                  .foregroundColor(.blue)
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
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            PhotoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct PhotoWidget_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        PhotoWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), image: UIImage(imageLiteralResourceName: "coffee.png")))
                  .previewContext(WidgetPreviewContext(family: .systemSmall))
        PhotoWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), image: UIImage(imageLiteralResourceName: "coffee.png")))
                  .previewContext(WidgetPreviewContext(family: .systemMedium))
        PhotoWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), image: UIImage(imageLiteralResourceName: "coffee.png")))
                  .previewContext(WidgetPreviewContext(family: .systemLarge))
            }
    }
}
