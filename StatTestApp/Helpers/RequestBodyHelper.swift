//  Created by Anton Klimenko

import Foundation

struct RequestBodyMatchInfo: Encodable {
    let proc: String
    let params: [String: Int]
}

struct RequestBodyMatchLinks: Encodable {
    let match_id: Int
    let sport_id: Int = 1
}
