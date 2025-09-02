//
//  SignUpPromptView.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 15/08/25.
//

import Foundation
import SwiftUI

struct SignUpPromptView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingAuthView = false
    @State private var isLogin = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.badge.key.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
            
            Text("Save your news")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Create an account to save your favorite news and access it on any device.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 15) {
                Button("Create Account") {
                    isLogin = false
                    showingAuthView = true
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.regular)
            
                Button("I already have an account") {
                    isLogin = true
                    showingAuthView = true
                }
                .foregroundColor(.blue)
            }
        }
        .padding(30)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(radius: 20)
        .sheet(isPresented: $showingAuthView) {
            AuthView(isLogin: isLogin)
        }
    }
}
