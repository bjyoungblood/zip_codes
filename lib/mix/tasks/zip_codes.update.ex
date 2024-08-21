if Mix.env() == :dev do
  defmodule Mix.Tasks.ZipCodes.Update do
    @moduledoc false
    use Mix.Task

    @requirements ["loadpaths"]

    NimbleCSV.define(__MODULE__.CSV, moduledoc: false, separator: "\t", header: true)

    def run(_) do
      table = :ets.new(:zip_codes, [:ordered_set])

      File.stream!("resources/2023_Gaz_zcta_national.txt", :line)
      |> Stream.map(&String.trim/1)
      |> __MODULE__.CSV.parse_stream()
      |> Stream.each(fn [zip, _, _, _, _, lat, long] ->
        {lat, _} = Float.parse(lat)
        {long, _} = Float.parse(long)
        :ets.insert(table, {zip, {lat, long}})
      end)
      |> Stream.run()

      File.mkdir_p!(Application.app_dir(:zip_codes, "priv"))
      :ets.tab2file(table, :erlang.binary_to_list(ZIPCodes.ets_filename()), sync: true)

      Mix.shell().info("Wrote #{:ets.info(table, :size)} ZIP codes to ./priv/zip_codes.ets")

      :ets.delete(table)
    end
  end
end
