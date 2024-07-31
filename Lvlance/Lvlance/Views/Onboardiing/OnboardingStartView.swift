//
//  OnboardingStartView.swift
//  Lvlance
//
//  Created by 김하준 on 7/31/24.
//


import SwiftUI

struct OnboardingStartView: View {
    
    let image: String
    let description: String
    let buttonText: String
    let action: () -> Void
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 603, height: 302)
                .padding()
            
            Text(description)
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.white)
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: action) {
                    Text(buttonText)
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: 777, maxHeight: 507)
        .padding()
        .cornerRadius(12)
        .shadow(radius: 10)
    }
}
