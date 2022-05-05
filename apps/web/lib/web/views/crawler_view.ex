defmodule Web.CrawlerView do
  use Web, :view

  def render("crawler.json", %{id: id, refresh_period: period}) do
    %{
      id: id,
      refresh_period: period
    }
  end

  def render("message.json", %{message: message}) do
    %{message: message}
  end
end
