//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-07-16.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game = ImageTicTacToeGame()
    
    var body: some View {
        VStack {
            Spacer()
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
            Spacer()
            Spacer()
            GridView(game: game)
            Spacer()
            Spacer()
            HStack {
                Spacer()
                Button {
                    game.reset()
                } label: {
                    VStack {
                        Image(systemName: "restart")
                        Text("restart")
                    }
                }
                Spacer()
                Button {
                    game.undo()
                } label: {
                    VStack {
                        Image(systemName: "arrow.uturn.backward")
                        Text("undo")
                    }
                }
                Spacer()
                Button {
                    game.redo()
                } label: {
                    VStack {
                        Image(systemName: "arrow.uturn.forward")
                        Text("redo")
                    }
                }
                Spacer()
            }
            .padding()
        }
        .controlSize(.large)
    }
}

struct GridView: View {
    @ObservedObject var game: ImageTicTacToeGame
    
    var body: some View {
        LazyVGrid (columns: Array(repeating: GridItem(), count: game.size), spacing: 8) {
            ForEach(game.board) { cell in
                CellView(player: game.getValue(of: cell))
                    .aspectRatio(1/1, contentMode: .fit)
                    .onTapGesture {
                        game.choose(cell)
                }
            }
        }
        .background(.primary)
        .padding()
        
    }
}

struct CellView: View {
    var player: Image?
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.background)
            if let playerImage = player {
                playerImage
                    .font(.largeTitle)
                    .foregroundColor(.primary)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
