//
//  NoiseMapFactory.swift
//  FantasyMapGenerator
//
//  Created by Берлинский Ярослав Владленович on 04.08.2025.
//

import GameplayKit

final class NoiseMapFactory {
    static func create(width: Int, height: Int) -> GKNoiseMap {
        let source = GKPerlinNoiseSource(frequency: 1.5, octaveCount: 6, persistence: 0.5, lacunarity: 2.0, seed: Int32.random(in: .min ... .max))
        let noise = GKNoise(source)
        return GKNoiseMap(noise, size: vector_double2(1, 1), origin: vector_double2(0, 0), sampleCount: vector_int2(Int32(width), Int32(height)), seamless: true)
    }
}
