//
//  MapGenerator.swift
//  FantasyMapGenerator
//
//  Created by Берлинский Ярослав Владленович on 04.08.2025.
//

import UIKit
import GameplayKit

struct MapGenerator {
    static func generate(size: CGSize, biomes: BiomeSelection = .all) -> UIImage {
        let width = Int(size.width)
        let height = Int(size.height)
        let noiseMap = NoiseMapFactory.create(width: width, height: height, seedOffset: 0)
        let tempMap = NoiseMapFactory.create(width: width, height: height, seedOffset: 1)
        let moistMap = NoiseMapFactory.create(width: width, height: height, seedOffset: 2)

        return UIGraphicsImageRenderer(size: size).image { ctx in
            let context = ctx.cgContext

            for y in 0..<height {
                for x in 0..<width {
                    let v = noiseMap.value(at: vector_int2(Int32(x), Int32(y)))
                    let temp = tempMap.value(at: vector_int2(Int32(x), Int32(y)))
                    let moist = moistMap.value(at: vector_int2(Int32(x), Int32(y)))
                    let type = TerrainType.from(value: Double(v), temperature: Double(temp), moisture: Double(moist), selection: biomes)
                    context.setFillColor(ConfigBiomeColor.current.biomeColorFor(type, selection: biomes).cgColor)
                    context.fill(CGRect(x: x, y: y, width: 1, height: 1))
                }
            }

            RiverGenerator.drawRivers(in: ctx.cgContext, noiseMap: noiseMap, tempMap: tempMap, moistMap: moistMap, width: width, height: height, selection: biomes)
            let cities = CityGenerator.placeCities(in: ctx.cgContext, noiseMap: noiseMap, width: width, height: height)

            let scale = Config.shared.rendering.scale
            let costMap = TerrainCostMap(noiseMap: noiseMap, width: width, height: height, scale: scale)
            RoadGenerator.drawRoads(ctx: context, cities: cities, costMap: costMap, noiseMap: noiseMap, size: CGSize(width: width / scale, height: height / scale), scale: scale)
        }
    }
}
