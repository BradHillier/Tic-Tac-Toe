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
        static let foreground: Color = .white
        static let background: Color = .black
        static let gridBackground: Color = .cyan
        static let cellBackground: Color = .white.opacity(0.5)
        
        static let gridLineColour: Color = .white.opacity(0.0)
        static let playerXColor: Color = .blue
        static let playerYColor: Color = .red
        
        static let cellCornerRadius: CGFloat = 10
        static let cellPadding: CGFloat = 1
        
        static let gridLineWidth: CGFloat = 3
        static let gridLineStyle = StrokeStyle(lineWidth: Constants.gridLineWidth, lineCap: .round)
        static let gridPadding: CGFloat = 10
        
        static let winLineWidth: CGFloat = 3
        static let playerLineWidth: CGFloat = winLineWidth
        static let winningLineStyle = StrokeStyle(lineWidth: winLineWidth, lineCap: .round)
        static let winLineSpeed: Double = 0.5
        static let playerAnimationSpeed: Double = 0.3
    }
    
    var body: some View {
        ZStack {
            Rectangle().fill(.blue)
            VStack {
                Spacer()
                TitleView(game: game)
                GridView(game: game).padding(.all)
                Spacer()
                ControlView(game: game)
            }
        }.statusBar(hidden: true )
    }
    
    struct TitleView: View {
        @ObservedObject var game: ImageTicTacToeGame
        var body: some View {
            HStack {
                if game.menu {
                    Text("TicTacToe")
                } else if game.winner != nil {
                    game.image(of: game.winner)
                    Text(" Wins")
                } else if game.isTerminal {
                    Text("Tie")
                } else {
                    game.image(of: game.currentPlayer)
                    Text("'s Turn")
                }
            }
            .scaleEffect(game.winner == nil ? 1: 1.5)
            .animation(.spring(), value: game.winner)
            .font(.largeTitle)
            .foregroundColor(Constants.foreground)
        }
    }
    
    struct MenuView: View {
        @ObservedObject var game: ImageTicTacToeGame
        @State var size: Int = 3
        var body: some View {
            VStack {
                Group {
                    HStack{
                        Text("Board size: ")
                        Picker("Board Size", selection: $size) {
                            Text("3x3").tag(3)
                            Text("10x10").tag(10)
                            Text("15x15").tag(15)
                        }
                    }
                    Button("Single Player", action: {
                        withAnimation(.easeInOut(duration: 1)) {
                            game.newBoard(size: size)
                            game.playToggle()
                        }
                    })
                    Button("Mutliplayer", action: {
                        withAnimation(.easeInOut(duration: 1)) {
                            game.playToggle()
                        }
                    })
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(100)
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
                .boardView(game: game)

        }
        
        private func gridCell() -> GridItem {
            var gridItem = GridItem()
            gridItem.spacing = 0
            return gridItem
        }
    }
    
    struct lineIndicatingWinnerView: View {
        @ObservedObject var game: ImageTicTacToeGame
        @State var progress = CGFloat.zero
        
        @ViewBuilder
        var body: some View {
            if let (start, finish) = game.getWinLineEndPoints() {
                lineAnimation(start: start, finish: finish, gridSize: game.size)
                    .trim(from: 0, to: progress)
                    .stroke(game.winner == .X ? Constants.playerXColor : Constants.playerYColor,
                        style: Constants.winningLineStyle)
                    .onAppear(perform: {
                        progress = CGFloat.zero     // reset the animation
                        withAnimation(.easeIn(duration: Constants.winLineSpeed).delay(Constants.playerAnimationSpeed)) { progress = 1 }
                    })
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
                         .stroke(Constants.gridLineColour, style: Constants.gridLineStyle)
                     Path() { path in
                         path.move(to: CGPoint(x: cellSize * CGFloat(n), y: 0))
                         path.addLine(to: CGPoint(x: cellSize * CGFloat(n), y: geometry.size.height))
                     }
                         .stroke(Constants.gridLineColour, style: Constants.gridLineStyle)
                 }
             }
         }
     }
    
    struct CellView: View {
        var player: Grid<TicTacToe.Player?>.Cell
        
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(Constants.cellBackground)
                    .padding(Constants.cellPadding)
                    .cornerRadius(Constants.cellCornerRadius)
                if let player = player.content  {
                    if player == .X {
                        PlayerXView()
                            .padding(15)
                    } else if player == .O {
                        PlayerOView()
                            .padding(12)
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
                Button(action: withAnimation { game.playToggle } ) {
                    ControlView.label("AI move", icon: "brain.head.profile")
                }
                Spacer()
            }
            .padding()
            .foregroundColor(Constants.foreground)
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
        @State var progress = CGFloat.zero
        var body: some View {
            GeometryReader { geometry in
                Path() { path in
                    path.move(to: CGPoint())
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                    path.move(to: CGPoint(x: 0, y: geometry.size.height))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
                }
                    .trim(from: 0, to: progress)
                    .stroke(Constants.playerXColor, style: StrokeStyle(lineWidth: Constants.playerLineWidth, lineCap: .round))
                    .onAppear {
                        withAnimation(.easeInOut(duration: Constants.playerAnimationSpeed)) {
                            progress = 1
                        }
                    }
                }
        }
    }
    
    struct PlayerOView: View {
        @State var progress = CGFloat.zero
        var body: some View {
            GeometryReader { geometry in
                Path() { path in
                    path.move(to: CGPoint(x: geometry.size.width / 2, y: 0))
                    path.addArc(center: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2), radius: geometry.size.height / 2, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 270), clockwise: true)
                }
                    .trim(from: 0, to: progress)
                    .stroke(Constants.playerYColor, style: StrokeStyle(lineWidth: Constants.playerLineWidth, lineCap: .round))
                    .onAppear {
                        withAnimation(.easeInOut(duration: Constants.playerAnimationSpeed)) {
                            progress = 1
                        }
                    }
                }
        }
    }
    
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            TicTacToeGameView()
        }
    }
}


struct BoardView: AnimatableModifier {
    
    @ObservedObject var game: ImageTicTacToeGame
    
    init(game: ImageTicTacToeGame) {
        self.game = game
        self.rotation = game.menu ? 0 : 180
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    var rotation: Double  // in degrees
    
    func body(content: Content) -> some View {
        ZStack {
            
            /**
             this is a bit of a hack to smoothly animate the grid resizing;
             without this, the grid will abruptly change size when rotation reaches 90 degrees;
             This is almost certainly a TERRIBLE way to do this
             */
            if !game.menu {
                // this prevents a second invisible board from existing after
                // the animation is complete
                if rotation != 180 {
                    content
                        .opacity(0)
                }
            }
            
            if rotation < 90 {
                TicTacToeGameView.MenuView(game: game)
            } else {
                content
                    .opacity(rotation < 90 ? 0 : 1)
                    .overlay(TicTacToeGameView.lineIndicatingWinnerView(game: game))
            }
           
        }
        .padding(10)
        .background(.cyan)
        .cornerRadius(10)
        .rotation3DEffect(Angle(degrees: rotation), axis: (0, 1, 0))
    }
}

extension View {
    func boardView(game: ImageTicTacToeGame) -> some View {
        return self.modifier(BoardView(game: game ))
    }
}
