defmodule Excelgen.TaskRegistry do
  def init do
    :ets.new(__MODULE__, [:named_table, :public])
    :ok
  end

  def start_task(id) do
    true = :ets.insert_new(__MODULE__, {id, :started})
    :ok
  end

  def get_status(id) do
    case :ets.lookup(__MODULE__, id) do
      [{^id, status}] -> {:ok, {id, status}}
      [] -> {:error, :file_not_found}
      _ -> {:error, :unknown}
    end
  end

  def complete_task(id) do
    true = :ets.insert(__MODULE__, {id, :done})
    :ok
  end
end
