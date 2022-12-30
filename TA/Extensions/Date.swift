//
//  Date.swift
//  Fitsentive
//
//  Created by Applify  on 10/08/21.
//

import Foundation

extension Date {
  var stringValue: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    return dateFormatter.string(from: self)
  }
  
  func getDateFromNow(whenDifferenceInDays days: Int) -> Date? {
    let calendar = Calendar.current
    
    guard let date = calendar.date(byAdding: .day, value: -(days - 1), to: self) else {
      return nil
    }
    return calendar.startOfDay(for: date)
  }
}


class DateHelper {
    class func convertDateString(dateString : String!, fromFormat sourceFormat : String!, toFormat desFormat : String!) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = sourceFormat
        let date = dateFormatter.date(from: dateString)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = desFormat
        return dateFormatter.string(from: date!)
    }
    
    class func differenceInDays(fromDate:String, toDate:String) -> String{
        
        let dateFormt = DateFormatter()
//        dateFormt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//        dateFormt.locale = .current
        dateFormt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormt.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormt.locale = .current
        let previousDate = Date().addingTimeInterval(-55000) //dateFormt.date(from: fromDate)
        //let previousDate = Date() //dateFormt.date(from: fromDate)
        let now = dateFormt.date(from: toDate) //1dateFormt.date(from: toDate)

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.weekOfMonth, .day]
        formatter.maximumUnitCount = 2
        let string = formatter.string(from: previousDate, to: now!)
        if string?.contains(find: "-") == true {
            return ""
        } else {
            return "\(string?.uppercased() ?? "")  LEFT"
        }
    }
}


extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
