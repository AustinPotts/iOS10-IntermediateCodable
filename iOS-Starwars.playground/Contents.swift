import Foundation

var str = "Hello, playground"

struct Person: Codable {
    
    enum PersonKeys: String, CodingKey {
        case name
        case height
        case hairColor = "hair_color"
    }
    
    let name: String
    let height: Int
    let hairColor: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PersonKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        hairColor = try container.decode(String.self, forKey: .hairColor)
        let heightString = try container.decode(String.self, forKey: .height)
        height = Int(heightString) ?? 0
    }
}


let url = URL(string: "https://swapi.co/api/people/1/")!
let data = try! Data(contentsOf: url)

let decoder = JSONDecoder()
let luke = try! decoder.decode(Person.self, from: data)
