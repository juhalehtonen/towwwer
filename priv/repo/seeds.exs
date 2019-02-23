# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PerfMon.Repo.insert!(%PerfMon.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


alias PerfMon.Websites
alias PerfMon.Websites.Site
alias PerfMon.Websites.Monitor

sites= [
  %{base_url: "https://juha.tl", token: "asd", monitors: [%{}]},
  %{base_url: "https://www.evermade.fi", token: "asd", monitors: [%{}]},
]

for site <- sites do
    Websites.create_site(site)
end
