//
//  BiomeSelection.swift
//  FantasyMapGenerator
//
//  Created by Берлинский Ярослав Владленович on 06.08.2025.
//

import Foundation

enum BiomeSelection {
    case single(Biome)
    case include([Biome])
    case all
}
