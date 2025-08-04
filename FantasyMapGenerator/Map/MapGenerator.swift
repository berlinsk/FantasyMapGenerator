//
//  MapGenerator.swift
//  FantasyMapGenerator
//
//  Created by Берлинский Ярослав Владленович on 04.08.2025.
//

import UIKit
import GameplayKit

final class MapGenerator {
    static func generate(size: CGSize) -> UIImage {
        let width = Int(size.width)
        let height = Int(size.height)
        let noiseMap = NoiseMapFactory.create(width: width, height: height)

        return UIGraphicsImageRenderer(size: size).image { ctx in
            let context = ctx.cgContext

            for y in 0..<height {
                for x in 0..<width {
                    let value = noiseMap.value(at: vector_int2(Int32(x), Int32(y)))
                    let m = noiseMap.value(at: vector_int2(Int32((x + 123) % width), Int32((y + 456) % height)))
                    let type = TerrainType.from(value: Double(value), modifier: Double(m))
                    context.setFillColor(type.color.cgColor)
                    context.fill(CGRect(x: x, y: y, width: 1, height: 1))
                }
            }

            RiverGenerator.drawRivers(in: context, with: noiseMap, width: width, height: height)

            let cities = CityGenerator.placeCities(in: context, noiseMap: noiseMap, width: width, height: height)

            RoadGenerator.drawRoads(ctx: context, cities: cities)
        }
    }
}
