/// WebView JavaScript Bridge API
public class JSBridge {
    
    /// 调用原生登录界面
    /// - Parameters:
    ///   - username: 用户名
    ///   - password: 密码
    /// - Returns: 返回登录结果
    /// - Note: 示例代码:
    ///   ```swift
    ///   let result = try await bridge.login("user", "123456")
    ///   ```
    public func login(_ username: String, _ password: String) -> Promise<LoginResult> {
        // 实现代码...
    }
    
    /// 获取当前用户信息
    /// - Returns: 返回用户信息对象
    /// - Note: 示例代码:
    ///   ```swift 
    ///   let userInfo = try await bridge.getUserInfo()
    ///   ```
    public func getUserInfo() -> Promise<UserInfo> {
        // 实现代码...
    }
    
    /// 上传图片到服务器
    /// - Parameters:
    ///   - imageData: 图片的base64数据
    ///   - type: 图片类型，可选值: "avatar" 或 "post"
    ///   - options: 可选配置参数
    ///     - compress: 是否压缩
    ///     - maxSize: 最大尺寸
    /// - Returns: 返回图片URL
    /// - Throws: 如果上传失败则抛出错误
    /// - Note: 示例代码:
    ///   ```swift
    ///   let url = try await bridge.uploadImage(imageData, type: "avatar", options: ["compress": true, "maxSize": 1024])
    ///   ```
    public func uploadImage(_ imageData: String, type: String, options: [String: Any]) -> Promise<String> {
        // 实现代码...
    }
    
    /// 获取用户详细信息
    /// - Parameter userId: 用户ID
    /// - Returns: 返回用户详细信息对象，包含以下属性:
    ///   - nickname: String - 用户昵称
    ///   - age: Int? - 用户年龄(可选)
    ///   - avatar: AvatarInfo - 用户头像信息
    ///     - url: String - 头像URL
    ///     - size: Int? - 头像尺寸(可选)
    ///   - tags: [String]? - 用户标签列表(可选)
    /// - Note: 示例代码:
    ///   ```swift
    ///   let detail = try await bridge.getUserDetail("123")
    ///   print(detail.nickname)
    ///   ```
    public func getUserDetail(_ userId: String) -> Promise<UserDetail> {
        // 实现代码...
    }
}
