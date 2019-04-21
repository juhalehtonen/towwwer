# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Towwwer.Repo.insert!(%Towwwer.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Towwwer.Websites
alias Towwwer.Websites.Site
alias Towwwer.Websites.Monitor

:observer.start()

site_urls = [
  "https://wordpress.org/news/"
]

sites =
  Enum.map(site_urls, fn site_url ->
    %{base_url: site_url, token: Towwwer.Tools.Helpers.random_string(32), monitors: [%{}]}
  end)

for site <- sites do
  Websites.create_site(site)
end

receive do
  {:DOWN, ref, :process, object, reason} ->
    true
end
