import SwiftUI
import PencilKit
import PhotosUI

struct PencilCanvasView: UIViewRepresentable {
    @Binding var drawing: PKDrawing

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PencilCanvasView
        init(_ parent: PencilCanvasView) {
            self.parent = parent
        }
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.drawing = canvasView.drawing
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> PKCanvasView {
            let canvasView = PKCanvasView()
            canvasView.drawing = drawing
            canvasView.delegate = context.coordinator
            canvasView.isOpaque = false
            canvasView.backgroundColor = .clear
            canvasView.drawingPolicy = .anyInput  // 손가락과 Apple Pencil 모두 사용 가능
            canvasView.tool = PKInkingTool(.pen, color: .label, width: 5)
            return canvasView
        }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if uiView.drawing != drawing {
            uiView.drawing = drawing
        }
    }
}

