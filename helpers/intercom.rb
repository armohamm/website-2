# frozen_string_literal: true

# Get Intercom id for given page through frontmatter or use default
module Intercom
  def intercom_id
    if current_page.data.intercom == "servicedesk"
      "yb5mzq3j"
    else
      "tf7cx147"
    end
  end
end
