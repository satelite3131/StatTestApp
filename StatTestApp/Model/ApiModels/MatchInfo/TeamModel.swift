//  Created by Anton Klimenko

import Foundation

struct Team: Codable {
    let id: Int
    let nameEng, nameRus, abbrevEng, abbrevRus: String
    let score: Int

    enum CodingKeys: String, CodingKey {
        case id
        case nameEng = "name_eng"
        case nameRus = "name_rus"
        case abbrevEng = "abbrev_eng"
        case abbrevRus = "abbrev_rus"
        case score
    }
}
