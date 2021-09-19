defmodule TokaiMonitorBackend.TokaiMonitorAPIWeb.Params.V1.VideoIncreaseRankingParams do
  import Ecto.Changeset
  import TokaiMonitorBackend.TokaiMonitorDB.Validator, only: [validate_positive: 2]
  import TokaiMonitorBackend.TokaiMonitorCommon.Constant.Page, only: [sort_types: 0]
  import TokaiMonitorBackend.TokaiMonitorCommon.Constant.Regex, only: [regex_uuid: 0]

  import TokaiMonitorBackend.TokaiMonitorCommon.Constant.VideoStatistic,
    only: [video_statitic_keys: 0]

  use Params.Schema, %{
    :"channel.id!" => :string,
    :"period.unit!" => :string,
    :"period.value!" => :integer,
    :key! => :string,
    :sort_type! => :string,
    :"page.page_number!" => :integer,
    :"page.page_size!" => :integer
  }

  @period_units ~w(
    day
    week
    month
    year
  )

  def changeset(ch, params) do
    super(ch, params)
    |> validate_format(:"channel.id", regex_uuid())
    |> validate_inclusion(:"period.unit", @period_units)
    |> validate_change(:"period.value", &validate_positive/2)
    |> validate_inclusion(:key, video_statitic_keys())
    |> validate_inclusion(:sort_type, sort_types())
    |> validate_change(:"page.page_number", &validate_positive/2)
    |> validate_change(:"page.page_size", &validate_positive/2)
  end
end
