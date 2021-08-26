defmodule Excelgen.TaskRegistryTest do
  use ExUnit.Case

  alias Excelgen.TaskRegistry

  test "creates a task" do
    assert :ok = TaskRegistry.start_task("test_id")
  end

  test "looks up the status of an existing task" do
    :ok = TaskRegistry.start_task("test_2")
    assert {:ok, {_, :started}} = TaskRegistry.get_status("test_2")
  end

  test "returns error if checking status of non-existent task" do
    assert {:error, :file_not_found} = TaskRegistry.get_status("doesntexist")
  end

  test "completes a task" do
    :ok = TaskRegistry.start_task("test_done")
    :ok = TaskRegistry.complete_task("test_done")
    assert {:ok, {_, :done}} = TaskRegistry.get_status("test_done")
  end
end
