defmodule Day19 do
  def call(type \\ :example) do
    data = load(type)

    parts = parts(data)
    workflows = workflows(data)

    Enum.reduce(parts, [], fn part, acc ->
      case make_workflow(part, "in", workflows) do
        nil ->
          acc

        workflow ->
          [workflow | acc]
      end
    end)
    |> Enum.map(fn x -> Map.values(x) end)
    |> List.flatten()
    |> Enum.sum()
  end

  def make_workflow(_part, "R", _), do: nil
  def make_workflow(part, "A", _), do: part

  def make_workflow(part, workflow_name, workflows) do
    workflow = workflows[workflow_name]

    Enum.reduce_while(workflow.rules, nil, fn rule, _acc ->
      case apply_rule(part, rule) do
        :nope ->
          {:cont, nil}

        goto ->
          {:halt, goto}
      end
    end)
    |> case do
      nil ->
        # default
        make_workflow(part, workflow.default, workflows)

      goto ->
        make_workflow(part, goto, workflows)
    end
  end

  def apply_rule(part, rule) do
    value = part[rule.element]

    is_ok =
      case rule.sign do
        ">" ->
          value > rule.value

        "<" ->
          value < rule.value
      end

    if is_ok, do: rule.goto, else: :nope
  end

  def parts(data) do
    data
    |> String.split("\n\n", trim: true)
    |> Enum.at(1)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.replace("{", "")
      |> String.replace("}", "")
      |> String.split(",", trim: true)
      |> Enum.map(fn part ->
        [key, value] = String.split(part, "=", trim: true)

        {key, String.to_integer(value)}
      end)
      |> Enum.into(%{})
    end)
  end

  def workflows(data) do
    data
    |> String.split("\n\n", trim: true)
    |> Enum.at(0)
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line =
        line
        |> String.replace("}", "")

      [name, rest] = String.split(line, "{", trim: true)

      rest = String.split(rest, ",", trim: true)

      [default | rest] = Enum.reverse(rest)

      rest = Enum.reverse(rest)

      rules =
        Enum.map(rest, fn rule ->
          [r, goto] = String.split(rule, ":", trim: true)

          element = String.at(r, 0)
          sign = String.at(r, 1)

          {_, value} = String.split_at(r, 2)

          value = String.to_integer(value)

          %{
            element: element,
            sign: sign,
            value: value,
            goto: goto
          }
        end)

      {name, %{default: default, rules: rules}}
    end)
    |> Enum.into(%{})
  end

  def load(:example) do
    File.read!("lib/day19/example.txt") |> String.trim()
  end

  def load(:input), do: Api.get_input(19) |> String.trim()
end
