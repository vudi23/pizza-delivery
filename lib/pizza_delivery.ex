defmodule PizzaDelivery do
  @type order :: %{
          :name => String.t(),
          :cost => float(),
          :ordered_at => String.t(),
          :delivered_at => String.t()
        }

  @type late_order :: %{
          :name => String.t(),
          :cost => float(),
          :ordered_at => String.t(),
          :delivered_at => String.t(),
          :minutes_late => integer()
        }

  @spec find_late_pizzas([order]) :: [late_order]
  def find_late_pizzas(orders) do
    Enum.reduce(orders, [], fn order, late_orders ->
      delivery_time = calculate_delivery_time(order)

      if delivery_time > 20,
        do: [Map.put(order, :minutes_late, delivery_time - 20) | late_orders],
        else: late_orders
    end)
  end

  defp calculate_delivery_time(order) do
    with {:ok, delivered_at, _utc_offset} <- DateTime.from_iso8601(Map.get(order, :delivered_at)),
         {:ok, ordered_at, _utc_offset} <- DateTime.from_iso8601(Map.get(order, :ordered_at)),
         do: DateTime.diff(delivered_at, ordered_at, :minute)
  end
end
