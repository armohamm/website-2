# frozen_string_literal: true

# Helpers to get links
module Links
  # Get locale root path
  def locale_root_path(page = current_page)
    page.locale_root_path
  end

  # Get full root url
  def full_root_url(lang)
    full_url("", lang)
  end

  # Get full blog url
  def full_blog_url(lang)
    full_url("/blog/", lang)
  end

  # Get full jobs url
  def full_jobs_url(lang)
    full_url("/jobs/", lang)
  end

  # Get full cases url
  def full_cases_url(lang)
    lang == :en ? "/" : full_url("/cases/", lang)
  end

  # Get full current url
  def full_env_url(url, locale = I18n.locale)
    base = "https://#{I18n.t('CNAME', locale: locale)}"
    URI.join(base, url).to_s
  end

  # Get full url
  def full_url(url, locale = I18n.locale)
    base = "https://#{I18n.t('CNAME', locale: locale)}"
    URI.join(base, url).to_s
  end

  def link_to_with_options(url, options)

  end
end
