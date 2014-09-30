defmodule Watercooler do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(TestApp.Worker, [arg1, arg2, arg3])

      worker(Watercooler.SampleServer, [ 42 ])
    ]

    # Strategies:
    # one_for_one - if one child process terminates and should be restarted, only that child process is affected.
    # one_for_all - if one child process terminates and should be restarted, all other child processes are terminated
    #               and then all child processes are restarted.
    # rest_for_one - if one child process terminates and should be restarted, the 'rest' of the child processes -- i.e.
    #                the child processes after the terminated child process in the start order -- are terminated. Then the terminated child process and all child processes after it are restarted.
    # simple_one_for_one - a simplified one_for_one supervisor, where all child processes are dynamically added instances
    #                      of the same process type, i.e. running the same code.

    opts = [strategy: :one_for_one, name: Watercooler.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
