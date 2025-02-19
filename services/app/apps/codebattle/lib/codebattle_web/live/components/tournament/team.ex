defmodule CodebattleWeb.Live.Tournament.TeamComponent do
  use CodebattleWeb, :live_component

  import Codebattle.Tournament.Helpers

  alias CodebattleWeb.Live.Tournament.ChatComponent
  alias CodebattleWeb.Live.Tournament.HeaderComponent
  alias CodebattleWeb.Live.Tournament.PlayersComponent
  alias CodebattleWeb.Live.Tournament.TeamRoundComponent
  alias CodebattleWeb.Live.Tournament.TeamTabComponent

  @impl true
  def mount(socket) do
    {:ok, assign(socket, initialized: false)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container-fluid">
      <div class="row">
        <div class="col-3">
          <.live_component
            id="t-chat"
            module={ChatComponent}
            tournament={@tournament}
            current_user={@current_user}
            messages={@messages}
          />
          <PlayersComponent.render
            tournament={@tournament}
            current_user={@current_user}
            players={get_players(@tournament)}
          />
        </div>
        <div class="col-9 bg-white shadow-sm p-4">
          <.live_component
            id="t-header"
            module={HeaderComponent}
            tournament={@tournament}
            current_user={@current_user}
            time={@time}
          />
          <%= if is_waiting_participants?(@tournament) do %>
            <%= if @time.days == 0 and @time.hours == 0 and @time.minutes >= 0 and @time.seconds >= 0 do %>
              <h3 class="ml-3">
                The tournament will start in <%= @time.minutes %> min(s), <%= @time.seconds %> sec(s)
              </h3>
            <% else %>
              <%= if (@time.days >= 0 and @time.hours > 0) do %>
                <h3 class="ml-3">
                  The tournament will start ~ in <%= @time.days * 24 + @time.hours %> hour(s)
                </h3>
              <% else %>
                <h3 class="ml-3">The tournament will start soon</h3>
              <% end %>
            <% end %>
          <% end %>
          <TeamTabComponent.render
            teams={get_teams(@tournament)}
            tournament={@tournament}
            current_user={@current_user}
          />
          <%= for {round_matches, round} <- Enum.reverse(Enum.with_index(get_round_matches(@tournament))) do %>
            <TeamRoundComponent.render
              teams={get_teams(@tournament)}
              round={round}
              matches={round_matches}
              tournament={@tournament}
              current_user_id={@current_user.id}
            />
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  def render_base_errors(nil), do: nil
  def render_base_errors(errors), do: elem(errors, 0)
end
