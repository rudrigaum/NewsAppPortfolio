//
//  AuthView.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 16/08/25.
//

import Foundation
import SwiftUI

struct AuthView: View {
    // <<<<< CORRIGIDO: Propriedade @EnvironmentObject >>>>>
    @EnvironmentObject var authManager: AuthManager
    
    @State private var isLogin = true
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var authError: Error?
    
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
                
                if isLoading {
                    ProgressView()
                } else {
                    Button(isLogin ? "enter" : "register") {
                        Task {
                            await authenticate()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(.blue)
                    .padding(.top, 10)
                }
                
                if let authError = authError {
                    Text(authError.localizedDescription)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                }

                Spacer()
                
                Button {
                    withAnimation {
                        isLogin.toggle()
                        authError = nil // Limpa o erro ao alternar
                    }
                } label: {
                    Text(isLogin ? "Don't have an account? Sign up." : "Have an account? Sign in.")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
            }
            .padding(25)
            .navigationTitle(isLogin ? "login" : "register")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func authenticate() async {
        isLoading = true
        authError = nil
        
        do {
            if isLogin {
                try await authManager.signIn(email: email, password: password)
            } else {
                try await authManager.signUp(email: email, password: password)
            }
            dismiss()
        } catch {
            authError = error
        }
        
        isLoading = false
    }
}
