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
            GridView(game: game)
            Spacer(minLength: 70)
            ControlView(game: game)
    }
}

struct GridView: View {
    @ObservedObject var game: ImageTicTacToeGame
    
    var body: some View {
        LazyVGrid (columns: Array(repeating: GridItem(), count: game.size), spacing: 8) {
            ForEach(game.board) { cell in
                CellView(player: cell)
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
        .controlSize(.large)
    }
    }
}

struct PlayerXView: View {
    var body: some View {
        Image(systemName: "xmark")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(20)
            .foregroundColor(.red)
    }
}

struct PlayerOView: View {
    var body: some View {
        Image(systemName: "circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(15)
            .foregroundColor(.blue)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
