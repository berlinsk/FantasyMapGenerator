//
//  RoadGenerator.swift
//  FantasyMapGenerator
//
//  Created by Берлинский Ярослав Владленович on 04.08.2025.
//

import UIKit
import CoreGraphics

struct RoadGenerator {
    static func drawRoads(ctx: CGContext, cities: [CGPoint]) {
        ctx.setStrokeColor(UIColor.brown.cgColor)
        ctx.setLineWidth(1)
        for i in 0..<cities.count {
            for j in i + 1..<cities.count where Int.random(in: 0...100) < 30 {
                ctx.beginPath()
                ctx.move(to: cities[i])
                ctx.addLine(to: cities[j])
                ctx.strokePath()
            }
        }
    }
}
