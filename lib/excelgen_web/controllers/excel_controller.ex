defmodule ExcelgenWeb.ExcelController do
  use ExcelgenWeb, :controller

  alias Excelgen.ExcelServer

  def generate(conn, %{"body" => body, "filename" => filename}) do
    {:ok, filename} = ExcelServer.generate(filename, body)
    json(conn, %{sucess: true, filename: filename})
  end

  def status(%Plug.Conn{path_params: %{"id" => id}} = conn, _params) do
    case ExcelServer.status(id) do
      {:ok, status} -> json(conn, %{status: status})
      {:error, :file_not_found} -> conn |> put_status(404) |> json(%{status: "not found"})
    end
  end

  def download(%Plug.Conn{path_params: %{"id" => id}} = conn, _params) do
    case ExcelServer.download(id) do
      {:ok, filepath} -> send_download(conn, {:file, filepath})
      {:error, :file_not_found} -> conn |> put_status(404) |> json(%{status: "not found"})
    end
  end
end
