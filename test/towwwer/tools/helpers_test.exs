defmodule Towwwer.HelpersTest do
  use Towwwer.DataCase
  alias Towwwer.Tools.Helpers

  test "random_string/1 returns a string of specified length" do
    string = Helpers.random_string(16)
    assert is_binary(string)
    assert String.length(string) == 16
  end

  test "compare_scores/2 returns a map of changes" do
    old_report_scores = %{
        desktop: %{
          accessibility: 0.90,
          best_practices: 0.77,
          performance: 0.97,
          pwa: 0.4,
          seo: 0.77
        },
        mobile: %{
          accessibility: 0.88,
          best_practices: 0.77,
          performance: 0.84,
          pwa: 0.42,
          seo: 0.78
        }
    }
    new_report_scores = %{
        desktop: %{
          accessibility: 0.88,
          best_practices: 0.77,
          performance: 0.97,
          pwa: 0.4,
          seo: 0.77
        },
        mobile: %{
          accessibility: 0.88,
          best_practices: 0.77,
          performance: 0.84,
          pwa: 0.42,
          seo: 0.78
        }
    }
    map_diff = Helpers.compare_scores(old_report_scores, new_report_scores)
    assert is_map(map_diff)
  end
end
