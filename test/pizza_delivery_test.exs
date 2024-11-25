defmodule PizzaDeliveryTest do
  use ExUnit.Case
  doctest PizzaDelivery

  test "greets the world" do
    assert PizzaDelivery.hello() == :world
  end
end
