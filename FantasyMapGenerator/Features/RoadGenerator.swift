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
    static func drawRoads(ctx: CGContext, cities: [CGPoint], noiseMap: GKNoiseMap, size: CGSize) {
        ctx.setStrokeColor(UIColor.brown.cgColor)
        ctx.setLineWidth(1)
        for i in 0..<cities.count {
            for j in i+1..<cities.count where Int.random(in: 0...100) < 30 {
                let path = curvedPathAvoidingWater(from: cities[i], to: cities[j], noiseMap: noiseMap, size: size)
                ctx.addPath(path)
                ctx.strokePath()
            }
        }
    }

    static func curvedPathAvoidingWater(from start: CGPoint, to end: CGPoint, noiseMap: GKNoiseMap, size: CGSize) -> CGPath {
        let path = CGMutablePath()
        path.move(to: start)

        let steps = 20
        for i in 1..<steps {
            let t = CGFloat(i) / CGFloat(steps)
            let x = start.x + (end.x - start.x) * t + CGFloat.random(in: -5...5)
            let y = start.y + (end.y - start.y) * t + CGFloat.random(in: -5...5)
            let ix = Int(min(max(x, 0), size.width - 1))
            let iy = Int(min(max(y, 0), size.height - 1))
            if noiseMap.value(at: vector_int2(Int32(ix), Int32(iy))) > 0 {
                path.addLine(to: CGPoint(x: x, y: y))
            } else {
                return CGMutablePath()
            }
        }

        path.addLine(to: end)
        return path
    }
}
