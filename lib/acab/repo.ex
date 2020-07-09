defmodule Acab.Repo do
  use Ecto.Repo,
    otp_app: :acab,
    adapter: Ecto.Adapters.MyXQL
end
