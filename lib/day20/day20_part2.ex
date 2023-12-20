defmodule Day20.Part2 do
  def call(type \\ :example) do
    data = load(type)

    modules = build_modules(data)

    loop(modules, 1)
  end

  def loop(modules, counter) do
    case cycle(modules, counter) do
      :end ->
        counter

      modules ->
        loop(modules, counter + 1)
    end
  end

  def cycle(modules, counter) do
    module = modules["broadcaster"]

    {pulse, _, queue} = send_pulse(:low, :button, module)

    queue =
      Enum.map(queue, &%{from: "broadcaster", pulse: pulse, module: &1})

    cycle(modules, queue, counter)
  end

  def cycle(modules, [], _), do: modules

  def cycle(modules, queue, counter) do
    %{modules: modules, queue: queue} =
      Enum.reduce(queue, %{queue: [], modules: modules}, fn %{
                                                              pulse: pulse,
                                                              module: module_name,
                                                              from: from
                                                            },
                                                            %{
                                                              queue: queue,
                                                              modules: modules
                                                            } = _acc ->
        module = modules[module_name]

        case send_pulse(pulse, from, module) do
          :end ->
            %{modules: modules, queue: queue}

          {new_pulse, updated_module, queue_modules} ->
            new_queue =
              Enum.map(queue_modules, &%{from: module.name, pulse: new_pulse, module: &1})

            queue = queue ++ new_queue
            modules = %{modules | updated_module.name => updated_module}

            %{modules: modules, queue: queue}
        end
      end)

    Enum.find(modules, fn
      {name, module} when name in ["js", "zb", "bs", "rr"] ->
        pulses_in_state = Map.values(module.state)

        :low in pulses_in_state

      _ ->
        false
    end)
    |> case do
      nil ->
        nil

      {name, _module} ->
        IO.inspect("#{name} - #{counter}", label: "GOT IT")
    end

    cycle(modules, queue, counter)
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
