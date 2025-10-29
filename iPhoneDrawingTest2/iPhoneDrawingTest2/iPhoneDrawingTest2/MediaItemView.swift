import SwiftUI

struct MediaItemView: View {
    let item: MediaItem
    let onDelete: () -> Void
    
    var body: some View {
        Group {
            if let image = item.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(8)
            } else if let videoURL = item.videoURL {
                VideoPlayerView(url: videoURL)
                    .frame(height: 300)
                    .cornerRadius(8)
            }
        }
        .contextMenu {
            Button(role: .destructive) {
                withAnimation {
                    onDelete()
                }
            } label: {
                Label("삭제", systemImage: "trash")
            }
        }
    }
}
