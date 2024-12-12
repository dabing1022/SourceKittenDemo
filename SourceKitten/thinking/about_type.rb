# 方案1：使用辅助方法
def str_or_array
  "String | String[]"
end

def array_of(type)
  "#{type}[]"
end

def union(*types)
  types.join(" | ")
end

api :uploadImage do
  summary "上传图片到服务器"
  
  params do
    # 使用预定义的辅助方法
    imageData type: str_or_array,
             optional: false,
             description: "图片的base64数据,支持单张或多张图片"
    
    # 或者使用 union 方法
    imageData type: union("String", array_of("String")),
             optional: false,
             description: "图片的base64数据,支持单张或多张图片"
             
    type type: "String",
         optional: false,
         description: "图片类型",
         options: ["avatar", "post"]
    # ...
  end
end

# 方案2：使用类型常量
module Types
  STRING = "String"
  NUMBER = "Number"
  BOOLEAN = "Boolean"
  
  def self.array(type)
    "#{type}[]"
  end
  
  def self.or(*types)
    types.join(" | ")
  end
  
  # 预定义常用类型组合
  STRING_OR_ARRAY = or(STRING, array(STRING))
end

api :uploadImage do
  summary "上传图片到服务器"
  
  params do
    imageData type: Types::STRING_OR_ARRAY,
             optional: false,
             description: "图片的base64数据,支持单张或多张图片"
    # ...
  end
end

# 方案3：使用类型构建器
class TypeBuilder
  class << self
    def string
      "String"
    end
    
    def number
      "Number"
    end
    
    def array_of(type)
      "#{type}[]"
    end
    
    def or(*types)
      types.join(" | ")
    end
  end
end

api :uploadImage do
  summary "上传图片到服务器"
  
  params do
    # 使用链式调用
    imageData type: TypeBuilder.or(TypeBuilder.string, TypeBuilder.array_of(TypeBuilder.string)),
             optional: false,
             description: "图片的base64数据,支持单张或多张图片"
    # 或者使用更简洁的写法
    imageData type: TypeBuilder.or("String", "String[]"),
             optional: false,
             description: "图片的base64数据,支持单张或多张图片"
    # ...
  end
end