//
//  DateSection.swift
//  Tranzlator
//
//  Created by Camille Khubbetdinov on 714..2021.
//

import Foundation

struct DateSection: Hashable {
    let dateFormatter = DateFormatter()
    
    var date: Date
    var dateRepr: String = ""
    
    private func formDateRepresentation(from date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Today"
        }
        if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        }
        dateFormatter.dateFormat = "yyyy"
        if dateFormatter.string(from: date) == dateFormatter.string(from: Date(timeIntervalSinceNow: 0)) {
            dateFormatter.dateFormat = "MM dd"
            return dateFormatter.string(from: date)
        }
        dateFormatter.dateFormat = "yyyy, MM dd"
        return dateFormatter.string(from: date)
    }
    
    init(date: Date) {
        self.date = date
        self.dateRepr = formDateRepresentation(from: date)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(dateRepr)
    }
    
    static func == (lhs: DateSection, rhs: DateSection) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
