defmodule CodebattleWeb.LayoutView do
  use CodebattleWeb, :view
  import PhoenixGon.View
  import CodebattleWeb.Router.Helpers

  @app_version Application.compile_env(:codebattle, :app_version)

  def get_next_path(conn) do
    next = conn.params["next"]

    case next do
      "" -> conn.request_path
      nil -> conn.request_path
      _ -> next
    end
  end

  def app_short_version() do
    case @app_version do
      nil -> "undefined"
      _ -> String.slice(@app_version, 0, 7)
    end
  end

  def github_commit_link() do
    case @app_version do
      nil -> "/"
      _ -> "https://github.com/hexlet-codebattle/codebattle/commit/#{@app_version}"
    end
  end
end
