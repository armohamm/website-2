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
    lang == :en ? "/" : full_url("/jobs/", lang)
  end

  # Get full url
  def full_url(url, locale = I18n.locale)
    base =
      if staging
        "https://staging.defacto.nl"
      else
        "https://#{I18n.t('CNAME', locale: locale)}"
      end
    URI.join(base, url).to_s
  end
end
