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
    case grassLowland
    case grassland
    case foothills
    case mountains
    case peaks
    case unknown

    static func from(value: Double) -> TerrainType {
        switch value {
        case ..<(-0.05):
            let depth = min(max((-value - 0.05) / 0.95, 0), 1)
            return .deepWater(depth)
        case -0.05..<0:
            return .shallowWater
        case 0..<0.2:
            return .grassLowland
        case 0.2..<0.4:
            return .grassland
        case 0.4..<0.6:
            return .foothills
        case 0.6..<0.8:
            return .mountains
        case 0.8...:
            return .peaks
        default:
            return .unknown
        }
    }

    var color: UIColor {
        switch self {
        case .deepWater(let depth):
            let r = CGFloat(0.0)
            let g = CGFloat(0.4 * (1.0 - depth) + 0.1 * depth)
            let b = CGFloat(0.7 + 0.3 * depth)
            return UIColor(red: r, green: g, blue: b, alpha: 1)
        case .shallowWater:
            return UIColor(red: 0.9, green: 0.9, blue: 0.6, alpha: 1)
        case .grassLowland:
            return UIColor(red: 0.3, green: 0.8, blue: 0.3, alpha: 1)
        case .grassland:
            return UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1)
        case .foothills:
            return UIColor(red: 0.6, green: 0.5, blue: 0.2, alpha: 1)
        case .mountains:
            return UIColor(red: 0.5, green: 0.4, blue: 0.3, alpha: 1)
        case .peaks:
            return UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        case .unknown:
            return .black
        }
    }
}
