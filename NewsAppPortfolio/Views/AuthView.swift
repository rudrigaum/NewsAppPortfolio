//
//  AuthView.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 16/08/25.
//

import Foundation
import SwiftUI

struct AuthView: View {
    
    @State private var isLogin = true
    @State private var email = ""
    @State private var password = ""
    
    @Environment(\.dismiss) var dismiss
    
    init(isLogin: Bool = true) {
        self._isLogin = State(initialValue: isLogin)
    }
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 20) {
                
                Text(isLogin ? "Access your Account" : "Create your Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(spacing: 15) {
                    TextField("email", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                                    
                    SecureField("password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                
                Button(isLogin ? "enter" : "register") {
                    
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(Color.blue)
                .padding(.top, 10)
                
                Spacer()
                
                Button {
                    withAnimation {
                        isLogin.toggle()
                    }
                } label: {
                    Text(isLogin ? "Don't have an account? Sign up." : "Don't have an account? Sign up.")
                        .font(.footnote)
                        .foregroundStyle(.blue)
                }
            }
            .padding(25)
            .navigationTitle(isLogin ?  "login" : "register")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("cancel") {
                        dismiss()
                    }
                }
            }
        }
        
    }
}
