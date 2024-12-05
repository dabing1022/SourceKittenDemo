/// 这是一个示例人物类
/// - Note: 这个类用于演示 SwiftDoc 注释的使用
public class Person {
    
    /// 人物的名字
    private let name: String
    
    /// 人物的年龄
    /// - Important: 年龄必须是正整数
    private let age: Int
    
    /// 创建一个新的人物实例
    /// - Parameters:
    ///   - name: 人物的名字
    ///   - age: 人物的年龄
    /// - Throws: 如果年龄为负数，则抛出 PersonError.invalidAge
    public init(name: String, age: Int) throws {
        guard age >= 0 else {
            throw PersonError.invalidAge
        }
        self.name = name
        self.age = age
    }
    
    /// 获取人物的完整描述
    /// - Returns: 返回包含名字和年龄的描述字符串
    /// - Note: 这个方法会生成一个标准格式的描述
    public func getDescription() -> String {
        return "\(name) 今年 \(age) 岁"
    }

    /// 获取人物的完整描述
    /// @param name {String} {Optional} 返回包含名字和年龄的描述字符串
    /// 这个方法会生成一个标准格式的描述
    public func getDescription2() -> String {
        return "\(name) 今年 \(age) 岁"
    }
    
    /// 检查是否是成年人
    /// - Returns: 如果年龄大于或等于 18 岁返回 true，否则返回 false
    public func isAdult() -> Bool {
        return age >= 18
    }
}

/// 人物相关的错误类型
public enum PersonError: Error {
    /// 表示输入的年龄无效
    case invalidAge
}
