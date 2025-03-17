//
//  ImageHelp.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-24.
//

import SwiftUI
import UnifiedBlurHash

struct ImageHelp: View {
    let imageID: String
    let blurHash: String?
    
    @State private var isLoading: Bool = true
    @State private var uiImage: UIImage? = nil
    @State private var isVisible: Bool = false
    
    var body: some View {
        ZStack {
            if isLoading {
                // Shimmering placeholder while the image is loading
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .shimmering()
            } else {
                if let uiImage = uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            
            VisibilityDetector(
                onVisible: {
                    print("Appeared")
                    isVisible = true
                    
                    if let blurHash = blurHash {
                        self.uiImage = UnifiedImage(blurHash: blurHash, size: .init(width: 32, height: 32))
                        self.isLoading = false
                    }
                    
                    loadImage(id: imageID)
                },
                onHidden: {
                    print("Disappeared")
                    isVisible = false
                    unloadImage()
                }
            )
        }
        .onChange(of: imageID) {
            loadImage(id: imageID)
        }
        .onChange(of: blurHash) {
            if !isLoading { return }
            if let hash = blurHash {
                uiImage = UnifiedImage(blurHash: hash, size: .init(width: 32, height: 32))
                isLoading = false
            }
        }
        .onDisappear() {
            unloadImage()
        }
        
    }
    
    private func loadImage(id: String) {
        guard isVisible else {
            return
        }
        
        Task {
            if let fetchedImage = await JellyfinMusicService.shared.getImage(id: id) {
                uiImage = fetchedImage
                isLoading = false
            } else {
                print("Failed to load the image for \(id).") // TODO: Add placeholder
                isLoading = false
            }
        }
    }
    
    private func unloadImage() {
        uiImage = nil
    }
}
