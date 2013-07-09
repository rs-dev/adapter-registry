module AdapterRegistry

  class Registry < Hash
    def get_adapter(trait, context)
      if trait_registry = self[trait]
        trait_registry.select do |entry|
          entry[:for].call(context)
        end.first.try(:[], :adapter)
      end
    end

    def get(trait, context)
      if adapter = get_adapter(trait, context)
        adapter.instance_for(context)
      end
    end

    def set(trait, adapter, &block)
      self[trait] ||= Set.new
      self[trait] << {
        adapter: adapter,
        for: block,
      }
    end
  end

end
