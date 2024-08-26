//
//  Date+Extension.swift
//  NASAClient
//
//  Created by Bogdan Petkanych on 23.08.2024.
//

import Foundation

extension Date {
  
  var startDay: Date {
    let calendar = Calendar(identifier: .gregorian)
    
    return calendar.startOfDay(for: self)
  }
  
  var endDay: Date {
    let calendar = Calendar(identifier: .gregorian)
    
    return calendar.date(byAdding: DateComponents(day: 1, second: -1), to: startDay) ?? .now
  }
  
  func toString(format: String = "yyyy-MM-dd") -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.dateFormat = format
    return formatter.string(from: self)
  }
  
  static func date(year: Int, month: Int, day: Int) -> Date? {
    let calendar = NSCalendar(calendarIdentifier: .gregorian)
    
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    dateComponents.day = day

    return calendar?.date(from: dateComponents)
  }
}
