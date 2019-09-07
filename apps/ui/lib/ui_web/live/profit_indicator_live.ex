defmodule UiWeb.ProfitIndicatorLive do
  use Phoenix.LiveView
  alias Timex, as: T

  def render(assigns) do
    ~L"""
    <div class="box box-default">
      <div class="box-header with-border">
        <h3 class="box-title">Trades</h3>

        <div class="box-tools pull-right">
          <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i>
          </button>
          <button type="button" class="btn btn-box-tool" data-widget="remove"><i class="fa fa-times"></i></button>
        </div>
      </div>
      <!-- /.box-header -->
      <div class="box-body">
        <div class="row">
          <%= if length(@symbols) > 0 do %>
            <div class="col-xs-3">
              <form phx-change="change-symbol" id="change-symbol">
                <select name="selected_symbol" class="form-control">
                  <%= for row <- @symbols do %>
                    <option value="<%= row %>"
                    <%= if row == @symbol do %>
                      selected
                    <% end %>
                    ><%= row %></option>
                  <% end %>
                </select>
              </form>
            </div>
          <% end %>
        </div><br>
        <div class="row">
          <%= for row <- @data do %>
            <div class="col-md-12">
              <div class="info-box bg-green">
                <span class="info-box-icon"><i class="ion ion-ios-plus-outline"></i></span>

                <div class="info-box-content">
                  <span class="info-box-text"><%= row.type %></span>
                  <span class="info-box-number"><%= row.total || 0.0 %></span>

                  <span class="progress-description">
                    <%= @symbol %>
                    <%= if @symbol == "ALL" do %>
                    trading symbols
                    <% end %>
                  </span>
                </div>
                <!-- /.info-box-content -->
              </div>
              <!-- /.info-box -->
            </div>
          <% end %>
        </div>
        <!-- /.row -->
      </div>
      <!-- /.box-body -->
    </div>
    """
  end

  def mount(%{}, socket) do
    symbols = ["ALL" | Hefty.Trades.get_all_trading_symbols()]

    {:ok, assign(socket, data: get_data(), symbol: "ALL", symbols: symbols)}
  end

  def handle_event("change-symbol", %{"selected_symbol" => selected_symbol}, socket) when selected_symbol == "ALL" do
    {:noreply, assign(socket,
      symbol: selected_symbol,
      symbols: socket.assigns.symbols,
      data: get_data()
    )}
  end

  def handle_event("change-symbol", %{"selected_symbol" => selected_symbol}, socket) do
    {:noreply, assign(socket,
      symbol: selected_symbol,
      symbols: socket.assigns.symbols,
      data: get_data(selected_symbol)
    )}
  end

  def get_data(symbol \\ '') do
    [
      %{
        :symbol => symbol,
        :type => :day,
        :total => get_profit_base_currency_from_day(symbol)
      },
      %{
        :symbol => symbol,
        :type => :week,
        :total => get_profit_base_currency_from_week(symbol)
      },
      %{
        :symbol => symbol,
        :type => :all,
        :total => get_profit_base_currency(symbol)
      }
    ]
  end

  defp get_profit_base_currency_from_day(symbol) do
    [from, to] = Hefty.Utils.Datetime.get_last_day(T.now())
    Hefty.Trades.profit_base_currency_by_time(from, to, symbol)
  end

  defp get_profit_base_currency_from_week(symbol) do
    [from, to] = Hefty.Utils.Datetime.get_last_week(T.now())
    Hefty.Trades.profit_base_currency_by_time(from, to, symbol)
  end

    defp get_profit_base_currency(symbol) do
      Hefty.Trades.profit_base_currency(symbol)
    end
end
