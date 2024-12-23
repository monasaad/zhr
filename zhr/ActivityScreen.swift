//
//  ActivityScreen.swift
//  zhr
//
//  Created by Mona on 12/12/2024.
//

import SwiftUI

struct ActivityScreen: View {
    @State private var currentActivity: String = ""
    @State private var currentImage: String = "1"
    
    let activities = [
        NSLocalizedString("Walk for 15 minutes", comment: ""),
        NSLocalizedString("Go to the park", comment: ""),
        NSLocalizedString("Listen to stories", comment: ""),
        NSLocalizedString("Watch a movie", comment: ""),
        NSLocalizedString("Learn a new skill", comment: ""),
        NSLocalizedString("Visiting friends or family", comment: ""),
        NSLocalizedString("Go to traditional places", comment: ""),
        NSLocalizedString("Arrange family photos", comment: ""),
        NSLocalizedString("Listen to a podcast", comment: ""),
        NSLocalizedString("Plant or water some flowers", comment: ""),
        NSLocalizedString("Draw or color simple pictures", comment: ""),
        NSLocalizedString("Solve a simple puzzle", comment: ""),
        NSLocalizedString("Listen to The Qur’an", comment: ""),
        NSLocalizedString("Folding clothes", comment: ""),
        NSLocalizedString("Do light stretching exercises", comment: ""),
        NSLocalizedString("Read a short story", comment: ""),
        NSLocalizedString("Watch a favorite TV show", comment: ""),
        NSLocalizedString("Prepare a snack together", comment: ""),
        NSLocalizedString("Write simple tasks like their name", comment: ""),
        NSLocalizedString("Take a walk in the garden", comment: ""),
        NSLocalizedString("Draw in sand or with clay", comment: ""),
        NSLocalizedString("Play simple memory games (Like matching pictures)", comment: ""),
        NSLocalizedString("Play simple memory games (Like Differences between pictures)", comment: ""),
        NSLocalizedString("Play with a soft ball (like a small rubber ball)", comment: ""),
        NSLocalizedString("Talk about childhood memories", comment: ""),
        NSLocalizedString("Listen to nature sounds (birds or rain)", comment: ""),
        NSLocalizedString("Sort buttons or coins by color or size", comment: ""),
        NSLocalizedString("Bake cookies or a simple cake with help", comment: ""),
        NSLocalizedString("Watch videos of animals or nature", comment: ""),
        NSLocalizedString("Fold origami shapes", comment: ""),
        NSLocalizedString("Do simple hand clapping games", comment: ""),
        NSLocalizedString("Make a simple DIY craft", comment: ""),
        NSLocalizedString("Learn and repeat simple phrases in another language", comment: ""),
        NSLocalizedString("Identify objects by touch (use a blindfold for fun)", comment: ""),
        NSLocalizedString("Listening or reading stories from the Qur’an", comment: "")
    ]
    
    var body: some View {
        VStack {
            Text("Roll the dice to suggest new activities")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            
            Image(currentImage)
                .resizable()
                .scaledToFit()
                .frame(width: 500, height: 300)
                .padding()
            
            if !currentActivity.isEmpty {
                    Text("\(currentActivity)")
                        .font(.body)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding()
                }

            Button(action: {
                let randomImageNumber = Int.random(in: 1...6)
                currentImage = "\(randomImageNumber)"
                
                currentActivity = activities.randomElement() ?? "Try something fun!"
            }) {
                Text("Roll")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 300, height: 60)
                    .background(Color.purpleDark)
                    .cornerRadius(10)
                    .padding(.top, 10)
               

            }
        }
        .padding()
    }
}

#Preview {
    ActivityScreen()
}
