extension APIScope {
    /// https://vk.com/dev/market
    public enum Market: APIMethod {
        case searchadd(Parameters)
        case addAlbum(Parameters)
        case addToAlbum(Parameters)
        case createComment(Parameters)
        case delete(Parameters)
        case deleteAlbum(Parameters)
        case deleteComment(Parameters)
        case edit(Parameters)
        case editAlbum(Parameters)
        case editComment(Parameters)
        case get(Parameters)
        case getAlbumById(Parameters)
        case getAlbums(Parameters)
        case getById(Parameters)
        case getCategories(Parameters)
        case getComments(Parameters)
        case removeFromAlbum(Parameters)
        case reorderAlbums(Parameters)
        case reorderItems(Parameters)
        case report(Parameters)
        case reportComment(Parameters)
        case restore(Parameters)
        case restoreComment(Parameters)
        case search(Parameters)
    }
}
