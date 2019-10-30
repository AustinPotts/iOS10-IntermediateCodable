import Foundation

var str = "Hello, playground"


struct Pokemon: Codable {
    
    enum PokemonKeys: String, CodingKey {
        case name
        case species
        case abilities
        
        enum SpeciesKeys: String, CodingKey {
              case name
          }
        enum AbilityDescriptionKeys: String, CodingKey {
            case ability
            
            enum AbilityKeys: String, CodingKey {
                case name
            }
        }
        
    }
    
  
    
    let name: String
    let species: String
    let abilities: [String]
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
       
        let speciesContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpeciesKeys.self, forKey: .species)
        
        species = try speciesContainer.decode(String.self, forKey: .name)
        
        var abilitiesContainer = try container.nestedUnkeyedContainer(forKey: .abilities)
        
        var abilityNames: [String] = []
        
        while abilitiesContainer.isAtEnd == false {
            let abilityDescriptionContainer = try abilitiesContainer.nestedContainer(keyedBy: PokemonKeys.AbilityDescriptionKeys.self)
            
            let abilityContainer = try abilityDescriptionContainer.nestedContainer(keyedBy: PokemonKeys.AbilityDescriptionKeys.AbilityKeys.self, forKey: .ability)
            
            let abilityName = try abilityContainer.decode(String.self, forKey: .name)
            abilityNames.append(abilityName)
        }
        
        abilities = abilityNames
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PokemonKeys.self)
        
        try container.encode(name, forKey: .name)
        
        var speciesContainer = container.nestedContainer(keyedBy: PokemonKeys.SpeciesKeys.self, forKey: .species)
        
        try speciesContainer.encode(species, forKey: .name)
        
        var abiltiesContainer = container.nestedUnkeyedContainer(forKey: .abilities)
        
        for ability in abilities {
            var abiltiesDescriptionContainer = abiltiesContainer.nestedContainer(keyedBy: PokemonKeys.AbilityDescriptionKeys.self)
            
            var abilityContainer = abiltiesDescriptionContainer.nestedContainer(keyedBy: PokemonKeys.AbilityDescriptionKeys.AbilityKeys.self, forKey: .ability)
            
            try abilityContainer.encode(ability, forKey: .name)
        }
    }
    
}

let url = URL(string: "https://pokeapi.co/api/v2/pokemon/4")!
let data = try! Data(contentsOf: url)

let decoder = JSONDecoder()
let charmander = try! decoder.decode(Pokemon.self, from: data)


let encoder = JSONEncoder()

encoder.outputFormatting = .prettyPrinted
let charmanderData = try! encoder.encode(charmander)

let dataAsString = String(data: charmanderData, encoding: .utf8)!
print(dataAsString)
