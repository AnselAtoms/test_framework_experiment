class Foo < ActiveRecord::Base
  def bar
    say_my_name
  end

  def say_my_name
    "Hi, #{name}"
  end
end
