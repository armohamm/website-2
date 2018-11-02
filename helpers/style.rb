# frozen_string_literal: true

# Helpers for miscellaneous things like styling
module Style
  # Use frontmatter for white nav trigger on given pages
  def nav_white?
    current_page.data.nav_white
  end

  # Defines header_style
  def header_style
    "header-#{current_page.data.header_style}" if current_page.data.header_style
  end
end
