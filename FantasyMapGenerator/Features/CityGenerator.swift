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

        for _ in 0 ..< 10 {
            var ok = false
            var cx = 0, cy = 0
            while !ok {
                cx = Int.random(in: 0 ..< width)
                cy = Int.random(in: 0 ..< height)
                let v = noiseMap.value(at: vector_int2(Int32(cx), Int32(cy)))
                ok = v > 0 && v < 0.3
            }

            let cityCenter = CGPoint(x: cx, y: cy)
            cities.append(cityCenter)

            let cityRadius = Int.random(in: 12...20)
            let cityColor = UIColor(red: 0.6, green: 0.3, blue: 0.2, alpha: 1)
            let streetColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)

            var buildingCenters: [CGPoint] = []

            for _ in 0 ..< 100 {
                let angle = Double.random(in: 0..<2 * .pi)
                let radius = Double.random(in: 0..<Double(cityRadius)) * pow(Double.random(in: 0.5...1), 2)
                let dx = Int(radius * cos(angle))
                let dy = Int(radius * sin(angle))
                let px = cx + dx
                let py = cy + dy
                if px < 0 || px >= width || py < 0 || py >= height { continue }
                buildingCenters.append(CGPoint(x: px, y: py))
            }

            for center in buildingCenters {
                let w = Int.random(in: 2...4)
                let h = Int.random(in: 2...4)
                for dx in -w/2...w/2 {
                    for dy in -h/2...h/2 {
                        let x = Int(center.x) + dx
                        let y = Int(center.y) + dy
                        if x < 0 || x >= width || y < 0 || y >= height { continue }
                        context.setFillColor(cityColor.cgColor)
                        context.fill(CGRect(x: x, y: y, width: 1, height: 1))
                    }
                }
            }

            for i in 0..<buildingCenters.count {
                let a = buildingCenters[i]
                let b = buildingCenters.min(by: { $0 == a ? false : distance($0, a) < distance($1, a) })!
                let path = CGMutablePath()
                path.move(to: a)
                path.addLine(to: b)
                context.addPath(path)
                context.setStrokeColor(streetColor.cgColor)
                context.setLineWidth(1)
                context.strokePath()
            }
        }

        return cities
    }

    private static func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let dx = a.x - b.x
        let dy = a.y - b.y
        return sqrt(dx * dx + dy * dy)
    }
}
