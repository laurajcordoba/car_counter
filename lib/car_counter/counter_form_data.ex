defmodule CarCounter.CounterFormData do
  import Ecto.Changeset

  defstruct [:name, :count]
  @types %{name: :string, count: :integer}

  def new() do
    %{name: "", count: 0}
  end

  def changeset(form_data, attrs) do
    {form_data, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:name])
    |> Map.put(:action, :validate)
  end
end
