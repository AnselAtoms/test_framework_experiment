require 'test_helper'

class FooTest < ActiveSupport::TestCase
  def test_expect_method
    foo = Foo.new(name: 'George')
    expect_method(foo, :say_my_name)
    foo.bar
  end

  def test_expect_no_method
    foo = Foo.new(name: 'George')
    expect_no_method(foo, :say_my_name)
  end

  def test_that_nothing_broke
    foo = Foo.new(name: 'George')
    assert(foo.bar == 'Hi, George')
  end
end
