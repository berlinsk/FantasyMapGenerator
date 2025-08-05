//
//  Config.swift
//  FantasyMapGenerator
//
//  Created by Берлинский Ярослав Владленович on 05.08.2025.
//

import UIKit
import CoreGraphics

final class Config {
    static let shared = Config()

    struct Rendering {
        var scale: Int = 4
    }

    struct City {
        var cityCount: Int = 10
        var cityElevationRange: ClosedRange<Float> = 0.0...0.3
        var buildingCount: Int = 100
        var buildingSizeRange: ClosedRange<Int> = 2...4
        var cityRadiusRange: ClosedRange<Int> = 12...20
        var cityColor: UIColor = UIColor(red: 0.6, green: 0.3, blue: 0.2, alpha: 1)
        var streetColor: UIColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        var streetWidth: CGFloat = 1.0
    }

    struct River {
        var riverCount: Int = 5
        var maxAttemptsToPlaceSource: Int = 100
        var riverLengthRange: ClosedRange<Int> = 200...750
        var jitterRange: ClosedRange<CGFloat> = -0.3...0.3
        var shallowWaterThreshold: Float = 0
        var deepWaterThreshold: Float = -0.05
        var maxForwardSearchSteps: Int = 10
        var deltaSearchSteps: Int = 6
        var baseColor: UIColor = UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1)
        var minWidth: CGFloat = 1.5
        var maxWidth: CGFloat = 6.0
        var fallbackLineWidth: CGFloat = 2.0
    }

    struct Road {
        var connectionChance: Int = 10
        var strokeColor: CGColor = UIColor.brown.cgColor
        var lineWidth: CGFloat = 1.0

        var bridgeColor: CGColor = UIColor.red.cgColor
        var bridgeLineWidth: CGFloat = 2.0
        var bridgeDashPattern: [CGFloat] = [4, 2]
    }

    struct Pathfinding {
        var unreachableCost: Float = .greatestFiniteMagnitude
    }

    struct TerrainCost {
        var deepWater: Float = 1000.0
        var shallowWater: Float = 1.0
        var grassLowland: Float = 1.5
        var grassland: Float = 2.5
        var foothills: Float = 4.0
        var mountains: Float = 8.0
        var defaultCost: Float = 1.0
    }

    var rendering = Rendering()
    var city = City()
    var river = River()
    var road = Road()
    var pathfinding = Pathfinding()
    var terrainCost = TerrainCost()

    private init() {}
}
