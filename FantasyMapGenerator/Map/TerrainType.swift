//
//  TerrainType.swift
//  FantasyMapGenerator
//
//  Created by Берлинский Ярослав Владленович on 04.08.2025.
//

import UIKit

enum TerrainType {
    case deepWater(Double)
    case shallowWater
    case beach
    case forest
    case hills
    case mountains
    case unknown

    static func from(value: Double, modifier: Double) -> TerrainType {
        switch value {
        case ..<(-0.05):
            let depth = min(max((-value - 0.05) / 0.95, 0), 1)
            return .deepWater(depth)
        case -0.05..<0:
            return .shallowWater
        case 0..<0.1:
            return .beach
        case 0.1..<0.4:
            return modifier > 0.2 ? .forest : .beach
        case 0.4...:
            return .mountains
        default:
            return .unknown
        }
    }

    var color: UIColor {
        switch self {
        case .deepWater(let depth):
            return UIColor(red: 0, green: 0.4 + CGFloat(depth) * 0.3, blue: 0.8, alpha: 1)
        case .shallowWater:
            return UIColor(red: 0.9, green: 0.9, blue: 0.6, alpha: 1)
        case .beach:
            return UIColor(red: 0.9, green: 0.9, blue: 0.6, alpha: 1)
        case .forest:
            return UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1)
        case .hills:
            return UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        case .mountains:
            return UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        case .unknown:
            return .black
        }
    }
}
