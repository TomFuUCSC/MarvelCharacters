// Author: Tom Fu
import SwiftUI

struct CachedAsyncImage<Content>: View where Content: View {
    private let url: URL
    private let content: (AsyncImagePhase) -> Content

    init(
        url: URL,
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.content = content
    }

    var body: some View {
        if let cached = ImageCache[url] {
            // let _ = print("cached \(url.absoluteString)")
            content(.success(cached))
        } else {
            AsyncImage(url: url, transaction: .init(animation: .easeInOut)) { phase in
                cacheAndRender(phase: phase)
            }
        }
    }

    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case let .success(image) = phase {
            ImageCache[url] = image
        }

        return content(phase)
    }
}

struct CacheAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        let character = Character.mock.first!

        CachedAsyncImage(
            url: character.imageURL
        ) { phase in
            switch phase {
            case let .success(image):
                image
            default:
                ProgressView()
            }
        }
    }
}

private enum ImageCache {
    private static var cache: [URL: Image] = [:]

    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}
