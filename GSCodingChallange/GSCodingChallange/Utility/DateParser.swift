//
//  DateParser.swift
//  GSCodingChallange
//
//  Created by Jignesh Gajjar on 26/03/22.
//

import Foundation

class DateParser {
    private var dateFormatter: DateFormatter!
    private let DEFAULT_FORMAT = "yyyy-MM-dd"
    
    init() {
        dateFormatter = DateFormatter()
        setDefaultFormat()
    }
    
    func parseToString(date: Date) -> String {
        dateFormatter.string(from: date)
    }
    
    private func setDefaultFormat() {
        dateFormatter.dateFormat = DEFAULT_FORMAT
    }
}
