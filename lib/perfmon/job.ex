defmodule PerfMon.Job do
  @behaviour Rihanna.Job

  @moduledoc """
  Enqueue job for later execution and return immediately:
  Rihanna.enqueue(PerfMon.Job, [arg1, arg2])

  To implement a recurring job have the job reschedule itself after completion
  and Postgres’ ACID guarantees will ensure that it continues running. You will
  need to enqueue the job manually the first time from the console.
  """

  @doc """
  NOTE: `perform/1` is a required callback. It takes exactly one argument. To
  pass multiple arguments, wrap them in a list and destructure in the
  function head as in this example
  """
  def perform([arg1, arg2]) do
    success? = do_some_work(arg1, arg2)

    if success? do
      # job completed successfully
      :ok
    else
      # job execution failed
      {:error, :failed}
    end
  end
end
