//
//  BlankView.swift
//  SwiftRIFF • https://github.com/orchetect/SwiftRIFF
//  © 2025-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

struct BlankView: View {
    let label: LocalizedStringKey
    let systemImage: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .fill(.background)
                .opacity(0.5)
                .blur(radius: 5)
                      
            VStack(spacing: 20) {
                Image(systemName: systemImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48, height: 48)
                    .foregroundColor(.secondary)
                
                Text(label)
            }
            .opacity(0.75)
        }
    }
}
