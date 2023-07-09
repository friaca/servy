defmodule PledgeServerTest do
  use ExUnit.Case
  doctest Servy.PledgeServer

  alias Servy.PledgeServer

  describe "tests PledgeServer functionality" do

    setup do
      PledgeServer.start()

      PledgeServer.create_pledge("larry", 10)
      PledgeServer.create_pledge("moe", 20)
      PledgeServer.create_pledge("curly", 30)
      PledgeServer.create_pledge("daisy", 40)
      PledgeServer.create_pledge("grace", 50)

      on_exit(fn -> Process.unregister(:pledge_server) end)

      :ok
    end

    test "caches only the three most recent pledges" do
      recent_pledges = PledgeServer.recent_pledges()

      assert length(recent_pledges) == 3
    end

    test "sums up correctly the amount of the three most recent pledges" do
      total_pledged = PledgeServer.total_pledged()

      assert total_pledged == 120
    end
  end


end
