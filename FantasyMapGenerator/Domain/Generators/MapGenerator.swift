//
//  MapGenerator.swift
//  FantasyMapGenerator
//
//  Created by Берлинский Ярослав Владленович on 04.08.2025.
//

import UIKit
import GameplayKit

struct MapGenerator {
    static func generate(size: CGSize) -> UIImage {
        let width = Int(size.width)
        let height = Int(size.height)
        let noiseMap = NoiseMapFactory.create(width: width, height: height)

        return UIGraphicsImageRenderer(size: size).image { ctx in
            let context = ctx.cgContext

            for y in 0..<height {
                for x in 0..<width {
                    let v = noiseMap.value(at: vector_int2(Int32(x), Int32(y)))
                    let type = TerrainType.from(value: Double(v))
                    context.setFillColor(type.color.cgColor)
                    context.fill(CGRect(x: x, y: y, width: 1, height: 1))
                }
            }

            RiverGenerator.drawRivers(in: ctx.cgContext, with: noiseMap, width: width, height: height)

            let cities = CityGenerator.placeCities(in: ctx.cgContext, noiseMap: noiseMap, width: width, height: height)

            let scale = Config.shared.rendering.scale
            let costMap = TerrainCostMap(noiseMap: noiseMap, width: width, height: height, scale: scale)
            RoadGenerator.drawRoads(ctx: context, cities: cities, costMap: costMap, size: CGSize(width: width / scale, height: height / scale), scale: scale)
        }
    }
}
