defmodule Vivid.Frame do
  alias Vivid.{Frame, Point}
  defstruct ~w(width height colour_depth buffer)a

  @moduledoc """
  A frame buffer or something.
  """

  @doc """
  Initialize a frame buffer.

  ## Example

      iex> Vivid.Frame.init(4, 4, 1)
      %Vivid.Frame{
        buffer: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        colour_depth: 1,
        height: 4,
        width: 4
      }
  """
  def init(width \\ 128, height \\ 64, colour_depth \\ 1) do
    %Frame{width: width, height: height, colour_depth: colour_depth, buffer: allocate_buffer(width * height)}
  end

  @doc ~S"""
  Add a shape to the frame buffer.

  ## Examples

      iex> Vivid.Frame.init(5,5,1)
      ...> |> Vivid.Frame.push(Vivid.Line.init(Vivid.Point.init(1,1), Vivid.Point.init(3,3)), 1)
      ...> |> Vivid.Frame.to_string
      ".....\n" <>
      ".X...\n" <>
      "..X..\n" <>
      "...X.\n" <>
      ".....\n"

      iex> Vivid.Frame.init(5,5,1)
      ...> |> Vivid.Frame.push(
      ...>      Vivid.Path.init([
      ...>        Vivid.Point.init(1,1),
      ...>        Vivid.Point.init(1,3),
      ...>        Vivid.Point.init(3,3),
      ...>        Vivid.Point.init(3,1),
      ...>      ]), 1
      ...>    )
      ...> |> Vivid.Frame.to_string
      ".....\n" <>
      ".XXX.\n" <>
      "...X.\n" <>
      ".XXX.\n" <>
      ".....\n"

      iex> Vivid.Frame.init(5,5,1)
      ...> |> Vivid.Frame.push(
      ...>      Vivid.Polygon.init([
      ...>        Vivid.Point.init(1,1),
      ...>        Vivid.Point.init(1,3),
      ...>        Vivid.Point.init(3,3),
      ...>        Vivid.Point.init(3,1),
      ...>      ]), 1
      ...>    )
      ...> |> Vivid.Frame.to_string
      ".....\n" <>
      ".XXX.\n" <>
      ".X.X.\n" <>
      ".XXX.\n" <>
      ".....\n"

  """
  def push(%Frame{buffer: buffer, colour_depth: c, width: w}=frame, shape, colour) when colour <= c do
    points = Vivid.Rasterize.rasterize(shape)
    buffer = Enum.reduce(points, buffer, fn(point, buffer) ->
      x = point |> Point.x
      y = point |> Point.y
      List.replace_at(buffer, (x * w) + y, colour)
    end)
    %{frame | buffer: buffer}
  end

  @doc ~S"""
  Convert a frame buffer to a string for debugging.

  ## Examples

      iex> Vivid.Frame.init(4, 4, 1) |> Vivid.Frame.to_string
      "....\n" <>
      "....\n" <>
      "....\n" <>
      "....\n"
  """
  def to_string(%Frame{colour_depth: 1, buffer: buffer, width: width}) do
    s = buffer
    |> Enum.chunk(width)
    |> Enum.map(fn (row) ->
      row
      |> Enum.map(fn
        0 -> "."
        1 -> "X"
      end)
      |> Enum.join
    end)
    |> Enum.join("\n")
    s <> "\n"
  end

  @doc """
  Print the frame buffer to stdout for debugging.
  """
  def puts(%Frame{}=frame) do
    frame
    |> Frame.to_string
    |> IO.write
    :ok
  end

  defp allocate_buffer(size) do
    Enum.map((1..size), fn(_) -> 0 end)
  end
end