defmodule Day20 do
  def call(type \\ :example) do
    data = load(type)

    modules = build_modules(data) |> IO.inspect()

    {result, _} =
      1..1000
      |> Enum.reduce({[], modules}, fn _, {pulses_made, modules} ->
        {modules, pulses} = cycle(modules)

        {pulses ++ pulses_made, modules}
      end)

    low = Enum.count(result, &(&1 == :low)) |> IO.inspect(label: "LOW")
    high = Enum.count(result, &(&1 == :high)) |> IO.inspect(label: "HIGH")

    low * high

    # result

    # cycle(modules)
  end

  def cycle(modules) do
    module = modules["broadcaster"]

    {pulse, _, queue} = send_pulse(:low, :button, module)

    queue =
      Enum.map(queue, &%{from: "broadcaster", pulse: pulse, module: &1})
      |> IO.inspect(label: "FIRST")

    cycle(modules, queue, [:low])
  end

  def cycle(modules, [], pulses_made), do: {modules, pulses_made}

  def cycle(modules, queue, pulses_made) do
    # IO.inspect(modules, label: "MODULES")
    # IO.inspect(queue, label: "QUEUE")
    # IO.puts("___________________")

    %{modules: modules, queue: queue, new_pulses: new_pulses} =
      Enum.reduce(queue, %{queue: [], modules: modules, new_pulses: []}, fn %{
                                                                              pulse: pulse,
                                                                              module: module_name,
                                                                              from: from
                                                                            },
                                                                            %{
                                                                              queue: queue,
                                                                              modules: modules,
                                                                              new_pulses:
                                                                                new_pulses
                                                                            } = _acc ->
        module = modules[module_name]

        case send_pulse(pulse, from, module) do
          :end ->
            %{modules: modules, queue: queue, new_pulses: [pulse | new_pulses]}

          {new_pulse, updated_module, queue_modules} ->
            new_queue =
              Enum.map(queue_modules, &%{from: module.name, pulse: new_pulse, module: &1})

            queue = queue ++ new_queue
            modules = %{modules | updated_module.name => updated_module}

            %{modules: modules, queue: queue, new_pulses: [pulse | new_pulses]}
        end
      end)

    cycle(modules, queue, pulses_made ++ new_pulses)
  end

  def send_pulse(_, _from, nil) do
    :end
  end

  def send_pulse(pulse, _from, %{name: "broadcaster"} = module) do
    {pulse, module, module.destinations}
  end

  def send_pulse(:low, _from, %{type: "%"} = module) do
    case module.state do
      "off" ->
        {:high, %{module | state: "on"}, module.destinations}

      "on" ->
        {:low, %{module | state: "off"}, module.destinations}
    end
  end

  def send_pulse(:high, _from, %{type: "%"} = module) do
    {nil, module, []}
  end

  def send_pulse(pulse, from, %{state: state, type: "&"} = module) do
    state = %{state | from => pulse}

    new_pulse =
      state
      |> Map.values()
      |> Enum.all?(fn x -> x == :high end)
      |> if do
        :low
      else
        :high
      end

    {new_pulse, %{module | state: state}, module.destinations}
  end

  def build_modules(data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [type_name, destinations] = String.split(line, " -> ", trim: true)

      if type_name == "broadcaster" do
        {"broadcaster",
         %{
           name: "broadcaster",
           destinations: String.split(destinations, ", ", trim: true),
           type: "broadcaster",
           state: nil
         }}
      else
        {type, name} = String.split_at(type_name, 1)
        destinations = String.split(destinations, ", ", trim: true)

        case type do
          "%" ->
            {name,
             %{
               name: name,
               type: "%",
               state: "off",
               destinations: destinations
             }}

          "&" ->
            {name,
             %{
               name: name,
               type: "&",
               state: build_conjuction_state(name, data),
               destinations: destinations
             }}
        end
      end
    end)
    |> Enum.into(%{})
  end

  defp build_conjuction_state(name, data) do
    name
    |> find_conjuction_source(data)
    |> Enum.map(fn source_module ->
      {source_module, :low}
    end)
    |> Enum.into(%{})
  end

  def find_conjuction_source(name, data) do
    data
    |> String.split("\n", trim: true)
    |> Enum.reduce([], fn line, acc ->
      [s, destinations] = String.split(line, " -> ", trim: true)

      if String.contains?(destinations, name) do
        {_, source} = String.split_at(s, 1)
        [source | acc]
      else
        acc
      end
    end)
  end

  def load(:example) do
    File.read!("lib/day20/example.txt") |> String.trim()
  end

  def load(:input), do: Api.get_input(20) |> String.trim()
end
