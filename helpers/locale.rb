# frozen_string_literal: true

# Helpers for locales
module Locale
  # Get the other languages than current
  def other_locales
    langs - [I18n.locale]
  end

  # Define if a given page needs to be ignored in a language
  def lang_ignore?(page, locale)
    page.data.lang_ignore&.include?(locale.to_s)
  end
end
