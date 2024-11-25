defmodule PizzaDeliveryTest do
  use ExUnit.Case

  import Assertions, only: [assert_lists_equal: 2]
  import PizzaDelivery

  describe "find_late_pizzas" do
    test "can find late pizzas" do
      timely_pizzas = generate_on_time_pizzas(3)
      late_pizzas = generate_late_pizzas(2)
      orders = Enum.shuffle(timely_pizzas ++ late_pizzas)

      found_late_pizzas = find_late_pizzas(orders)

      assert Enum.count(found_late_pizzas) == 2
      assert_lists_equal(late_pizzas, Enum.map(found_late_pizzas, &Map.delete(&1, :minutes_late)))
    end

    test "returns empty list when no late pizzas" do
      orders = generate_on_time_pizzas(7)

      assert Enum.empty?(find_late_pizzas(orders))
    end

    test "returns all if really bad traffic day" do
      orders = generate_late_pizzas(8)

      assert Enum.count(find_late_pizzas(orders)) == 8
    end

    test "adds minutes late to results" do
      late_order = time_it_took_to_deliver(27)
      late_pizza = [late_order] |> find_late_pizzas() |> hd()

      assert Map.has_key?(late_pizza, :minutes_late)
      assert Map.get(late_pizza, :minutes_late) == 7
    end
  end

  defp generate_on_time_pizzas(quantity) do
    now = DateTime.utc_now()
    Enum.map(1..quantity, fn _x -> pizza_order(now, Enum.random(1..20)) end)
  end

  defp generate_late_pizzas(quantity) do
    now = DateTime.utc_now()
    Enum.map(1..quantity, fn _x -> pizza_order(now, Enum.random(21..1000)) end)
  end

  defp time_it_took_to_deliver(minutes) do
    now = DateTime.utc_now()
    pizza_order(now, minutes)
  end

  defp pizza_order(current_time, delivery_time) do
    ordered_time = DateTime.add(current_time, -Enum.random(60..480), :minute)
    delivered_time = DateTime.add(ordered_time, delivery_time, :minute)

    %{
      name: "Customer_id_#{Enum.random(1..100)}",
      cost: 15.0,
      ordered_at: DateTime.to_iso8601(ordered_time),
      delivered_at: DateTime.to_iso8601(delivered_time)
    }
  end
end
