//
//  Grid.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-07-17.
//

import Foundation

struct Grid<Content> {
    
    
    // An array of the grids cell s
    private(set) var cells: Array<Cell>
    private let size: Int
    
    struct Cell: Identifiable {
        /* only grid should need to see the id and content*/
        private(set) var id: Int
        private(set) var row: Int
        private(set) var column: Int
        
        var content: Content?
        
        func isEmpty() -> Bool {
            return content == nil
        }
    }
    
    // Todo: add ability to supply default content for cells
    init(size: Int) {
        self.size = size
        cells = Array<Cell>()
        for number in 0..<size * size {
            cells.append(
                Cell(id: number,
                     row: number % size,
                     column: Int(number / size)
                    ))
        }
    }
    
    /// returns true if all cells in the grid contain `Content`; otherwise false
    func isFull() -> Bool {
        return cells.allSatisfy({ $0.content != nil })
    }

    /// returns true if no cells in the grid contain `Content`; otherwise false
    func isEmpty() -> Bool {
        return cells.allSatisfy({ $0.content == nil })
    }
    
    func rows() -> [[Cell]] {
        
        var rows = [[Cell]]()
        
        for row in 0..<size {
            rows.append(cells.filter({ (size * row) <= $0.id && $0.id < (size * (row + 1)) }))
        }
        return splits
    }
    
    /// - Todo: Write Tests
    func columns() -> [[Cell]] {
        
        var columns = [[Cell]]()
        
        for column in 0..<size {
            columns.append(cells.filter({ ($0.id - column) % size == 0 }))
        }
        return columns
    }
    
    func diagonals() -> [[Cell]] {
        
        let secondRowSecondColumnID = size + 1
        let topRightID = size - 1
        
        /// All cells on the diagonal starting from the top left of the board and ending with the bottom right
        let diagonalTopLeftToBottomRight = cells.filter({ cell in
            cell.id % secondRowSecondColumnID == 0
        })
        
        let diagonalBottomLeftToTopRight = cells.filter({ cell in
            cell.id != 0 &&
            cell.id % topRightID == 0 &&
            cell.id <= topRightID * size
        })
        return [diagonalTopLeftToBottomRight, diagonalBottomLeftToTopRight]
    }
    
    mutating func changeContent(of cell: Cell, to content: Content?) -> Cell? {
        if let chosenIndex = cells.firstIndex(where: { $0.id == cell.id }) {
            cells[chosenIndex].content = content
            return cells[chosenIndex]
        }
        return nil
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
