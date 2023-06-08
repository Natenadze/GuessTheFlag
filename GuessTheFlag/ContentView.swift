//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Davit Natenadze on 31.05.23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var rotationAngles: [Angle] = Array(repeating: .zero, count: 3)
    @State private var buttonOpacity: [Double] = Array(repeating: 1, count: 3)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var totalScore = 0
    @State private var questionNumber = 0
    
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
                        withAnimation(.easeInOut(duration: 0.6)) {
                            rotationAngles[number] += .degrees(360)
                            // Way 1 (You dont get syntax)
//                            buttonOpacity = buttonOpacity.enumerated().map { $0.offset == index ? 1.0 : 0.25 }
                          
                            // Way 2 (Too simple?)
//                            buttonOpacity.indices.forEach{buttonOpacity[$0] = 0.25}
//                            buttonOpacity[index] = 1
                            
                            // Way 3 (Looks ok)
                            buttonOpacity.indices.forEach { buttonOpacity[$0] = ($0 == number) ? 1.0 : 0.25 }
                        }
                        
                        flagTapped(number)
                    } label: {
                        FlagImage(number: number)
                    }
                    .rotation3DEffect(rotationAngles[number], axis: (x: 0, y: 1, z: 0))
                    .opacity(buttonOpacity[number])
                    .scaleEffect(buttonOpacity[number] == 1.0 ? 1.0 : 0.8)  // Scale other buttons
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
        questionNumber += 1
        var answerWasRight = false
        
        if number == correctAnswer {
            totalScore += 1
            answerWasRight = true
        }
        
        if questionNumber == 8 {
            scoreTitle = "Game Over"
        } else {
            scoreTitle =  answerWasRight ? "Correct" : "Wrong"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showingScore = true
        }
        
    }
    
    
    // MARK: -
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        if questionNumber == 8 {
            totalScore = 0
            questionNumber = 0
        }
        
        // give buttons original opacity
        buttonOpacity = Array(repeating: 1.0, count: 3)
    }
    
}


extension ContentView {
    
    // MARK: - Helper
    func FlagImage(number: Int) -> some View {
        Image(countries[number])
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 10)
    }
}


// MARK: -

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
