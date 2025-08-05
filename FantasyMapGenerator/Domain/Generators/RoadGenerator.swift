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
    static func drawRoads(ctx: CGContext, cities: [CGPoint], costMap: TerrainCostMap, noiseMap: GKNoiseMap, size: CGSize, scale: Int) {
        ctx.setStrokeColor(Config.shared.road.strokeColor)
        ctx.setLineWidth(Config.shared.road.lineWidth)
        for i in 0..<cities.count {
            for j in i+1..<cities.count where shouldConnectCities() {
                let points = PathFinder.findPath(from: cities[i], to: cities[j], costMap: costMap, size: size, scale: scale)
                guard points.count > 1 else { continue }
                drawPath(points, in: ctx, noiseMap: noiseMap, size: size, scale: scale)
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
    
    private static func drawSegment(_ from: CGPoint, _ to: CGPoint, isBridge: Bool, ctx: CGContext) {
        if isBridge {
            ctx.setStrokeColor(Config.shared.road.bridgeColor)
            ctx.setLineWidth(Config.shared.road.bridgeLineWidth)
            ctx.setLineDash(phase: 0, lengths: Config.shared.road.bridgeDashPattern)
        } else {
            ctx.setStrokeColor(Config.shared.road.strokeColor)
            ctx.setLineWidth(Config.shared.road.lineWidth)
            ctx.setLineDash(phase: 0, lengths: [])
        }
        ctx.beginPath()
        ctx.move(to: from)
        ctx.addLine(to: to)
        ctx.strokePath()
    }
    
    private static func shouldConnectCities() -> Bool {
        Int.random(in: 0...100) < Config.shared.road.connectionChance
    }

    private static func drawPath(_ path: [CGPoint], in ctx: CGContext, noiseMap: GKNoiseMap, size: CGSize, scale: Int) {
        let segments = zip(path, path.dropFirst())
        for (start, end) in segments {
            let mid = CGPoint(x: (start.x + end.x) / 2, y: (start.y + end.y) / 2)
            let isBridge = isBridge(at: mid, in: noiseMap, mapSize: size, scale: scale)
            drawSegment(start, end, isBridge: isBridge, ctx: ctx)
        }
    }

    private static func isBridge(at point: CGPoint, in noiseMap: GKNoiseMap, mapSize: CGSize, scale: Int) -> Bool {
        let xi = Int32(point.x)
        let yi = Int32(point.y)
        guard xi >= 0,
              yi >= 0,
              xi < Int32(mapSize.width * CGFloat(scale)),
              yi < Int32(mapSize.height * CGFloat(scale)) else {
            return false
        }
        let elevation = noiseMap.value(at: vector_int2(xi, yi))
        return elevation < Config.shared.river.shallowWaterThreshold
    }
}
