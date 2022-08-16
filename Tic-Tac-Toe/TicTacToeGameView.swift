//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-07-16.
//

import SwiftUI

struct TicTacToeGameView: View {
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
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
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
            TicTacToeGameView()
        }
    }
}