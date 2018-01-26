defmodule LocalservTest do
  use ExUnit.Case
  doctest Localserv

  test "greets the world" do
    assert Localserv.hello() == :world
  end
end
