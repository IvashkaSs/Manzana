import Foundation

struct RoomType: Equatable {
    static var all: [RoomType] {
        return [RoomType(id: 0, name: "Две Королевы🎎", shortName: "2Q", price: 179),
                RoomType(id: 1, name: "Королевский👑", shortName: "K", price: 209),
                RoomType(id: 2, name: "Пентхаус 🏨", shortName: "PHS", price: 309)]
    }
    
    var id: Int
    var name: String
    var shortName: String
    var price: Int
    
    static func==(lhs: RoomType, rhs: RoomType) -> Bool {
        return lhs.id == rhs.id
    }
}
