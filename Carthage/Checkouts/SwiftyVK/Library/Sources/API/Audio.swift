extension APIScope {
    /// https://vk.com/dev/audio
    public enum Audio: APIMethod {
        case get(Parameters)
        case getById(Parameters)
        case getLyrics(Parameters)
        case search(Parameters)
        case getUploadServer(Parameters)
        case save(Parameters)
        case add(Parameters)
        case delete(Parameters)
        case edit(Parameters)
        case reorder(Parameters)
        case getAlbums(Parameters)
        case addAlbum(Parameters)
        case editAlbum(Parameters)
        case deleteAlbum(Parameters)
        case moveToAlbum(Parameters)
        case setBroadcast(Parameters)
        case getBroadcastList(Parameters)
        case getRecommendations(Parameters)
        case getPopular(Parameters)
        case getCount(Parameters)
    }
}
