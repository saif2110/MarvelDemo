import Foundation
import UIKit

extension UIImageView {
    func loadImage(fromURL url: URL, placeholder: UIImage? = UIImage(named: "ic_placeholder")) {
            // Set the placeholder image
            self.image = placeholder
            
            if let cachedImage = getCachedImage(for: url) {
                self.image = cachedImage
            } else {
                downloadImage(from: url) { [weak self] image in
                    DispatchQueue.main.async {
                        // Check if self still exists (not deallocated)
                        if let self = self {
                            self.image = image ?? placeholder
                        }
                    }
                }
            }
        }
    
    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                // Cache the downloaded image
                self.cacheImage(image, for: url)
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    
    private func cacheImage(_ image: UIImage, for url: URL) {
        let filename = url.lastPathComponent
        if let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let fileURL = cacheDirectory.appendingPathComponent(filename)
            if let data = image.pngData() {
                try? data.write(to: fileURL)
            }
        }
    }
    
    
    private func getCachedImage(for url: URL) -> UIImage? {
        let filename = url.lastPathComponent
        if let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let fileURL = cacheDirectory.appendingPathComponent(filename)
            if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
                return image
            }
        }
        return nil
    }
}
