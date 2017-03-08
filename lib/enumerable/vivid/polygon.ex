defimpl Enumerable, for: Vivid.Polygon do
  alias Vivid.{Polygon, Point}

  @moduledoc """
  Implements the Enumerable protocol for %Polygon{}
  """

  @doc """
  Returns the number of vertices in the Polygon.

  ## Example

      iex> Vivid.Polygon.init([Vivid.Point.init(1,1), Vivid.Point.init(2,2)]) |> Enum.count
      2
  """
  @spec count(Polygon.t) :: {:ok, non_neg_integer}
  def count(%Polygon{vertices: points}), do: {:ok, Enum.count(points)}

  @doc """
  Returns whether a point is one of this Polygon's vertices.
  *note* not whether the point is *on or inside* the Polygon.

  ## Examples

      iex> Vivid.Polygon.init([Vivid.Point.init(1,1)]) |> Enum.member?(Vivid.Point.init(1,1))
      true

      iex> Vivid.Polygon.init([Vivid.Point.init(1,1)]) |> Enum.member?(Vivid.Point.init(2,2))
      false
  """
  @spec member?(Polygon.t, Point.t) :: {:ok, boolean}
  def member?(%Polygon{vertices: points}, %Point{} = point), do: {:ok, Enum.member?(points, point)}

  @doc """
  Reduces the Polygon's vertices into an accumulator.

  ## Examples

      iex> Vivid.Polygon.init([Vivid.Point.init(1,2), Vivid.Point.init(2,4)]) |> Enum.reduce(%{}, fn (%Vivid.Point{x: x, y: y}, acc) -> Map.put(acc, x, y) end)
      %{1 => 2, 2 => 4}
  """
  @spec reduce(Polygon.t, Collectable.t, (Point.t, Collectable.t -> Collectable.t)) :: Collectable.t
  def reduce(%Polygon{vertices: points}, acc, fun), do: Enumerable.List.reduce(points, acc, fun)
end
