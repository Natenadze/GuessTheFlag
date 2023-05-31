//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Davit Natenadze on 31.05.23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var totalScore = 0
    @State private var questionNumber = 1
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Nigeria", "Poland", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .cyan]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Spacer()
                
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                        .font(.subheadline.weight(.heavy))
                    
                    Text("\(countries[correctAnswer])")
                        .foregroundColor(.white)
                        .font(.largeTitle.weight(.semibold))
                }
                
                // Button Flags
                ForEach(0..<3) { number in
                    Button {
                        flagTapped(number)
                    } label: {
                        Image(countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .shadow(radius: 10)
                    }
                }
                // ---
                
                Spacer()
                Spacer()
                
                // Bottom Title
                Text("Your score is: \(totalScore)")
                    .foregroundColor(.white)
                    .font(.title3)
                
                Spacer()
            }  // - Main VStack
            
        }  // - ZStack
        
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            if scoreTitle == "Correct" {
                Text("You got it right!")
            }else if scoreTitle == "Wrong" {
                Text("Correct answer is: \(correctAnswer + 1)")
            } else {
                Text("You answered \(totalScore) questions right!")
            }
        }
        
    }  // - Body
    
    
    // MARK: - Methods
    
    func flagTapped(_ number: Int) {
        
        switch questionNumber {
        case 8:
            scoreTitle = "Game Over"
            totalScore += 1
        default:
            if number == correctAnswer {
                scoreTitle = "Correct"
                totalScore += 1
            } else {
                scoreTitle = "Wrong"
            }
        }
        showingScore = true
        
        
    }
    
    // MARK: -
    
    func askQuestion() {
        if questionNumber == 8 {
            totalScore = 0
        }
        questionNumber += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
