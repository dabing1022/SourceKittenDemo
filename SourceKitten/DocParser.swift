struct APIDoc {
    let name: String
    let description: String
    let parameters: [Parameter]
    let returns: ReturnValue?
    let throws: String?
    let example: String?
    
    struct Parameter {
        let name: String
        let type: String
        let description: String
    }
    
    struct ReturnValue {
        let type: String
        let description: String
    }
}

class DocParser {
    static func parse(comment: String) -> APIDoc? {
        var name: String = ""
        var description: String = ""
        var parameters: [APIDoc.Parameter] = []
        var returns: APIDoc.ReturnValue?
        var throws: String?
        var example: String?
        
        // 将注释按行分割
        let lines = comment.components(separatedBy: .newlines)
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            
            if trimmed.hasPrefix("@api") {
                name = trimmed.replacingOccurrences(of: "@api ", with: "")
            } else if trimmed.hasPrefix("@description") {
                description = trimmed.replacingOccurrences(of: "@description ", with: "")
            } else if trimmed.hasPrefix("@param") {
                // 解析参数
                let parts = trimmed.components(separatedBy: " ")
                if parts.count >= 4 {
                    let name = parts[1]
                    let type = parts[2].trimmingCharacters(in: CharacterSet(charactersIn: "{}"))
                    let description = parts[3...].joined(separator: " ")
                    parameters.append(.init(name: name, type: type, description: description))
                }
            } else if trimmed.hasPrefix("@returns") {
                // 解析返回值
                let parts = trimmed.components(separatedBy: " ")
                if parts.count >= 3 {
                    let type = parts[1].trimmingCharacters(in: CharacterSet(charactersIn: "{}"))
                    let description = parts[2...].joined(separator: " ")
                    returns = .init(type: type, description: description)
                }
            }
            // ... 解析其他标签
        }
        
        return APIDoc(
            name: name,
            description: description,
            parameters: parameters,
            returns: returns,
            throws: throws,
            example: example
        )
    }
} 