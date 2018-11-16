# frozen_string_literal: true

# Module to switch between our different locales
module LanguageSwitcher
  # Get titles for language flags
  def flag_titles
    { nl: "Nederlands", de: "Deutsch", en: "English" }
  end

  # Get flag image
  def flag_image(lang)
    image_tag("flags/#{lang}.svg", alt: flag_titles[lang])
  end

  # Get exceptions
  def full_exception_url(lang)
    if blog_index?(current_page)
      full_blog_url(lang)
    elsif jobs_index?(current_page)
      full_jobs_url(lang)
    elsif lang_ignore?(current_page, lang)
      full_root_url(lang)
    elsif x404?(current_page)
      full_root_url(lang)
    end
  end

  # Get page flag urls for exception, locale root path or fallback
  def page_flag_url(lang)
    if full_exception_url(lang)
      full_exception_url(lang)
    elsif locale_root_path
      locale_root_path
    else
      "/"
    end
  end

  # Build the langague_switcher links
  def language_switcher
    html = +""
    other_locales.each do |lang|
      html << locale_link_to(
        flag_image(lang),
        page_flag_url(lang),
        title: flag_titles[lang],
        locale: lang
      )
    end
    html
  end
end
