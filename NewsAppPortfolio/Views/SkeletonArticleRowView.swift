//
//  SkeletonArticleRowView.swift
//  NewsAppPortfolio
//
//  Created by Rodrigo Cerqueira Reis on 08/08/25.
//

import Foundation
import SwiftUI

struct SkeletonArticleRowView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 200)
            
            VStack(alignment: .leading, spacing: 5) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 18)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 200, height: 18)
            }
            .padding(.top, 4)
            
            VStack(alignment: .leading, spacing: 5) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 14)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 250, height: 14)
            }
            
            HStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 12)
                Spacer()
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 80, height: 12)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

struct SkeletonArticleRowView_Previews: PreviewProvider {
    static var previews: some View {
        SkeletonArticleRowView()
            .previewLayout(.sizeThatFits)
    }
}
