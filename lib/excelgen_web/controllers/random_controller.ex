defmodule ExcelgenWeb.RandomController do
  use ExcelgenWeb, :controller

  def index(conn, _params) do
    json(conn, %{result: :rand.uniform(1_000_000)})
  end
end
