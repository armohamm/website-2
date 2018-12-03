# frozen_string_literal: true

# Module to switch between our different locales
module LanguageSwitchers
  # Define titles for language flags
  def flag_titles
    { nl: "Nederlands", de: "Deutsch", en: "English" }
  end

  # Get flag image
  def flag_image(lang)
    inline_svg "flags/#{lang}.svg"
  end

  # Get exceptions
  def full_exception_url(lang)
    if blog_index?(current_page)
      full_blog_url(lang)
    elsif jobs_index?(current_page)
      full_jobs_url(lang)
    elsif cases_index?(current_page)
      full_cases_url(lang)
    elsif lang_ignore?(current_page, lang)
      full_root_url(lang)
    elsif x404?(current_page)
      full_root_url(lang)
    end
  end

  # Get page flag urls for exception, locale_root_path or fallback to root
  def page_flag_url(lang)
    if full_exception_url(lang)
      full_exception_url(lang)
    elsif locale_root_path
      locale_root_path
    else
      "/"
    end
  end

  # LinkTitle
  def linktitle_with_flag(lang)
    "<span class='link-title link-icon'>#{flag_image(lang)}#{flag_titles[lang]}</span>"
  end

  # Build the langague_switcher links for desktop navigation
  def language_switcher_desktop
    html = +""
    other_locales.each do |lang|
      html << "<li>"
      html << locale_link_to(
        linktitle_with_flag(lang),
        page_flag_url(lang),
        title: flag_titles[lang],
        locale: lang,
        class: "link-container with-icon"
      )
      html << "</li>"
    end
    html
  end

  # Build the langague_switcher links for desktop navigation
  def language_switcher_mobile
    html = +""
    other_locales.each do |lang|
      html << locale_link_to(
        flag_titles[lang],
        page_flag_url(lang),
        title: flag_titles[lang],
        locale: lang,
        class: "lang"
      )
    end
    html
  end
end
