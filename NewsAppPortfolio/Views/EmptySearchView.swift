//
//  EmptySearchView.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 09/08/25.
//

import SwiftUI

struct EmptySearchView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
            
            Text(message)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

struct EmptySearchView_Previews: PreviewProvider {
    static var previews: some View {
        EmptySearchView(message: "Nenhum resultado encontrado para 'SwiftUI'.")
    }
}
