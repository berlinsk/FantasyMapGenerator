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
            return .greatestFiniteMagnitude
        }
        return costMap[Int(point.y)][Int(point.x)]
    }

    private static func cost(for elevation: Float) -> Float {
        switch elevation {
        case ..<0:
            return 1000.0
        case 0..<0.2:
            return 1.0
        case 0.2..<0.4:
            return 1.5
        case 0.4..<0.6:
            return 2.5
        case 0.6..<0.8:
            return 4.0
        case 0.8...:
            return 8.0
        default:
            return 1.0
        }
    }
}
