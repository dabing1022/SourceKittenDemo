class ApiSpec
  def initialize
    @api_definitions = {}
    @current_context = nil
  end

  def api(name, &block)
    @current_api = { name: name }
    @current_context = @current_api
    instance_eval(&block)
    @api_definitions[name] = @current_api
  end

  def params(&block)
    previous_context = @current_context
    @current_context = {}
    @current_api[:params] = @current_context
    instance_eval(&block)
    @current_context = previous_context
  end

  def returns(&block)
    previous_context = @current_context
    @current_context = {}
    @current_api[:returns] = @current_context
    instance_eval(&block)
    @current_context = previous_context
  end

  def method_missing(name, **options, &block)
    if block_given?
      # 处理嵌套结构
      previous_context = @current_context
      @current_context[name] = {
        type: options[:type],
        optional: options[:optional],
        description: options[:description],
        options: options[:options],
        properties: {}
      }.compact
      
      # 如果是对象类型，处理其内部属性
      if options[:type] == "Object"
        nested_context = @current_context[name][:properties]
        @current_context = nested_context
        instance_eval(&block)
      end
      
      @current_context = previous_context
    else
      # 处理普通字段
      @current_context[name] = {
        type: options[:type],
        optional: options[:optional],
        description: options[:description],
        options: options[:options]
      }.compact
    end
  end

  def throws(text)
    @current_api[:throws] = text
  end

  def note(text)
    @current_api[:note] = text
  end

  def example(text)
    @current_api[:example] = text
  end

  def summary(text)
    @current_api[:summary] = text
  end

  def get_api_definitions
    @api_definitions
  end

  def self.parse(file_path)
    api_spec = new
    content = File.read(file_path)
    api_spec.instance_eval(content)
    api_spec.get_api_definitions
  end
end

# 使用示例
if __FILE__ == $0
  result = ApiSpec.parse('uploadImage.apispec')
  
  require 'json'
  puts JSON.pretty_generate(result)
  
  require 'yaml'
  puts result.to_yaml
end