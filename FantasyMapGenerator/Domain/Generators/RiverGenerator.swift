//
//  RiverGenerator.swift
//  FantasyMapGenerator
//
//  Created by Берлинский Ярослав Владленович on 04.08.2025.
//

import CoreGraphics
import GameplayKit

struct RiverGenerator {
    static func drawRivers(in context: CGContext, noiseMap: GKNoiseMap, tempMap: GKNoiseMap, moistMap: GKNoiseMap, width: Int, height: Int, selection: BiomeSelection) {
        context.setStrokeColor(UIColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1).cgColor)

        for _ in 0 ..< Config.shared.river.riverCount {
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
            } while attempts < Config.shared.river.maxAttemptsToPlaceSource

            var points: [CGPoint] = [p]
            var exitedToWater = false

            let maxLength = Int.random(in: Config.shared.river.riverLengthRange)

            for _ in 0..<maxLength {
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

                p.x += CGFloat(steepestDir.dx) + CGFloat.random(in: Config.shared.river.jitterRange)
                p.y += CGFloat(steepestDir.dy) + CGFloat.random(in: Config.shared.river.jitterRange)
                if p.x < 0 || p.x >= CGFloat(width) || p.y < 0 || p.y >= CGFloat(height) { break }

                let elevation = noiseMap.value(at: vector_int2(Int32(i), Int32(j)))
                if elevation < Config.shared.river.deepWaterThreshold {
                    exitedToWater = true

                    for k in 0..<Config.shared.river.deltaSearchSteps {
                        let px = Int(p.x) + Int(CGFloat(steepestDir.dx) * CGFloat(k))
                        let py = Int(p.y) + Int(CGFloat(steepestDir.dy) * CGFloat(k))
                        if px >= 0 && px < width && py >= 0 && py < height {
                            let val = noiseMap.value(at: vector_int2(Int32(px), Int32(py)))
                            if val < Config.shared.river.deepWaterThreshold {
                                points.append(CGPoint(x: px, y: py))
                                break
                            }
                        }
                    }

                    break
                } else if elevation < Config.shared.river.shallowWaterThreshold {
                    var foundWater = false
                    var searchP = p
                    for _ in 0..<Config.shared.river.maxForwardSearchSteps {
                        let i2 = min(max(Int(searchP.x), 0), width - 1)
                        let j2 = min(max(Int(searchP.y), 0), height - 1)
                        let elev = noiseMap.value(at: vector_int2(Int32(i2), Int32(j2)))
                        if elev < Config.shared.river.deepWaterThreshold {
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
                    let lastPoint = points.last!
                    let i = min(max(Int(lastPoint.x), 0), width - 1)
                    let j = min(max(Int(lastPoint.y), 0), height - 1)
                    let finalElevation = Double(noiseMap.value(at: vector_int2(Int32(i), Int32(j))))
                    let temp = Double(tempMap.value(at: vector_int2(Int32(i), Int32(j))))
                    let moist = Double(moistMap.value(at: vector_int2(Int32(i), Int32(j))))
                    let type = TerrainType.from(value: finalElevation, temperature: temp, moisture: moist, selection: selection)
                    let waterColor = ConfigBiomeColor.current.biomeColorFor(type, selection: selection)
                    let baseColor = Config.shared.river.baseColor

                    for i in 0..<points.count - 1 {
                        let p1 = points[i]
                        let p2 = points[i + 1]
                        let t = CGFloat(i) / CGFloat(points.count - 1)

                        let blendedColor = ColorUtils.interpolate(from: baseColor, to: waterColor, t: t)
                        context.setStrokeColor(blendedColor.cgColor)

                        let thickness = Config.shared.river.minWidth + (Config.shared.river.maxWidth - Config.shared.river.minWidth) * t
                        context.setLineWidth(thickness)
                        context.beginPath()
                        context.move(to: p1)
                        context.addLine(to: p2)
                        context.strokePath()
                    }
                } else {
                    context.setLineWidth(Config.shared.river.fallbackLineWidth)
                    context.addPath(riverPath)
                    context.strokePath()
                }
            }
        }
    }
}
