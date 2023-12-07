defmodule Api do
  use Tesla
  use Memoize

  plug(Tesla.Middleware.BaseUrl, "https://adventofcode.com/2023/day/")

  plug(Tesla.Middleware.Headers, [
    {"cookie",
     "session=53616c7465645f5f9031148339873ecea14021e69adeb777af041e7a3866ac634788e71e68af58b406b6c3f1997caeb5d616ae6f3316f14f87bcaf147cb8c9ca"}
  ])

  defmemo get_input(day) do
    {:ok, response} = get("#{day}/input")
    response.body
  end
end
