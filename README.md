# Adapter Registry

provides a generic registry for traits and classes, where a class adapter can
be stored and recalled in the correct context.

## Installation

```
$ gem install adapter-registry
```

```ruby
require 'adapter-registry'
```

or use ``gem 'adapter-registry'`` in your Gemfile when using bundler.

##Examples

### Implementing Adapters 

```ruby
require 'adapter-registry'

class SomeClass
end

class SomeOtherClass < SomeClass
end

class SomeAdapter
    
  include AdapterRegistry::Implementation

  implements :something # trait, defines the lookup context
  adapts_instance SomeClass # stores the trait/class combination in the registry

  ...

end

class SomeClassAdapter
    
  include AdapterRegistry::Implementation

  implements :something
  adapts_class SomeClass # stores the trait/class or ancestor combination in the registry

  ...

end
```

### Initialization

```ruby
require 'adapter-registry'

AdapterRegistry.load_directories(['./lib/some_adapters', './lib/some_other_adapters'])
```

The ``load`` section should be used in an initializer when using Rails. ``adapter-registry`` uses ``require_dependency`` in favour of ``require`` when included in a Rails context.

### Usage

```ruby
obj = SomeClass.new
adapter = AdapterRegistry.get(:something, obj)

class_adapter = AdapterRegistry.get(:something, SomeOtherClass)

some_other_instance = class_adapter.new # uses the same adapter because SomeClass is an ancestor
```
