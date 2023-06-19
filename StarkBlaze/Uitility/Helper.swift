//
//  Helper.swift
//  StarkBlaze
//
//  Created by Daniel Senga on 2023/06/19.
//

import Foundation
import UIKit


// Helper class where helpful small functions are stored for usage throughout the app.
class Helper {
    static let shared = Helper()
    
    // Generate random colours with faded alphas
    func generateRandomColor() -> UIColor {
        let redValue = CGFloat(drand48())
        let greenValue = CGFloat(drand48())
        let blueValue = CGFloat(drand48())
        return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 0.5)
    }
    
    // Date formatter for the released date, converts date to readable format
     func formatDate(date: String) -> String {
        let inputDateString = date

        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "MM/dd/yyyy"

        if let date = inputDateFormatter.date(from: inputDateString) {
            let formattedDateString = outputDateFormatter.string(from: date)
            return formattedDateString
        }

        return "" // Return an empty string if the date conversion fails
    }
    
    
    // Funciton to make the text bold
    func makeBold(_ boldText: String, _ normalText: String) -> NSAttributedString {
        let attrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        let boldString = NSMutableAttributedString(string: "\(boldText) ", attributes: attrs)
        let normalString = NSMutableAttributedString(string: normalText)
        
        boldString.append(normalString)
        return boldString
    }

}
