//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Jordi Rivera Lizarralde on 30/6/21.
//

import SwiftUI

struct ContentView: View {
    // Array of countries that we have the flags for
    // Use shuffle to randomize the game
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    // Tell the user if they got the answer correct
    @State private var showingScore = false
    
    @State private var scoreTitle = ""
    
    // Score of the user
    @State private var score = 0
    
    var body: some View {
        // Use ZStack to put color in the backgorung to better see the white of the flags
        ZStack {
            // Color the background with a gradient
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                // Cover all screen ignoring the edges
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tab the flag of:")
                        // Letters in white
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        // Make country larger in font
                        .font(.largeTitle)
                        // Make country thicker
                        .fontWeight(.black)
                }
                
                ForEach(0..<3) { number in
                    Button(action: {
                        // Flag was tapped
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            // Render the original image pixels
                            // Rather than recolor them as a button
                            .renderingMode(.original)
                            // Make images round
                            .clipShape(Capsule())
                            // Put a black line around the image
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                            .shadow(color: .black, radius: 2)
                    }
                }
                // Label for the user score
                Text("Score: \(score)")
                    .foregroundColor(.white)
                // Put everything right undernith the top
                Spacer()
            }
        }
        // Creating alert
        .alert(isPresented: $showingScore){
            // Tell the user whether they were correct or not
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"),
                  dismissButton: .default(Text("Continue")) {
                    // Continue the game with another quesiton
                    self.askQuestion()
                  })
        }
    }
    // Function to modify the state when the flag is tapped
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
            score = 0
        }
        showingScore = true
    }
    // Function to continue the game
    func askQuestion(){
        // Shuffle the countries to get other flags
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

