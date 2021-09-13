//  Created by Anton Klimenko

import Foundation

struct Tournament: Codable {
    let id: Int
    let nameEng, nameRus: String

    enum CodingKeys: String, CodingKey {
        case id
        case nameEng = "name_eng"
        case nameRus = "name_rus"
    }
}
