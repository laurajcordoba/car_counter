defmodule CarCounter.Repo do
  use Ecto.Repo,
    otp_app: :car_counter,
    adapter: Ecto.Adapters.Postgres
end
