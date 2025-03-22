//
//  Date + Extension.swift
//  Magenta
//
//  Created by Sarah Clark on 3/20/25.
//

import Foundation

extension Date {
    func startOfDay() -> Date {
        Calendar.current.startOfDay(for: self)
    }

}
