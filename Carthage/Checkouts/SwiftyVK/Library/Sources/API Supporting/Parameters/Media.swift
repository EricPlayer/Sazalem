import Foundation

/// Represents different media items for VK.API.Upload method group
/// Used for MIME type generation
public enum Media: CustomStringConvertible {
    case image(data: Data, type: ImageType)
    case audio(data: Data, type: AudioType)
    case video(data: Data)
    case document(data: Data, type: String)
    
    var type: String {
        switch self {
        case .image(_, let type):
            return type.rawValue
        case .document(_, let type):
            return type
        case .audio(_, let type):
            return type.rawValue
        case .video:
            return "video"
        }
    }
    
    var data: Data {
        switch self {
        case .image(let data, _):
            return data
        case .document(let data, _):
            return data
        case .audio(let data, _):
            return data
        case .video(let data):
            return data
        }
    }
    
    public var description: String {
        return "Media with type \(type)"
    }
}

/// Type of image for VK.API.Upload.Images
/// Used for MIME type generation
public enum ImageType: String {
    case jpg
    case png
    case bmp
    case gif
}

public enum AudioType: String {
    case mp3
    case ogg
}
