//
//  PathFinder.swift
//  FantasyMapGenerator
//
//  Created by Берлинский Ярослав Владленович on 04.08.2025.
//

import CoreGraphics
import GameplayKit

struct PathFinder {
    static func findPath(from start: CGPoint, to end: CGPoint, costMap: TerrainCostMap, size: CGSize, scale: Int) -> [CGPoint] {
        let scaledWidth = Int(size.width)
        let scaledHeight = Int(size.height)

        let scaledStart = vector_int2(Int32(start.x) / Int32(scale), Int32(start.y) / Int32(scale))
        let scaledEnd = vector_int2(Int32(end.x) / Int32(scale), Int32(end.y) / Int32(scale))

        var openSet: Set<vector_int2> = [scaledStart]
        var cameFrom: [vector_int2: vector_int2] = [:]

        var gScore: [vector_int2: Float] = [scaledStart: 0]
        var fScore: [vector_int2: Float] = [scaledStart: heuristic(scaledStart, scaledEnd)]

        while !openSet.isEmpty {
            guard let current = openSet.min(by: { fScore[$0, default: Config.shared.pathfinding.unreachableCost] < fScore[$1, default: Config.shared.pathfinding.unreachableCost] }) else { break }

            if current == scaledEnd {
                return reconstructPath(cameFrom: cameFrom, current: current, scale: scale)
            }

            openSet.remove(current)

            for dx in -1...1 {
                for dy in -1...1 {
                    if dx == 0 && dy == 0 { continue }

                    let neighbor = vector_int2(current.x + Int32(dx), current.y + Int32(dy))
                    if neighbor.x < 0 || neighbor.y < 0 || neighbor.x >= Int32(scaledWidth) || neighbor.y >= Int32(scaledHeight) {
                        continue
                    }

                    let baseCost = distance(current, neighbor)
                    let terrainCost = costMap.cost(at: neighbor)
                    let tentativeGScore = gScore[current, default: Config.shared.pathfinding.unreachableCost] + baseCost * terrainCost

                    if tentativeGScore < gScore[neighbor, default: Config.shared.pathfinding.unreachableCost] {
                        cameFrom[neighbor] = current
                        gScore[neighbor] = tentativeGScore
                        fScore[neighbor] = tentativeGScore + heuristic(neighbor, scaledEnd)
                        openSet.insert(neighbor)
                    }
                }
            }
        }

        return []
    }

    private static func heuristic(_ a: vector_int2, _ b: vector_int2) -> Float {
        return distance(a, b)
    }

    private static func distance(_ a: vector_int2, _ b: vector_int2) -> Float {
        let dx = Float(a.x - b.x)
        let dy = Float(a.y - b.y)
        return sqrt(dx * dx + dy * dy)
    }

    private static func reconstructPath(cameFrom: [vector_int2: vector_int2], current: vector_int2, scale: Int) -> [CGPoint] {
        var totalPath = [current]
        var current = current
        while let prev = cameFrom[current] {
            current = prev
            totalPath.append(current)
        }
        return totalPath.reversed().map {
            CGPoint(x: Int($0.x) * scale, y: Int($0.y) * scale)
        }
    }
}
