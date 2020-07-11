// todo: 扩展应用 model，使之符合 MBEntitySharing 协议

extension ImageEntity {
    class func fetchThumbForShare(url: String?, callback: @escaping (UIImage) -> Void) {
        ImageEntity.fetchImage(withPath: url) { _, imageObj, _ in
            guard let image = imageObj as? UIImage else {
                callback(#imageLiteral(resourceName: "logo"))
                return
            }
            callback(image.thumbnailImage(maxSize: CGSize(width: 200, height: 200)))
        }
    }
}
