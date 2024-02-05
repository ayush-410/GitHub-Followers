//
//  Date + Ext.swift
//  GitHubFollowers_Project
//
//  Created by Ayush Singh on 11/01/24.
//

import Foundation

extension Date {
    
//    func convertToMonthYear() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM yyyy"
//
//        return dateFormatter.string(from: self)
//    }
    
    
    func convertToMonthYear() -> String {
        return formatted(.dateTime.month().year())
    }
    
}
