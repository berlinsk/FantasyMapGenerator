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

        for _ in 0 ..< 5 {
            var p: CGPoint = .zero
            var attempts = 0
            repeat {
                let x = Int.random(in: 0 ..< width)
                let y = Int.random(in: 0 ..< height)
                let v = noiseMap.value(at: vector_int2(Int32(x), Int32(y)))
                if v > 0 {
                    p = CGPoint(x: x, y: y)
                    break
                }
                attempts += 1
            } while attempts < 100

            var points: [CGPoint] = [p]
            var exitedToWater = false

            for _ in 0 ..< 300 {
                let i = min(max(Int(p.x), 0), width - 1)
                let j = min(max(Int(p.y), 0), height - 1)
                let h = noiseMap.value(at: vector_int2(Int32(i), Int32(j)))
                var steepestDir = CGVector(dx: 0, dy: 0)
                var minH = h

                for dx in -1...1 {
                    for dy in -1...1 {
                        if dx == 0 && dy == 0 { continue }
                        let nx = i + dx
                        let ny = j + dy
                        if nx < 0 || nx >= width || ny < 0 || ny >= height { continue }
                        let nh = noiseMap.value(at: vector_int2(Int32(nx), Int32(ny)))
                        if nh < minH {
                            minH = nh
                            steepestDir = CGVector(dx: dx, dy: dy)
                        }
                    }
                }

                p.x += CGFloat(steepestDir.dx) + CGFloat.random(in: -0.3...0.3)
                p.y += CGFloat(steepestDir.dy) + CGFloat.random(in: -0.3...0.3)
                if p.x < 0 || p.x >= CGFloat(width) || p.y < 0 || p.y >= CGFloat(height) { break }

                let elevation = noiseMap.value(at: vector_int2(Int32(i), Int32(j)))
                if elevation < -0.05 {
                    exitedToWater = true
                    points.append(p)
                    break
                } else if elevation < 0 {
                    var foundWater = false
                    var searchP = p
                    for _ in 0..<10 {
                        let i2 = min(max(Int(searchP.x), 0), width - 1)
                        let j2 = min(max(Int(searchP.y), 0), height - 1)
                        let elev = noiseMap.value(at: vector_int2(Int32(i2), Int32(j2)))
                        if elev < -0.05 {
                            exitedToWater = true
                            p = searchP
                            points.append(p)
                            foundWater = true
                            break
                        }
                        searchP.x += CGFloat(steepestDir.dx)
                        searchP.y += CGFloat(steepestDir.dy)
                    }
                    if foundWater {
                        break
                    } else {
                        break
                    }
                }


                points.append(p)
            }

            if points.count > 1 {
                let riverPath = CGMutablePath()
                riverPath.move(to: points[0])
                for i in stride(from: 1, to: points.count - 1, by: 2) {
                    let mid = CGPoint(
                        x: (points[i].x + points[i + 1].x) / 2,
                        y: (points[i].y + points[i + 1].y) / 2
                    )
                    riverPath.addQuadCurve(to: mid, control: points[i])
                }

                if exitedToWater {
                    for i in 0..<points.count - 1 {
                        let p1 = points[i]
                        let p2 = points[i + 1]
                        let t = CGFloat(i) / CGFloat(points.count - 1)
                        let width = 2 + 6 * t
                        context.setLineWidth(width)
                        context.beginPath()
                        context.move(to: p1)
                        context.addLine(to: p2)
                        context.strokePath()
                    }
                } else {
                    context.setLineWidth(2)
                    context.addPath(riverPath)
                    context.strokePath()
                }
            }
        }
    }
}
