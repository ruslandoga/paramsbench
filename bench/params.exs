nimble_schema =
  NimbleOptions.new!(
    a: [type: :integer, required: true],
    b: [type: :integer, required: true],
    c: [type: :integer]
  )

open_api_spex_schema = %OpenApiSpex.Schema{
  type: :object,
  properties: %{
    a: %OpenApiSpex.Schema{type: :integer},
    b: %OpenApiSpex.Schema{type: :integer},
    c: %OpenApiSpex.Schema{type: :integer}
  }
}

Benchee.run(
  %{
    "manual" => fn input ->
      Enum.each(1..10000, fn _ ->
        %{a: a, b: b} = input

        with true <- is_integer(a),
             true <- is_integer(b),
             c = Map.get(input, :c),
             true <- is_integer(c) or is_nil(c) do
          %{a: a, b: b, c: c}
        else
          _ -> raise "Invalid input"
        end
      end)
    end,
    "ecto_changeset" => fn input ->
      Enum.each(1..10000, fn _ ->
        Ecto.Changeset.cast({%{}, %{a: :integer, b: :integer, c: :integer}}, input, [:a, :b, :c])
        |> Ecto.Changeset.validate_required([:a, :b])
        |> Ecto.Changeset.apply_action!(:validate)
      end)
    end,
    "nimble_options" => fn input ->
      Enum.each(1..10000, fn _ ->
        NimbleOptions.validate(input, nimble_schema)
      end)
    end,
    "open_api_spex" => fn input ->
      Enum.each(1..10000, fn _ ->
        OpenApiSpex.Cast.cast(open_api_spex_schema, input)
      end)
    end
  },
  inputs: %{"ints" => %{a: 1, b: 2, c: 3}},
  profile_after: :tprof
)
