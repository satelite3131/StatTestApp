//  Created by Anton Klimenko

import Foundation

struct MatchInfo: Codable {
    let tournament: Tournament
    let date: String
    let team1, team2: Team
    let calc, hasVideo, live, storage: Bool
    let sub: Bool

    enum CodingKeys: String, CodingKey {
        case tournament, date, team1, team2, calc
        case hasVideo = "has_video"
        case live, storage, sub
    }
}
