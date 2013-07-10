module AdapterRegistry

  module Implementation

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      attr_accessor :traits
      def implements(*traits)
        self.traits = traits
      end

      def adapts_instance(*klasses)
        adapts do |context|
          klasses.any? { |klass| context.is_a?(klass) }
        end
      end

      def adapts_class(*klasses)
        adapts do |context|
          context.is_a?(Class) && klass_is_a?(context, *klasses)
        end
      end

      def adapts(&block)
        self.traits.each do |trait|
          AdapterRegistry.register(trait, self, &block)
        end if (self.traits && block)
      end

      def instance_for(context)
        self.new(context)
      end

      def klass_is_a?(klass, *klasses)
        (klasses.map(&:to_s) & klass.ancestors.map(&:name)).any?
      end

    end

  end

end
