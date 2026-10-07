//
//  ContentView.swift
//  TabApp
//
//  Created by Matheus Lima do Espirito Santo on 06/10/26.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @State private var timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    @State private var currentIndex = 0
    
    @State private var targetIndex = 1
    
    @State private var score = 0
    
    @State private var showAlert = false
    
    @State private var alertTitle = "Oops!"
    
    @State private var alertMessage = "You missed it! Stay sharp and give it another shot."
    
    @State private var game = true
    
    private var randomTarget: Int {
       return Int.random(in: 0..<imageItens.count)
    }
    
    private let imageItens = ["Apple","Dog","Egg"]
    
    private enum Difficulty: Double {
        
        case easy = 1.0
        case medium = 0.5
        case hard = 0.3
        
        func title () -> String {
            switch self {
            case .easy:
                return "Easy"
            case .medium:
                return "Medium"
            case .hard:
                return "Hard"
            }
        }
    }
    
    var body: some View {
        VStack{
            HStack{
                if !game{
                    Menu("Difficulty"){
                    Button(Difficulty.easy.title()){
                        timer = Timer.publish(every: Difficulty.easy.rawValue, on: .main, in: .common).autoconnect()
                    }
                    Button(Difficulty.medium.title()){
                        timer = Timer.publish(every: Difficulty.medium.rawValue, on: .main, in: .common).autoconnect()

                    }
                    Button(Difficulty.hard.title()){
                        timer = Timer.publish(every: Difficulty.hard.rawValue, on: .main, in: .common).autoconnect()
}
                }}
               
                Spacer()
                Text("Score: \(score)")
            }
            .padding(.horizontal)
            Image(imageItens[currentIndex])
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 400)
                .onTapGesture {
                    checkImage()
                }
            Text("Select Image: \(imageItens[targetIndex])")
            
            if !game {
                Button("Restart Game", action: {
                    targetIndex = randomTarget
                    game = true
                })
            }
        }
        .onReceive(timer, perform:
                    {_ in
            guard game else { return }
            changeImage()
            
        })
        .alert(alertTitle, isPresented: $showAlert, ) {
            Button("Ok", action: {showAlert = false})
        } message: {
            Text(alertMessage)
        }
    }
    func changeImage(){
        if currentIndex == imageItens.count - 1 {
            currentIndex = 0
        } else {
            currentIndex = currentIndex + 1
        }
    }
    
    func checkImage() {
        if targetIndex == currentIndex {
            score = score + 1
        } else {
            showAlert = true
            score = 0
            game = false
            
        }
        if targetIndex == imageItens.count - 1 {
            targetIndex = 0
        } else {
            targetIndex += 1
        }
    }
}

#Preview {
    ContentView()
}
