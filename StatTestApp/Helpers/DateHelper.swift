//  Created by Anton Klimenko

import Foundation

func convertDate(date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
    
    let date = dateFormatter.date(from: date)
    let newDateFormatter = DateFormatter()
    newDateFormatter.dateFormat = "dd.MM.yyyy"
    
    return newDateFormatter.string(from: date!)
}
