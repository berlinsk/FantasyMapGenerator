//
//  ConfigBiomeColor.swift
//  FantasyMapGenerator
//
//  Created by Берлинский Ярослав Владленович on 06.08.2025.
//

import UIKit

final class ConfigBiomeColor {
    static var current = ConfigBiomeColor()
    
    func biomeColorFor(_ type: TerrainType, selection: BiomeSelection) -> UIColor {
        switch selection {
        case .single(let biome):
            return color(type: type, biome: biome)
        case .include(let biomes):
            if let biome = biomes.first {
                return color(type: type, biome: biome)
            } else {
                return type.defaultColor
            }
        case .all:
            return type.defaultColor
        }
    }

    private func color(type: TerrainType, biome: Biome) -> UIColor {
        switch biome {
        case .desert:
            switch type {
            case .grassLowland, .grassland:
                return UIColor(red: 0.9, green: 0.8, blue: 0.4, alpha: 1)
            case .foothills:
                return UIColor(red: 0.8, green: 0.7, blue: 0.5, alpha: 1)
            default:
                return type.defaultColor
            }
        case .forest:
            switch type {
            case .grassLowland, .grassland:
                return UIColor(red: 0.2, green: 0.5, blue: 0.2, alpha: 1)
            default:
                return type.defaultColor
            }
        case .tundra:
            switch type {
            case .grassLowland, .grassland:
                return UIColor(red: 0.7, green: 0.9, blue: 0.7, alpha: 1)
            default:
                return type.defaultColor
            }
        case .taiga:
            switch type {
            case .grassLowland, .grassland:
                return UIColor(red: 0.3, green: 0.5, blue: 0.3, alpha: 1)
            default:
                return type.defaultColor
            }
        case .savanna:
            switch type {
            case .grassLowland, .grassland:
                return UIColor(red: 0.9, green: 0.7, blue: 0.3, alpha: 1)
            default:
                return type.defaultColor
            }
        case .jungle:
            switch type {
            case .grassLowland, .grassland:
                return UIColor(red: 0.1, green: 0.6, blue: 0.2, alpha: 1)
            default:
                return type.defaultColor
            }
        }
    }
}
