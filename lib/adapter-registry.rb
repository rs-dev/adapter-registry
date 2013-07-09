require 'adapter-registry/registry'
require 'adapter-registry/implementation'

module AdapterRegistry

  def self.registry
    @@registry ||= Registry.new
  end

  def self.get(trait, context)
    registry.get(trait, context)
  end

  def self.register(trait, adapter, &block)
    registry.set(trait, adapter, &block)
  end

  def self.load_directory(path)
    Dir[path].each do |file|
      if defined?(Rails)
        require_dependency(file)
      else
        require(file)
      end
    end
  end

  def self.load_directories(paths)
    paths.each do |path|
      self.load_directory(path)
    end
  end

end
