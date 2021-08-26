defmodule Excelgen.ExcelServer do
  use GenServer

  alias Excelgen.TaskRegistry
  alias Excelgen.ExcelGenerator

  # Client methods
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def generate(filename, body) when is_list(body) do
    GenServer.call(__MODULE__, {:generate, filename, body})
  end

  def status(id) do
    GenServer.call(__MODULE__, {:status, id})
  end

  def download(id) do
    GenServer.call(__MODULE__, {:download, id})
  end

  # Server methods
  def init(_) do
    {:ok, nil}
  end

  def handle_call({:generate, title, body}, _, state) do
    filename = "#{title}_#{random_string(6)}_#{date_string()}"

    Task.async(fn ->
      ExcelGenerator.generate(filename, body)
    end)

    {:reply, {:ok, filename}, state}
  end

  def handle_call({:status, id}, _, state) do
    case TaskRegistry.get_status(id) do
      {:ok, {_, status}} -> {:reply, {:ok, status}, state}
      error -> {:reply, error, state}
    end
  end

  def handle_call({:download, id}, _, state) do
    case TaskRegistry.get_status(id) do
      {:ok, {filename, :done}} ->
        {:reply, {:ok, ExcelGenerator.get_file_path(filename)}, state}

      error ->
        {:reply, error, state}
    end
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  # Utils
  def random_string(length) do
    for _ <- 1..length, into: "", do: <<Enum.random('0123456789abcdef')>>
  end

  def date_string() do
    {date, _} = :calendar.universal_time()

    [year, month, day] =
      date
      |> Tuple.to_list()
      |> Enum.map(&String.pad_leading(to_string(&1), 2, "0"))

    "#{year}#{month}#{day}"
  end
end
