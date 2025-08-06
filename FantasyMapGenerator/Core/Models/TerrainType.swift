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

    static func from(value: Double, temperature: Double, moisture: Double, selection: BiomeSelection) -> TerrainType {
        if value < -0.05 {
            let depth = min(max((-value - 0.05) / 0.95, 0), 1)
            return .deepWater(depth)
        } else if value < 0 {
            return .shallowWater
        }

        let biome: Biome? = {
            switch selection {
            case .single(let b):
                return b
            case .include(let list):
                if temperature > 0.7 && moisture < 0.3 {
                    return list.first(where: { $0 == .desert })
                } else if temperature < 0.3 && moisture > 0.5 {
                    return list.first(where: { $0 == .tundra })
                } else if moisture > 0.6 {
                    return list.first(where: { $0 == .jungle }) ?? list.first(where: { $0 == .forest })
                } else if moisture > 0.4 {
                    return list.first(where: { $0 == .savanna }) ?? list.first
                } else {
                    return list.first
                }
            case .all:
                return nil
            }
        }()

        switch biome {
        case .desert:
            return temperature > 0.5 && moisture < 0.3 ? .grassland : .foothills
        case .tundra:
            return temperature < 0.3 ? .grassLowland : .mountains
        case .taiga:
            return temperature < 0.5 && moisture > 0.4 ? .grassland : .foothills
        case .jungle:
            return moisture > 0.6 && temperature > 0.6 ? .grassland : .grassLowland
        case .forest:
            return moisture > 0.5 ? .grassland : .grassLowland
        case .savanna:
            return temperature > 0.5 && moisture > 0.3 ? .grassland : .foothills
        case nil:
            if temperature > 0.7 {
                if moisture > 0.5 {
                    return .grassland
                } else {
                    return .foothills
                }
            } else if temperature > 0.4 {
                return .grassLowland
            } else {
                return .mountains
            }
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
    
    var defaultColor: UIColor {
        switch self {
        case .deepWater(let d):
            let r = CGFloat(0.0)
            let g = CGFloat(0.4 * (1.0 - d) + 0.1 * d)
            let b = CGFloat(0.7 + 0.3 * d)
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
