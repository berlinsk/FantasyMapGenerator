//
//  RoadGenerator.swift
//  FantasyMapGenerator
//
//  Created by Берлинский Ярослав Владленович on 04.08.2025.
//

import UIKit
import CoreGraphics
import GameplayKit

struct RoadGenerator {
    static func drawRoads(ctx: CGContext, cities: [CGPoint], costMap: TerrainCostMap, size: CGSize, scale: Int) {
        ctx.setStrokeColor(Config.shared.road.strokeColor)
        ctx.setLineWidth(Config.shared.road.lineWidth)
        for i in 0..<cities.count {
            for j in i+1..<cities.count where Int.random(in: 0...100) < Config.shared.road.connectionChance {
                let points = PathFinder.findPath(from: cities[i], to: cities[j], costMap: costMap, size: size, scale: scale)
                guard points.count > 1 else { continue }

                let path = smoothedPath(from: points)
                ctx.addPath(path)
                ctx.strokePath()
            }
        }
    }

    private static func smoothedPath(from points: [CGPoint]) -> CGPath {
        let path = CGMutablePath()
        path.move(to: points[0])
        for i in 1..<points.count - 1 {
            let prev = points[i - 1]
            let curr = points[i]
            let next = points[i + 1]
            let mid1 = CGPoint(x: (prev.x + curr.x) / 2, y: (prev.y + curr.y) / 2)
            let mid2 = CGPoint(x: (curr.x + next.x) / 2, y: (curr.y + next.y) / 2)
            path.addQuadCurve(to: mid2, control: curr)
        }
        path.addLine(to: points.last!)
        return path
    }
}
