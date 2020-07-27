defmodule MeterToFootConverter do
  def convert(:feet, m) do
    m * 3.28084
  end
  
  def convert(:inch, m), do: m * 38
end