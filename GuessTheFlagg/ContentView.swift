//
//  ContentView.swift
//  GuessTheFlagg
//
//  Created by Louis Mille on 29/06/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var currentScore = 0
    @State private var currentQuestion = 1
    @State private var totalQuestion = 9
    @State private var resetGame = false
    
    var FlagImage: some View {
        ForEach(0..<3) { number in
            Button {
                flagTapped(number)
            } label: {
                Image(countries[number])
                    .renderingMode(.original)
                //.clipShape(Capsule())
                    .shadow(radius: 5)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .purple] ), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Text("Guess the flag 🥳")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                VStack(spacing: 30) {
                    
                    VStack {
                        Text("Tap the flag of:")
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                        Text("Question \(currentQuestion)/8")
                    }
                    .foregroundColor(.white)
                    
                    FlagImage
                    
                    Text("Score: \(currentScore)")
                        .modifier(Title())
                    
                    Spacer()
                }
                .padding()
            }
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
                    Button("Continue", action: askQuestion)
                } message: {
                    Text("Your score is \(currentScore)")
                }
        .alert(scoreTitle, isPresented: $resetGame) {
                    Button("Restart", action: askQuestion)
                }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            currentScore += 1
            currentQuestion += 1
        } else {
            scoreTitle = "Wrong, that's the flag of \(countries[number])"
            currentScore -= 1
            currentQuestion += 1
        }
        showingScore = true
    }
    
    func askQuestion () {
        if currentQuestion == 9 {
            scoreTitle = "No more questions"
            currentQuestion = 0
            currentScore = 0
            resetGame = true
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
        
    }
    

}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.yellow)
            .fontWeight(.bold)
            .font(.largeTitle)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.light)
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
