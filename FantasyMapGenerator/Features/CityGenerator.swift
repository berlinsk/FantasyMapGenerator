//
//  CityGenerator.swift
//  FantasyMapGenerator
//
//  Created by Берлинский Ярослав Владленович on 04.08.2025.
//

import UIKit
import GameplayKit

struct CityGenerator {
    static func placeCities(in context: CGContext, noiseMap: GKNoiseMap, width: Int, height: Int) -> [CGPoint] {
        var cities: [CGPoint] = []

        for _ in 0..<10 {
            var ok = false
            var cx = 0, cy = 0
            while !ok {
                cx = Int.random(in: 0..<width)
                cy = Int.random(in: 0..<height)
                let v = noiseMap.value(at: vector_int2(Int32(cx), Int32(cy)))
                ok = v > 0 && v < 0.3
            }

            cities.append(CGPoint(x: cx, y: cy))
            context.setFillColor(UIColor(red: 0.7, green: 0.3, blue: 0.2, alpha: 1).cgColor)
            context.fillEllipse(in: CGRect(x: cx - 3, y: cy - 3, width: 6, height: 6))
        }

        return cities
    }
}
