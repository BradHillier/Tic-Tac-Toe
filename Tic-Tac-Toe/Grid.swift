//
//  Grid.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-07-17.
//

import Foundation

struct Grid<Content>: CustomStringConvertible {
    
    private(set) var asLinearArrangement: Array<Cell>
    private let size: Int
    
    struct Cell: Identifiable {
        /* only grid should need to see the id*/
        private(set) var id: Int
        private(set) var content: Content?
    }
    
    // Todo: add ability to supply default content for cells
    init(size: Int) {
        self.size = size
        asLinearArrangement = Array<Cell>()
        for number in 0..<size * size {
            asLinearArrangement.append(Cell(id: number))
        }
    }
    
    func isFull() -> Bool {
        return asLinearArrangement.allSatisfy({ $0.content != nil })
    }

    func isEmpty() -> Bool {
        return asLinearArrangement.allSatisfy({ $0.content == nil })
    }
    
    func rows() -> [Array<Grid<Content>.Cell>] {
        var split = [[Cell]]()
        var currentRow = [Cell]()
        for cell in asLinearArrangement {
            currentRow.append(cell)
            if (cell.id + 1) % size == 0 {
                split.append(currentRow)
                currentRow.removeAll()
            }
        }
        return split
    }
    
    var description: String {
        var des = ""
        for row in rows() {
            des += String(repeating: "-", count: size * 4 + 1)
            des += "\n"
            for cell in row {
                des += "| \(cell.id) "
            }
            des += "|\n"
        }
        des += String(repeating: "-", count: size * 4 + 1)
        return des
    }
}
