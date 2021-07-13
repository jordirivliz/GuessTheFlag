//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Jordi Rivera Lizarralde on 30/6/21.
//

import SwiftUI

// Image modifier
struct ImageModifier: ViewModifier{

    func body(content: Content) -> some View {
        content
        // Make images round
        .clipShape(Capsule())
        // Put a black line around the image
        .overlay(Capsule().stroke(Color.black, lineWidth: 1))
        .shadow(color: .black, radius: 2)
    }
}
// Text Modifier
struct LargeRed: ViewModifier {
    func body(content: Content) -> some View{
       content
        // Make country larger in font
        .font(.largeTitle)
        // Make color red
        .foregroundColor(.red)
        .frame(width: UIScreen.main.bounds.width)
    }
}

extension View{
    func largeRed() -> some View {
        self.modifier(LargeRed())
        }
    func imageModifier() -> some View {
            self.modifier(ImageModifier())
        }
}

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
    
    // Selection of the user
    @State private var userTapped = 0

    // Properties for the animation
    @State private var animationAmount = 0.0
    @State private var opacity = 1.0
    @State private var offset = CGFloat.zero
    
    @State private var disabled = false
    
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
                        // Add space between the top and the text
                        .padding(.top, 50)
                        // Change font of letters
                        .font(.largeTitle)
                    Text(countries[correctAnswer])
                        // Make country thicker
                        .fontWeight(.black)
                        // Use text modifier
                        .largeRed()
                }
                ForEach(0..<3) { number in
                    Button(action: {
                        // Flag was tapped
                        self.flagTapped(number)
                        self.userTapped = number
                        
                        // Animate the flag if the answer was correct
                        if number == self.correctAnswer {
                            // Create the animation
                            withAnimation(.easeInOut(duration: 2)) {
                                self.animationAmount += 360
                                self.opacity -= 0.75
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                            {self.askQuestion()}
                        } else {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                self.offset = 200
                            }
                        }
                        self.disabled = true
                    }) {
                        Image(self.countries[number])
                            // Render the original image pixels
                            // Rather than recolor them as a button
                            .renderingMode(.original)
                            // Use image modifier
                            .imageModifier()
                    }
                    // Rotate 360 degrees on y axis if the answer was correct
                    .rotation3DEffect(.degrees(animationAmount), axis: (x:0, y: self.userTapped == number ? 1 : 0, z:0))
                    .offset(x: number != self.correctAnswer ? self.offset : .zero, y: .zero)
                    .clipped()
                    .opacity(number != self.userTapped ? self.opacity : 1.0)
                    .disabled(self.disabled)
                }
                // Put everything right undernith the top
                Spacer()
                // Label for the user's score
                ZStack{
                    // Create a red circle containing the score
                    Color.red
                    .clipShape(Circle())
                    .frame(width: 150, height: 100)
                    Text("\(score)")
                }
                // Modifiers for the score
                .foregroundColor(.white)
                .font(.largeTitle)
            }
        }
        // Creating alert
        .alert(isPresented: $showingScore){
            // Tell the user whether they were correct or not
            Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"),
                  dismissButton: .default(Text("Continue")) {
                    // Continue the game with another quesiton
                    self.askQuestion()
                    score = 0
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
            showingScore = true
        }
    }
    // Function to continue the game
    func askQuestion(){
        // Reset properties
        self.disabled = false
        self.opacity = 1
        self.offset = .zero
        
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
