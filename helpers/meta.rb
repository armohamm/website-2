# frozen_string_literal: true

# Helpers for Meta Data
module Meta
  # Get full locale (eg. nl_NL)
  def full_locale(lang = I18n.locale.to_s)
    case lang
    when "en"
      "en_US"
    else
      "#{lang.downcase}_#{lang.upcase}"
    end
  end

  # Append for page_title
  def append_title(append_company_name = true)
    append_company_name ? " - Defacto Software" : ""
  end

  # Use frontmatter or fallback for page title
  def page_title(page)
    frontmatter_title = page.data.title
    if frontmatter_title
      if frontmatter_title.is_a?(Hash) && frontmatter_title[I18n.locale]
        frontmatter_title.send(I18n.locale) + append_title
      else
        frontmatter_title + append_title
      end
    else
      "Defacto - Developing People"
    end
  end

  # Get description from frontmatter
  def frontmatter_description(page = current_page)
    frontmatter_description = page.data.description
    if frontmatter_description.is_a?(Hash) &&
       frontmatter_description[I18n.locale]
      frontmatter_description.send(I18n.locale)
    else
      frontmatter_description
    end
  end

  # Use frontmatter for meta description
  def meta_description(page = current_page)
    if content_for?(:meta_description)
      yield_content(:meta_description)
    elsif frontmatter_description(page)
      frontmatter_description
    elsif is_blog_article?
      Nokogiri::HTML(page.summary(160)).text
    else
      t("head.default_description")
    end
  end

  # Use frontmatter for meta robots or use default
  def robots(page = current_page)
    return page.data.robots if page.data.robots
    "noydir,noodp,index,follow"
  end

  # Get canonical URL if any
  def canonical_url(page = current_page)
    canonical_data = page.data.canonical_url

    if canonical_data.is_a?(Hash) && canonical_data[I18n.locale]
      canonical_data.send(I18n.locale)
    else
      canonical_data
    end
  end

  # Build canonical tag
  def canonical(page = current_page)
    canonical_url(page) ? tag(:link, rel: "canonical", href: canonical_url) : ""
  end

  # Get alternate link tags for a given page
  def alternate_link_tags(page)
    link_tags = []
    other_locales.each do |locale|
      # Loop pages to find the ones proxied_to for each language
      sitemap.resources.select do |r|
        r_full_url = r.url.sub("/#{locale}/", full_url("/", locale))
        next unless r.proxied_to == page.proxied_to &&
                    r.metadata[:options][:lang] == locale &&
                    !lang_ignore?(r, locale)
        href = r_full_url
        link_tags << tag(:link, rel: :alternate, hreflang: locale, href: href)
      end
    end
    link_tags.join("\n    ")
  end
end
