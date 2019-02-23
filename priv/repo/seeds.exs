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

site_urls = [
  "http://business3.aalto.fi/",
  "http://armadainteractive.com",
  "http://businessmodelsinc.com",
  "http://vuosiraportti2016.caruna.fi",
  "http://vuosiraportti2017.caruna.fi/",
  "http://edtechxeurope.com",
  "http://edtechxasia.com",
  "http://evermade.fi",
  "http://everyweargames.com",
  "http://finrem.fi",
  "http://fira.fi",
  "http://heureka.fi",
  "http://hopcatalogue.heureka.fi/",
  "http://kuudes.com",
  "http://latotools.com",
  "http://maestro.fi",
  "http://mesaatio.fi",
  "http://messukeskus.com",
  "http://nextgames.com",
  "http://thewalkingdeadnomansland.com",
  "http://www.thewalkingdeadourworld.com",
  "http://compasspointwest.com",
  "http://selanne.com",
  "http://bestfiends.com",
  "http://seriously.com",
  "http://sofigate.com",
  "http://itforbusiness.org",
  "http://kiirava.talointra.fi",
  "http://rykmentinpuisto.fi",
  "http://vapo.fi",
  "http://www.bref.fi",
  "http://www.helsinkidesignweek.com",
  "http://www.superparkunited.com",
  "http://www.superpark.fi",
  "http://www.superpark.hk",
  "http://www.superpark.com.sg",
  "http://www.superpark.se",
  "http://www.superpark.com.my",
  "http://www.nitrogames.com",
  "http://www.hintsa.com",
  "http://www.slush.org/",
  "http://ode.abb-drives.com/",
  "http://eastonhelsinki.fi/",
  "http://luxhelsinki.fi",
  "http://inspired-minds.co.uk/",
  "http://innolink.fi",
  "https://www.hdl.fi/",
  "https://www.hoiva.fi",
  "http://www.learnbt.com/",
  "https://rantalainen.fi",
  "https://fluidogroup.com",
  "http://www.kaslink.fi",
  "https://oodihelsinki.fi",
  "http://honka.fi",
  "http://honka.com",
  "http://honka.jp",
  "http://beta.hartela.fi",
  "http://mapvision.fi",
  "http://actionstadium.com",
  "http://oneblogauthors.f-secure.com/",
  "http://sysart.fi",
  "http://sydan.fi",
  "http://defi.fi",
  "http://urheilumuseo.fi",
  "http://www.neova.se",
  "http://soste.fi",
  "http://fastems.com",
  "http://managebt.org",
  "http://sigma-systems.com",
  "http://nordcloud.com"
]

sites = Enum.map(site_urls, fn(site_url) ->
  %{base_url: site_url, token: PerfMon.Tools.Helpers.random_string(32), monitors: [%{}]}
end)

pid = Process.spawn(fn ->
  for site <- sites do
    Websites.create_site(site)
  end
end, [:link])

receive do
  {:DOWN, ref, :process, object, reason} ->
    true
end
