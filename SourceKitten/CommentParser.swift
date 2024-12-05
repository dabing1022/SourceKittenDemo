struct APIComment {
    let description: String
    let parameters: [Parameter]
    let returns: ReturnValue?
    let throws: String?
    let example: String?
    
    struct Parameter {
        let name: String
        let type: String
        let isOptional: Bool
        let description: String
    }
    
    struct ReturnValue {
        let type: String
        let description: String
        let properties: [Property]?
        
        struct Property {
            let name: String
            let type: String
            let description: String
            let isOptional: Bool
            let properties: [Property]?
        }
    }
}

class CommentParser {
    static func parse(docComment: String) -> APIComment? {
        var description = ""
        var parameters: [APIComment.Parameter] = []
        var returns: APIComment.ReturnValue?
        var throws: String?
        var example: String?
        
        var propertyTree: [String: APIComment.ReturnValue.Property] = [:]
        
        // 按行分割注释
        let lines = docComment.components(separatedBy: .newlines)
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            
            if trimmed.hasPrefix("@param") {
                // 解析格式：@param name {type} {Optional?} description
                let parts = trimmed.dropFirst(6).components(separatedBy: " ")
                if parts.count >= 3 {
                    let name = parts[0]
                    let type = parts[1].trimmingCharacters(in: CharacterSet(charactersIn: "{}"))
                    let isOptional = parts[2].contains("Optional")
                    let description = parts.dropFirst(3).joined(separator: " ")
                    parameters.append(.init(
                        name: name,
                        type: type,
                        isOptional: isOptional,
                        description: description
                    ))
                }
            } else if trimmed.hasPrefix("@returns") {
                // 解析格式：@returns {type} description
                let parts = trimmed.dropFirst(8).components(separatedBy: " ")
                if parts.count >= 2 {
                    let type = parts[0].trimmingCharacters(in: CharacterSet(charactersIn: "{}"))
                    let description = parts.dropFirst(1).joined(separator: " ")
                    returns = .init(
                        type: type,
                        description: description,
                        properties: []
                    )
                }
            } else if trimmed.hasPrefix("@property") {
                // 解析格式：@property path.to.property {type} {Optional?} description
                let parts = trimmed.dropFirst(9).components(separatedBy: " ")
                if parts.count >= 3 {
                    let propertyPath = parts[0].components(separatedBy: ".")
                    let type = parts[1].trimmingCharacters(in: CharacterSet(charactersIn: "{}"))
                    let isOptional = parts[2].contains("Optional")
                    let description = parts.dropFirst(3).joined(separator: " ")
                    
                    // 创建或更新属性树
                    if propertyPath.count == 1 {
                        // 顶层属性
                        let property = APIComment.ReturnValue.Property(
                            name: propertyPath[0],
                            type: type,
                            description: description,
                            isOptional: isOptional,
                            properties: []
                        )
                        propertyTree[propertyPath[0]] = property
                    } else {
                        // 嵌套属性
                        let rootKey = propertyPath[0]
                        if var rootProperty = propertyTree[rootKey] {
                            var currentProperties = rootProperty.properties ?? []
                            var currentPath = rootProperty
                            
                            // 遍历路径创建嵌套属性
                            for i in 1..<propertyPath.count {
                                let key = propertyPath[i]
                                if i == propertyPath.count - 1 {
                                    // 最后一个属性
                                    let leafProperty = APIComment.ReturnValue.Property(
                                        name: key,
                                        type: type,
                                        description: description,
                                        isOptional: isOptional,
                                        properties: nil
                                    )
                                    currentProperties.append(leafProperty)
                                } else {
                                    // 中间节点
                                    if let existingProperty = currentProperties.first(where: { $0.name == key }) {
                                        currentPath = existingProperty
                                        currentProperties = existingProperty.properties ?? []
                                    } else {
                                        let newProperty = APIComment.ReturnValue.Property(
                                            name: key,
                                            type: "Object",
                                            description: "嵌套对象",
                                            isOptional: false,
                                            properties: []
                                        )
                                        currentProperties.append(newProperty)
                                        currentPath = newProperty
                                        currentProperties = []
                                    }
                                }
                            }
                            
                            rootProperty.properties = currentProperties
                            propertyTree[rootKey] = rootProperty
                        }
                    }
                }
            } else if trimmed.hasPrefix("@throws") {
                throws = trimmed.dropFirst(7).trimmingCharacters(in: .whitespaces)
            } else if trimmed.hasPrefix("@example") {
                example = trimmed.dropFirst(8).trimmingCharacters(in: .whitespaces)
            } else if !trimmed.isEmpty {
                // 其他行作为描述
                if !description.isEmpty {
                    description += "\n"
                }
                description += trimmed
            }
        }
        
        // 将属性树转换为数组
        let properties = Array(propertyTree.values)
        if !properties.isEmpty {
            returns?.properties = properties
        }
        
        return APIComment(
            description: description,
            parameters: parameters,
            returns: returns,
            throws: throws,
            example: example
        )
    }
} 