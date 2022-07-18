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
        /* only grid should need to see the id and content*/
        private(set) var id: Int
        var content: Content?
        
        func isEmpty() -> Bool {
            return content == nil
        }
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
        var splits = [[Cell]]()
        var currentRow = [Cell]()
        for cell in asLinearArrangement {
            currentRow.append(cell)
            if (cell.id + 1) % size == 0 {
                splits.append(currentRow)
                currentRow.removeAll()
            }
        }
        return splits
    }
    
    func columns() -> [Array<Grid<Content>.Cell>] {
        var splits = [[Cell]]()
        var currentColumn = [Cell]()
        
        for column in 0..<size {
            var cell = column
            while cell < size * size {
                currentColumn.append(asLinearArrangement[cell])
                cell += size
            }
            splits.append(currentColumn)
            currentColumn.removeAll()
        }
        return splits
    }
    
    mutating func changeContent(of cell: Cell, to content: Content?) {
        asLinearArrangement[cell.id].content = content
    }
    
    var description: String {
        var des = ""
        for row in rows() {
            des += String(repeating: "-", count: size * 4 + 1)
            des += "\n"
            for cell in row {
                des += "| \(String(describing: cell.content)) "
            }
            des += "|\n"
        }
        des += String(repeating: "-", count: size * 4 + 1)
        return des
    }
}
