import UIKit

struct Registration {
    var firstName: String
    var lastName: String
    var emailAdress: String
    
    var checkInDate: Date
    var checkOutDate: Date
    
    var numberOfAdults: Int
    var numberOfChildren: Int
    
    var wifi: Bool
    var roomType: RoomType
    
    static var archiveURL: URL {
        let  documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentURL.appendingPathComponent("Registration").appendingPathExtension("plist")
        
        return archiveURL
    }
    
    //    func saveToFile(registration: [Registration]) {
    //        let encoder = PropertyListEncoder()
    //        let encodedRegistration = try? encoder.encode(registration)
    //    }
    
}


