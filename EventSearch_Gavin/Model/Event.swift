//
//  Event.swift
//  EventSearch_Gavin
//
//  Created by Gavin Woffinden on 7/31/21.
//

import Foundation
import UIKit

struct NameAndDate: Codable {
    let events: [NemDet]
    
    struct NemDet: Codable {
        let name: String
        let date: String
        
        enum CodingKeys: String, CodingKey {
            case name = "short_title"
            case date = "datetime_local"
        }
    }
}
struct Place: Codable {
    let events: [TopLevel]
    
    struct TopLevel: Codable {
        let venue: SecondLevel
        
        struct SecondLevel: Codable {
            let location: String
            
            enum CodingKeys: String, CodingKey {
                case location = "display_location"
            }
        }
    }
}
struct Image: Codable {
    let events: [TopLevel]
    
    struct TopLevel: Codable {
        let performers: [SecondLevel]
        
        struct SecondLevel: Codable {
            let image: String
            
            enum CodingKeys: String, CodingKey {
                case image = "image"
            }
        }
    }
}

