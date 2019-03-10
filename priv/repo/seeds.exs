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
  "http://business3.aalto.fi/",
  "https://armadainteractive.com",
  "https://www.businessmodelsinc.com",
  "http://vuosiraportti2016.caruna.fi",
  "http://vuosiraportti2017.caruna.fi/",
  "http://edtechxeurope.com",
  "http://edtechxasia.com",
  "https://www.evermade.fi",
  "https://everyweargames.com",
  "http://www.finrem.fi",
  "https://www.fira.fi",
  "https://www.heureka.fi",
  "https://www.heureka.fi/hop/",
  "https://kuudes.com",
  "https://latotools.com",
  "https://www.maestro.fi",
  "https://www.mesaatio.fi",
  "https://messukeskus.com",
  "https://www.nextgames.com",
  "https://thewalkingdeadnomansland.com",
  "https://www.thewalkingdeadourworld.com",
  "https://compasspointwest.com",
  "https://selanne.com",
  "https://bestfiends.com",
  "https://www.seriously.com",
  "https://www.sofigate.com",
  "https://www.itforbusiness.org",
  "https://talot.kiirava.fi",
  "http://rykmentinpuisto.fi",
  "https://www.vapo.fi",
  "https://www.bref.fi",
  "https://www.helsinkidesignweek.com",
  "https://www.superparkunited.com",
  "https://superpark.fi",
  "https://superpark.com.hk",
  "https://www.superpark.com.sg",
  "https://www.superpark.se",
  "https://www.superpark.com.my",
  "https://www.nitrogames.com",
  "https://www.hintsa.com",
  "https://www.slush.org/",
  "http://ode.abb-drives.com/",
  "https://eastonhelsinki.fi/",
  "https://www.luxhelsinki.fi",
  "https://inspired-minds.co.uk/",
  "http://www.innolink.fi",
  "https://www.hdl.fi/",
  "https://www.hoiva.fi",
  "https://www.learnbt.com/",
  "https://www.rantalainen.fi",
  "https://www.fluidogroup.com",
  "https://www.kaslink.fi",
  "https://www.oodihelsinki.fi",
  "https://www.honka.fi",
  "https://honka.com",
  "http://honka.jp",
  "https://beta.hartela.fi",
  "https://www.mapvision.fi",
  "https://www.actionstadium.com",
  "https://oneblogauthors.f-secure.com/",
  "https://sysart.fi",
  "https://sydan.fi",
  "https://defi.fi",
  "https://www.urheilumuseo.fi",
  "https://www.neova.se",
  "https://www.soste.fi",
  "https://fastems.com",
  "https://www.managebt.org",
  "https://sigma-systems.com",
  "https://nordcloud.com"
]

sites = Enum.map(site_urls, fn(site_url) ->
  %{base_url: site_url, token: Towwwer.Tools.Helpers.random_string(32), monitors: [%{}]}
end)

for site <- sites do
  Websites.create_site(site)
end

receive do
  {:DOWN, ref, :process, object, reason} ->
    true
end
