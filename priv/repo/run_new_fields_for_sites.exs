# This script is run with:
#   mix run priv/repo/run_new_fields_for_sites.exs

alias Towwwer.Repo
alias Towwwer.Websites.Site
import Ecto.Query

set_site_fields = from(s in Site, update: [set: [wp_content_dir: "wp-content", wp_plugins_dir: "wp-content/plugins"]])
Repo.update_all(set_site_fields, [])
