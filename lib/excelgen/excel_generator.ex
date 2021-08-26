defmodule Excelgen.ExcelGenerator do
  require Elixlsx

  alias Elixlsx.Sheet
  alias Elixlsx.Workbook

  alias Excelgen.TaskRegistry

  def generate(filename, body) do
    {time, _} =
      :timer.tc(fn ->
        generate_inner(filename, body)
      end)

    time_ms = div(time, 1_000)

    IO.puts("Generated #{filename} in #{time_ms} ms.")
  end

  def get_file_path(filename), do: "./sheets/#{filename}.xlsx"

  defp generate_inner(filename, body) do
    :ok = TaskRegistry.start_task(filename)

    %Workbook{sheets: [build_body(body)]}
    |> Elixlsx.write_to(get_file_path(filename))

    :ok = TaskRegistry.complete_task(filename)
  end

  defp build_body(body) do
    %Sheet{name: "Sheet 1", rows: body}
  end
end
