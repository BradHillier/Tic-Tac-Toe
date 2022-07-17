//
//  Grid.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-07-17.
//

import Foundation

struct Grid<Content> {
    
    private(set) var asLinearArrangement: Array<Cell>
    
    struct Cell: Identifiable {
        /* only grid should need to see the id*/
        private(set) var id: Int
        private(set) var content: Content?
    }
    
    init(size: Int) {
        asLinearArrangement = Array<Cell>()
        for number in 0..<size * size {
            asLinearArrangement.append(Cell(id: number))
        }
    }
}
