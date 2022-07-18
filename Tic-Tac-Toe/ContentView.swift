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
            GridView(game: game)
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
            }
        }
        .controlSize(.large)
    }
}

struct GridView: View {
    @ObservedObject var game: ImageTicTacToeGame
    
    var body: some View {
        LazyVGrid (columns: Array(repeating: GridItem(), count: game.size), spacing: 10) {
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
    var player: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.background)
            Text(player)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.black)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
