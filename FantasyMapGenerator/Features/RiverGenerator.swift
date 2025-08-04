//
//  RiverGenerator.swift
//  FantasyMapGenerator
//
//  Created by Берлинский Ярослав Владленович on 04.08.2025.
//

import CoreGraphics
import GameplayKit

struct RiverGenerator {
    static func drawRivers(in context: CGContext, with noiseMap: GKNoiseMap, width: Int, height: Int) {
        context.setStrokeColor(UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1).cgColor)
        context.setLineWidth(2)

        for _ in 0..<5 {
            var p = CGPoint(x: Int.random(in: 0..<width), y: 0)
            context.beginPath()
            context.move(to: p)
            for _ in 0..<300 {
                let i = min(max(Int(p.x), 0), width - 1)
                let j = min(max(Int(p.y), 0), height - 1)
                let h = noiseMap.value(at: vector_int2(Int32(i), Int32(j)))
                let dx = noiseMap.value(at: vector_int2(Int32(min(i + 1, width - 1)), Int32(j))) - h
                let dy = noiseMap.value(at: vector_int2(Int32(i), Int32(min(j + 1, height - 1)))) - h
                p.x += CGFloat(-dx * 5)
                p.y += CGFloat(-dy * 5) + 1
                if p.x < 0 || p.x >= CGFloat(width) || p.y >= CGFloat(height) { break }
                context.addLine(to: p)
            }
            context.strokePath()
        }
    }
}
