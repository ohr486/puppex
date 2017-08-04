defmodule PuppexTest do
  use ExUnit.Case
  doctest Puppex

  test "greets the world" do
    assert Puppex.hello() == :world
  end
end
