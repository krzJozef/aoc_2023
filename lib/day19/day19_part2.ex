defmodule Day19.Part2 do
  def call(type \\ :example) do
    data = load(type)

    workflows = workflows(data)

    happy_paths = loop("in", [], workflows)

    happy_paths
    |> Enum.map(fn path ->
      grouped = Enum.group_by(path, &String.first/1)

      x = if grouped["x"], do: calculate_constraints(grouped["x"]) |> Enum.count(), else: 4000
      m = if grouped["m"], do: calculate_constraints(grouped["m"]) |> Enum.count(), else: 4000
      a = if grouped["a"], do: calculate_constraints(grouped["a"]) |> Enum.count(), else: 4000
      s = if grouped["s"], do: calculate_constraints(grouped["s"]) |> Enum.count(), else: 4000

      x * m * a * s
    end)
    |> Enum.sum()
  end

  def loop(name, done_rules, workflows) do
    workflow = workflows[name]

    rules = workflow.rules

    Enum.reduce(rules, [], fn {rules, goto}, acc ->
      case goto do
        "R" ->
          acc

        "A" ->
          [done_rules ++ rules | acc]

        _ ->
          loop(goto, done_rules ++ rules, workflows) ++ acc
      end
    end)
  end

  def calculate_constraints(constraints) do
    higher_bottom_constraint =
      constraints
      |> Enum.filter(&String.contains?(&1, ">"))
      |> case do
        [] ->
          1

        bottom_constraints ->
          bottom_constraints
          |> Enum.map(fn constraint ->
            if String.contains?(constraint, ">=") do
              value =
                String.split(constraint, ">=", trim: true) |> Enum.at(1) |> String.to_integer()

              value
            else
              value =
                String.split(constraint, ">", trim: true) |> Enum.at(1) |> String.to_integer()

              value + 1
            end
          end)
          |> Enum.max()
      end

    lower_top_constraint =
      constraints
      |> Enum.filter(&String.contains?(&1, "<"))
      |> case do
        [] ->
          4000

        top_constraints ->
          top_constraints
          |> Enum.map(fn constraint ->
            if String.contains?(constraint, "<=") do
              value =
                String.split(constraint, "<=", trim: true) |> Enum.at(1) |> String.to_integer()

              value
            else
              value =
                String.split(constraint, "<", trim: true) |> Enum.at(1) |> String.to_integer()

              value - 1
            end
          end)
          |> Enum.min()
      end

    higher_bottom_constraint..lower_top_constraint
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

      {rules, rules_reversed} =
        Enum.reduce(rest, {[], []}, fn rule_string, {acc, previous_rules} ->
          [rule, goto] = String.split(rule_string, ":", trim: true)

          combined_rule = {previous_rules ++ [rule], goto}
          reversed_rule = reverse_rule(rule)

          {acc ++ [combined_rule], previous_rules ++ [reversed_rule]}
        end)

      rules = [{rules_reversed, default} | rules]

      {name, %{name: name, rules: rules}}
    end)
    |> Enum.into(%{})
  end

  def reverse_rule(rule) do
    if String.contains?(rule, ">"),
      do: String.replace(rule, ">", "<="),
      else: String.replace(rule, "<", ">=")
  end

  def load(:example) do
    File.read!("lib/day19/example.txt") |> String.trim()
  end

  def load(:input), do: Api.get_input(19) |> String.trim()
end
