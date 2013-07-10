require 'spec_helper'

class Foo
  include AdapterRegistry::Implementation
end

class Bar
end

describe AdapterRegistry do
  let(:registry) { AdapterRegistry::Registry.new }

  before(:each) do
    AdapterRegistry.stub(:registry).and_return(registry)
  end

  context "implements" do
    it "stores an list of traits on the adapter class" do
      Foo.implements(:a, :b)
      Foo.traits.should eq([:a, :b])
    end
  end

  context "adapts" do
    it "creates a registry entry" do
      Foo.should_receive(:traits).twice.and_return([:trait])
      fn = Proc.new {}
      Foo.adapts(&fn)
      registry.should eq({trait: Set.new([{adapter: Foo, for: fn}])})
    end
  end

  context "adapts_instance" do
    it "adapts an instance" do
      class Frobnicator < Foo
        implements :frobnication
      end
      Frobnicator.adapts_instance(Foo)
      registry.get_adapter(:frobnication, Foo.new).should eq(Frobnicator)
      registry.get_adapter(:frobnication, Foo).should_not eq(Frobnicator)
    end
  end

  context "adapts_class" do
    it "adapts a class" do
      class Frobnicator < Foo
        implements :frobnication
      end
      Frobnicator.adapts_class(Foo)
      registry.get_adapter(:frobnication, Foo.new).should_not eq(Frobnicator)
      registry.get_adapter(:frobnication, Foo).should eq(Frobnicator)
    end
  end

  context "registry" do
    it "provides means to register an adapter" do
      fn = Proc.new {}
      registry.set(:trait, Foo, &fn)
      registry.should eq({trait: Set.new([{adapter: Foo, for: fn}])})
    end

    it "provides means to query for an adapter providing a match block" do
      registry.set(:trait, Foo) { |context| context.is_a?(Bar) }
      registry.get_adapter(:trait, Bar.new).should eq(Foo)
    end

    it "provides means to automatically initialize a queried adapter" do
      bar = Bar.new
      registry.set(:trait, Foo) { |context| context.is_a?(Bar) }
      Foo.should_receive(:instance_for).with(bar)
      registry.get(:trait, bar)
    end
  end
end
