import Foundation

var str = "Hello, playground"


struct Pokemon: Codable {
    
    enum PokemonKeys: String, CodingKey {
        case pokemonName = "name"
        case height
    }
    
    let pokemonName: String
    let height: String //Int in the JSOn but we want a string
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonKeys.self)
        
        pokemonName = try container.decode(String.self, forKey: .pokemonName)
        
        let heightInt = try container.decode(Int.self, forKey: .height)
        height = String(heightInt)
    }
    
}

let url = URL(string: "https://pokeapi.co/api/v2/pokemon/4")!
let data = try! Data(contentsOf: url)

let decoder = JSONDecoder()
let charmander = try! decoder.decode(Pokemon.self, from: data)
