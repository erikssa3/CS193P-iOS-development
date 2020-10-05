//
//  ContentView.swift
//  EmojiArt
//
//  Created by Anton Eriksson on 27.9.2020.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(EmojiArtDocument.palette.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: defaultEmojiSize))
                            .onDrag { NSItemProvider(object: emoji as NSString ) }
                    }
                    Button("Remove selected emojie") {
                        for selectedEmoji in document.selectedEmojis {
                            deleteEmoji(selectedEmoji)
                        }
                    }
                    .disabled(document.selectedEmojis.isEmpty)
                }
            }
            .padding(.horizontal)
            GeometryReader { geometry in
                ZStack {
                    Color.white.overlay(
                        OptionalImage(uiImage: document.backgroundImage)
                            .scaleEffect(zoomScale)
                            .offset(panOffset)
                    )
                    .gesture(doubleTapToZoom(in: geometry.size))
                    ForEach(document.emojies) { emoji in
                        Text(emoji.text)
                            .font(animatableWithSize: emoji.fontSize * zoomScale)
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 2)
                                        .stroke(Color.red)
                                        .opacity(document.selectedEmojis.contains(emoji) ? 1 : 0)
                                }
                                
                            )
                            .position(location(for: emoji, in: geometry.size))
                            .gesture(singleTapForSelecting(target: emoji))
                            .gesture(panEmojies(target: emoji))
                    }
                }
                .clipped()
                .contentShape(Rectangle().size(geometry.size))
                .gesture(panGesture())
                .gesture(zoomGesture())
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                    var location = geometry.convert(location, from: .global)
                    location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                    location = CGPoint(x: location.x - panOffset.width, y: location.y - panOffset.height)
                    location = CGPoint(x: location.x / zoomScale, y: location.y / zoomScale)
                    return self.drop(providers: providers, at: location)
                }
            }
        }
    }
    
    private func deleteEmoji(_ emoji: EmojiArt.Emoji) {
        document.deleteEmoji(emoji)
    }
    
    private func singleTapForSelecting(target: EmojiArt.Emoji) -> some Gesture {
        TapGesture(count: 1)
            .onEnded {
                document.selectEmoji(target)
            }
    }
    
    @State private var steadyStateZoomScale: CGFloat = 1.0
    @GestureState private var gestureZoomScale: CGFloat = 1.0
    
    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, transaction in
                gestureZoomScale = latestGestureScale
            }
            .onEnded { finalGestureScale in
                steadyStateZoomScale *= finalGestureScale
            }
    }
    
    @State private var steadyStatePanOffset: CGSize = .zero
    @GestureState private var gesturePanOffset: CGSize = .zero
    
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, transaction in
                gesturePanOffset = latestDragGestureValue.translation / zoomScale
            }
            .onEnded{ finalDragGestureValue in
                steadyStatePanOffset = steadyStatePanOffset + (finalDragGestureValue.translation / zoomScale)
            }
    }
    
    
    @GestureState private var selectedEmojisPanOffset: CGSize = .zero
    
    private func panEmojies(target emoji: EmojiArt.Emoji) -> some Gesture {
        let selectedEmojies = document.selectedEmojis
        return DragGesture()
            .updating($selectedEmojisPanOffset) { latestDragGestureValue, selectedEmojisPanOffset, transaction in
                if selectedEmojies.contains(emoji) {
                    selectedEmojisPanOffset = latestDragGestureValue.translation / zoomScale
                }
            }
            .onEnded { finalDragGestureValue in
                if selectedEmojies.contains(emoji) {
                    for selectedEmoji in selectedEmojies {
                        document.moveEmoji(selectedEmoji, by: (finalDragGestureValue.translation / zoomScale))
                    }
                }
            }
    }
    
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        let deselectAll = TapGesture(count: 1)
            .onEnded {
                document.selectedEmojis.removeAll()
            }
        return TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    zoomToFit(document.backgroundImage, in: size)
                }
            }
            .exclusively(before: deselectAll)
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            steadyStatePanOffset = .zero
            steadyStateZoomScale = min(hZoom, vZoom)

        }
    }
    
    private func location(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        if document.selectedEmojis.contains(emoji) {
            location = CGPoint(x: location.x + selectedEmojisPanOffset.width, y: location.y + selectedEmojisPanOffset.height)
        }
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        location = CGPoint(x: location.x + size.width/2, y: location.y + size.height/2)
        location = CGPoint(x: location.x + panOffset.width, y: location.y + panOffset.height)
        return location
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            self.document.setBackgroundURL(url)
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                self.document.addEmoji(string, at: location, size: self.defaultEmojiSize)
            }
        }
        return found
    }
    
    private let defaultEmojiSize: CGFloat = 40
}

struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        Group {
            if uiImage != nil {
                Image(uiImage: uiImage!)
            }
        }
    }
}
