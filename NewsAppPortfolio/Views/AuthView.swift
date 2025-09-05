//
//  AuthView.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 16/08/25.
//

import Foundation
import SwiftUI

struct AuthView: View {
    
    @EnvironmentObject var authManager: AuthManager
    
    @State private var isLogin = true
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var authError: Error?
    @State private var showSuccessMessage = false
    
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
                    VStack(spacing: 10) {
                        Button(isLogin ? "Entrar" : "Cadastrar") {
                            Task {
                                await authenticate()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .tint(.blue)
                        
                        Button {
                            Task {
                                await authenticateWithGoogle()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "g.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                Text("Continuar com o Google")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                    }
                }
                
                if let authError = authError {
                    Text(authError.localizedDescription)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                }
                
                if showSuccessMessage {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Registration completed successfully!")
                            .foregroundColor(.green)
                            .fontWeight(.semibold)
                    }
                    .padding(.top, 10)
                }

                Spacer()
                
                Button {
                    withAnimation {
                        isLogin.toggle()
                        authError = nil
                        showSuccessMessage = false
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
                withAnimation {
                    showSuccessMessage = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    dismiss()
                }
            }
        } catch {
            authError = error
        }
        
        isLoading = false
    }
    
    private func authenticateWithGoogle() async {
        isLoading = true
        authError = nil
        
        do {
            try await authManager.signInWithGoogle(presentingViewController: getRootViewController())
            dismiss()
        } catch {
            authError = error
        }
        
        isLoading = false
    }
}

private extension View {
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }

        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }

        return root
    }
}
