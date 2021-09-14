defmodule TokaiMonitorBackend.TokaiMonitorAPIWeb.Params.V1.VideoRankingParams do
  import Ecto.Changeset
  import TokaiMonitorBackend.TokaiMonitorDB.Validator, only: [validate_positive: 2]

  import TokaiMonitorBackend.TokaiMonitorCommon.Constant.Page, only: [sort_types: 0]

  import TokaiMonitorBackend.TokaiMonitorCommon.Constant.Regex, only: [regex_uuid: 0]

  import TokaiMonitorBackend.TokaiMonitorCommon.Constant.VideoStatistic,
    only: [video_statitic_keys: 0]

  use Params.Schema, %{
    :"channel.id!" => :string,
    :"page.page_number!" => :integer,
    :"page.page_size!" => :integer,
    :"page.sort_key!" => :string,
    :"page.sort_type!" => :string
  }

  def changeset(ch, params) do
    super(ch, params)
    |> validate_format(:"channel.id", regex_uuid())
    |> validate_change(:"page.page_number", &validate_positive/2)
    |> validate_change(:"page.page_size", &validate_positive/2)
    |> validate_inclusion(:"page.sort_key", video_statitic_keys())
    |> validate_inclusion(:"page.sort_type", sort_types())
  end
end
