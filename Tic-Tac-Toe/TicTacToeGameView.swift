//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-07-16.
//

import SwiftUI


struct TicTacToeGameView: View {
    @ObservedObject var game = ImageTicTacToeGame()
    
    private struct Constants {
        static let gridLineWidth: CGFloat = 3
        static let gridLineColour: Color = .gray
        static let winLineWidth: CGFloat = 5
        static let playerXColor: Color = .blue
        static let playerYColor: Color = .red
        static let winningLineStyle = StrokeStyle(lineWidth: 4, lineCap: .round)
    }
    
    var body: some View {
        VStack {
            Spacer()
            TitleView(game: game)
            Spacer()
            GridView(game: game)
            Spacer(minLength: 70)
            ControlView(game: game)
        }
    }
    
    struct TitleView: View {
        @ObservedObject var game: ImageTicTacToeGame
        var body: some View {
            HStack {
                if game.winner != nil {
                    game.image(of: game.winner)
                    Text(" Wins")
                } else if game.isTerminal {
                    Text("Tie")
                } else {
                    game.image(of: game.currentPlayer)
                    Text("'s Turn")
                }
            }
                .font(.largeTitle)
                .foregroundColor(.primary)
        }
    }
    
    struct GridView: View {
        @ObservedObject var game: ImageTicTacToeGame
        
        @ViewBuilder
        var body: some View {
            LazyVGrid (columns: Array(repeating: gridCell(), count: game.size), spacing: 0) {
                ForEach(game.board) { cell in
                    CellView(player: cell)
                        .aspectRatio(1/1, contentMode: .fill)
                        .onTapGesture {
                            withAnimation {
                                game.choose(cell)
                            }
                        }
                }
            }
            .overlay(GridLinesView(size: game.size))
            .overlay(lineIndicatingWinnerView(game: game))
           
        }
        
        private func gridCell() -> GridItem {
            var gridItem = GridItem()
            gridItem.spacing = 0
            return gridItem
        }
    }
    
    struct lineIndicatingWinnerView: View {
        @ObservedObject var game: ImageTicTacToeGame
        
        @ViewBuilder
        var body: some View {
            if let (start, finish) = game.getWinLineEndPoints() {
                lineAnimation(startCell: start, endCell: finish, gridSize: game.size)
                    .stroke(game.winner == .X ? Constants.playerXColor : Constants.playerYColor,
                        style: Constants.winningLineStyle)
            }
        }
    }
    
    struct GridLinesView: View {
        let size: Int
        
        let lineWidth: CGFloat = 10
        
        var body: some View {
            GeometryReader { geometry in
                let cellSize = geometry.size.width / CGFloat(size)
                
                 ForEach(1..<size) { n in
                     Path() { path in
                         path.move(to: CGPoint(x: 0, y: cellSize * CGFloat(n) ))
                         path.addLine(to: CGPoint(x: geometry.size.width, y: cellSize * CGFloat(n)))
                     }
                         .stroke(Constants.gridLineColour,
                             style: StrokeStyle(lineWidth: Constants.gridLineWidth, lineCap: .round))
                     Path() { path in
                         path.move(to: CGPoint(x: cellSize * CGFloat(n), y: 0))
                         path.addLine(to: CGPoint(x: cellSize * CGFloat(n), y: geometry.size.height))
                     }
                         .stroke(Constants.gridLineColour,
                             style: StrokeStyle(lineWidth: Constants.gridLineWidth, lineCap: .round))
                 }
             }
         }
     }
    
    struct CellView: View {
        var player: Grid<TicTacToe.Player?>.Cell
        
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(.background)
                if let player = player.content  {
                    if player == .X {
                        PlayerXView()
                    } else if player == .O {
                        PlayerOView()
                    }
                }
            }
        }
    }
    
    struct ControlView: View {
        var game: ImageTicTacToeGame
        
        var body: some View {
            HStack {
                Spacer()
                Button(action: game.reset) {
                    ControlView.label("restart", icon: "restart")
                }
                Spacer()
                Button(action: game.undo) {
                    ControlView.label("undo", icon: "arrow.uturn.backward")
                }
                Spacer()
                Button(action: game.redo) {
                    ControlView.label("redo", icon: "arrow.uturn.forward")
                }
                Spacer()
                Button(action: game.aiMove) {
                    ControlView.label("AI move", icon: "brain.head.profile")
              }
                Spacer()
            }
            .padding()
            .foregroundColor(Color.blue)
            .controlSize(.large)
        }
        
        @ViewBuilder
        static private func label(_ text: String, icon: String) -> some View {
            VStack {
                Image(systemName: icon)
                Text(text)
            }
        }
    }
    
    struct PlayerXView: View {
        var body: some View {
            Image(systemName: "xmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(20)
                .foregroundColor(Constants.playerXColor)
        }
    }
    
    struct PlayerOView: View {
        var body: some View {
            Image(systemName: "circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(15)
                .foregroundColor(Constants.playerYColor)
        }
    }
    
    
    
    
    
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            TicTacToeGameView()
        }
    }
}
