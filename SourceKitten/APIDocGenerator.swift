import Foundation
import Yams

struct APIConfig: Codable {
    var apis: [String: APIDefinition]
    
    struct APIDefinition: Codable {
        var description: String
        var swiftMethod: String
        var parameters: [Parameter]?
        var returns: ReturnValue?
        var throws: String?
        var example: String?
        
        struct Parameter: Codable {
            var name: String
            var type: String
            var description: String
            var options: [String]?
            var properties: [Parameter]?
        }
        
        struct ReturnValue: Codable {
            var type: String
            var description: String
        }
        
        enum CodingKeys: String, CodingKey {
            case description
            case swiftMethod = "swift_method"
            case parameters
            case returns
            case `throws`
            case example
        }
    }
}

class APIDocGenerator {
    static func generateDocs(fromYAML path: String) throws {
        let yamlString = try String(contentsOfFile: path, encoding: .utf8)
        let config = try YAMLDecoder().decode(APIConfig.self, from: yamlString)
        
        // 生成文档、TypeScript 定义等
        generateTypeScriptDefinitions(from: config)
        generateMarkdownDocs(from: config)
        // ...
    }
} 