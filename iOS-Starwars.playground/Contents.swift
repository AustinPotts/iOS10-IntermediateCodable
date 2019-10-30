import Foundation

var str = "Hello, playground"

struct Person: Codable {
    
    enum PersonKeys: String, CodingKey {
        case name
        case height
        case hairColor = "hair_color"
        
        case films
        case starships
    }
    
    let name: String
    let height: Int
    let hairColor: String
    
    let films: [URL]
    let starships: [URL]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PersonKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        hairColor = try container.decode(String.self, forKey: .hairColor)
        
        do {
            height = try container.decode(Int.self, forKey: .height)
        } catch {
            let heightString = try container.decode(String.self, forKey: .height)
            height = Int(heightString) ?? 0
        }
        
        
        
        
    //    let filmString = container.decode([String].self, forKey: .films)
        
        var filmsContainer = try container.nestedUnkeyedContainer(forKey: .films)
        var filmURLs: [URL] = []
        
        
        //One way to decode
        while filmsContainer.isAtEnd == false {
            let filmsString = try filmsContainer.decode(String.self)
            if let filmURL = URL(string: filmsString) {
                filmURLs.append(filmURL)
            }
        }
        
        films = filmURLs
        
        //One way decode
        starships = try container.decode([URL].self, forKey: .starships)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PersonKeys.self)
        
        let heightString = String(height)
        try container.encode(heightString, forKey: .height)
        
        try container.encode(name, forKey: .name)
        
        try container.encode(hairColor, forKey: .hairColor)
        try container.encode(films, forKey: .films)
       // try container.encode(starships, forKey: .starships)
      
//        var starshipsContainer = container.nestedUnkeyedContainer(forKey: .starships)
//        for starship in starships {
//           try starshipsContainer.encode(starship.absoluteString)
//        }
        
        try container.encode(starships.map {$0.absoluteString}, forKey: .starships)
        
    }
}


let url = URL(string: "https://swapi.co/api/people/1/")!
let data = try! Data(contentsOf: url)

let decoder = JSONDecoder()

let luke = try! decoder.decode(Person.self, from: data)

let encoder = JSONEncoder()

encoder.outputFormatting = .prettyPrinted
let lukeData = try! encoder.encode(luke)

let dataAsString = String(data: lukeData, encoding: .utf8)!
print(dataAsString)
