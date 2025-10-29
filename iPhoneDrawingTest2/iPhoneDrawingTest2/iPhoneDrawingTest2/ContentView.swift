//
//  Untitled 2.swift
//  iPhoneDrawingTest2
//
//  Created by Libby on 10/28/25.
//

import SwiftUI
import PencilKit
import PhotosUI

struct ContentView: View {
    @State private var text: String = ""
    @State private var isDrawingMode: Bool = false
    @State private var drawing: PKDrawing = PKDrawing()
    @State private var mediaItems: [MediaItem] = []
    @State private var selectedPhotoItem: PhotosPickerItem?

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    TextEditor(text: $text)
                        .frame(minHeight: 200)
                        .scrollDisabled(true)
                        .background(Color.clear)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .allowsHitTesting(!isDrawingMode)
                    
                    ForEach(mediaItems) { item in
                        MediaItemView(item: item) {
                            mediaItems.removeAll { $0.id == item.id }
                        }
                    }
                }
                .padding()
            }
            .ignoresSafeArea(.keyboard)
            
            if isDrawingMode {
                PencilCanvasView(drawing: $drawing)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
            
            VStack {
                Spacer()
                HStack(spacing: 20) {
                    if !isDrawingMode {
                        PhotosPicker(selection: $selectedPhotoItem, matching: .any(of: [.images, .videos])) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 24))
                                .foregroundStyle(.white)
                                .padding(12)
                                .background(Color.green)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            isDrawingMode.toggle()
                        }
                    } label: {
                        Image(systemName: isDrawingMode ? "checkmark.circle.fill" : "pencil.tip.crop.circle.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(.white)
                            .padding(15)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .onChange(of: selectedPhotoItem) { oldValue, newValue in
            Task {
                if let newValue {
                    await loadMedia(from: newValue)
                }
            }
        }
    }
    
    private func loadMedia(from item: PhotosPickerItem) async {
        if item.supportedContentTypes.contains(where: { $0.conforms(to: .movie) }) {
            if let movie = try? await item.loadTransferable(type: VideoPickerTransferable.self) {
                await MainActor.run {
                    withAnimation {
                        mediaItems.append(MediaItem(videoURL: movie.url))
                    }
                }
            }
        } else {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                await MainActor.run {
                    withAnimation {
                        mediaItems.append(MediaItem(image: image))
                    }
                }
            }
        }
        selectedPhotoItem = nil
    }
}

#Preview {
    ContentView()
}
