//
//  TerrainCostMap.swift
//  FantasyMapGenerator
//
//  Created by Берлинский Ярослав Владленович on 04.08.2025.
//

import GameplayKit
import CoreGraphics

final class TerrainCostMap {
    private let width: Int
    private let height: Int
    private let costMap: [[Float]]

    init(noiseMap: GKNoiseMap, width: Int, height: Int, scale: Int) {
        self.width = width
        self.height = height

        let scaledWidth = width / scale
        let scaledHeight = height / scale

        var map: [[Float]] = Array(
            repeating: Array(repeating: 1.0, count: scaledWidth),
            count: scaledHeight
        )

        for y in 0..<scaledHeight {
            for x in 0..<scaledWidth {
                let nx = x * scale
                let ny = y * scale
                let value = noiseMap.value(at: vector_int2(Int32(nx), Int32(ny)))
                map[y][x] = TerrainCostMap.cost(for: value)
            }
        }

        self.costMap = map
    }

    func cost(at point: vector_int2) -> Float {
        guard point.x >= 0, point.y >= 0,
              point.y < costMap.count,
              point.x < costMap[0].count else {
            return Config.shared.pathfinding.unreachableCost
        }
        return costMap[Int(point.y)][Int(point.x)]
    }

    private static func cost(for elevation: Float) -> Float {
        switch elevation {
        case ..<0:
            return Config.shared.terrainCost.deepWater
        case 0..<0.2:
            return Config.shared.terrainCost.shallowWater
        case 0.2..<0.4:
            return Config.shared.terrainCost.grassLowland
        case 0.4..<0.6:
            return Config.shared.terrainCost.grassland
        case 0.6..<0.8:
            return Config.shared.terrainCost.foothills
        case 0.8...:
            return Config.shared.terrainCost.mountains
        default:
            return Config.shared.terrainCost.defaultCost
        }
    }
}
