defmodule ZIPCodes do
  @moduledoc """
  Look up the latitude and longitude of a ZIP code.
  """

  use GenServer

  @doc """
  Look up the latitude and longitude of a ZIP code.

  ZIP+4 codes will be truncated to the first five digits.

  ## Examples

      iex> ZIPCodes.lat_long("90210")
      {34.100517, -118.41463}

      iex> ZIPCodes.lat_long("90210-4701")
      {34.100517, -118.41463}

      iex> ZIPCodes.lat_long("99999")
      nil

      iex> ZIPCodes.lat_long("")
      nil

  """
  @spec lat_long(String.t()) :: {float(), float()} | nil
  def lat_long(zip) when is_binary(zip) do
    zip =
      if byte_size(zip) > 5 do
        binary_part(zip, 0, 5)
      else
        zip
      end

    GenServer.call(__MODULE__, {:lat_long, zip})
  end

  @doc false
  def ets_filename() do
    Application.app_dir(:zip_codes, "priv/zip_codes.ets")
  end

  @doc false
  def child_spec(init_arg), do: super(init_arg)

  @doc false
  def start_link(_ \\ []) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl GenServer
  def init(_) do
    :ets.file2tab(:erlang.binary_to_list(ZIPCodes.ets_filename()))
  end

  @impl GenServer
  def handle_call({:lat_long, _zip}, _from, nil), do: {:reply, nil, nil}

  def handle_call({:lat_long, zip}, _from, table) do
    case :ets.lookup(table, zip) do
      [{^zip, {lat, long}}] ->
        {:reply, {lat, long}, table}

      [] ->
        {:reply, nil, table}
    end
  end
end
