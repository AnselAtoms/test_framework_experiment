module MockingFramework
  class Mocker
    attr_reader :expectations, :context

    def initialize(context)
      @context = context
      @expectations = []
    end

    def expect_method(obj, m)
      @expectations << ExpectMethod.new(obj, m, true)
    end

    def expect_no_method(obj, m)
      @expectations << ExpectMethod.new(obj, m, false)
    end

    def assert_expectations
      expectations.each { |e| e.assert!(context) }
    end

    def restore_bindings
      expectations.each(&:restore!)
    end
  end

  class ExpectMethod
    attr_reader :obj, :m_name, :original, :called, :expect_called

    def initialize(obj, m_name, expect_called)
      @obj = obj
      @m_name = m_name
      @expect_called = expect_called
      @called = false
      redefine_methods!
    end

    def restore!
      original.bind(@obj)
    end

    def assert!(context)
      context.assert(
        called == expect_called,
        "Expected #{obj.inspect} to receive #{m_name}"
      )
    end

    def called!
      @called = true
    end

    private

    def redefine_methods!
      @original = obj.method(m_name).unbind
      obj.instance_variable_set("@expect_method_#{m_name}", self)

      obj.define_singleton_method(m_name) do |*_args|
        instance_variable_get("@expect_method_#{__method__}").called!
      end
    end
  end

  def setup
    super
    @@mocker = Mocker.new(self)
  end

  def expect_method(obj, m)
    @@mocker.expect_method(obj, m)
  end

  def expect_no_method(obj, m)
    @@mocker.expect_no_method(obj, m)
  end

  def teardown
    @@mocker.restore_bindings
    @@mocker.assert_expectations
  end
end
