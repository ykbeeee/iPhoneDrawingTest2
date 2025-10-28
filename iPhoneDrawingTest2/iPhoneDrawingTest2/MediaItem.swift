import SwiftUI
import PhotosUI

struct MediaItem: Identifiable {
    let id = UUID()
    var image: UIImage?
    var videoURL: URL?
    var isVideo: Bool {
        videoURL != nil
    }
}

struct VideoPickerTransferable: Transferable {
    let url: URL
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { video in
            SentTransferredFile(video.url)
        } importing: { received in
            let copy = URL.documentsDirectory.appending(path: "video-\(UUID().uuidString).mov")
            try FileManager.default.copyItem(at: received.file, to: copy)
            return Self(url: copy)
        }
    }
}
