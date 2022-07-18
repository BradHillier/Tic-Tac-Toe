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
            Text("Tic Tac Toe!").font(.largeTitle)
            Spacer()
            GridView(game: game)
            Spacer()
            HStack {
                Spacer()
                Button {
                    game.reset()
                } label: {
                    Image(systemName: "restart")
                }
                Spacer()
                Button {
                    game.undo()
                } label: {
                    Image(systemName: "arrow.uturn.backward")
                }
                Spacer()
                Button {
                    game.redo()
                } label: {
                    Image(systemName: "arrow.uturn.forward")
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
                    .foregroundColor(.black)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
