//
//  ProfileView.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 29/08/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let user = authManager.user {
                    // Foto de perfil com um ícone de sistema
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.gray)

                    // Nome e profissão
                    Text(user.email ?? "Usuário Anônimo")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Desenvolvedor de Software")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Spacer()

                    // Botão para sair da conta
                    Button("Sair") {
                        Task {
                            do {
                                try authManager.signOut()
                            } catch {
                                print("Erro ao fazer logout: \(error.localizedDescription)")
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                } else {
                    Text("Você não está logado.")
                }
            }
            .padding()
            .navigationTitle("Perfil")
        }
    }
}
