# frozen_string_literal: true

# Helpers for internal links
module Navigation
  # Localized link_to
  def locale_link_to(*args, &block)
    url_arg_index = block_given? ? 0 : 1
    options_index = block_given? ? 1 : 2
    args[options_index] ||= {}
    options = args[options_index].dup
    args[url_arg_index] = locale_url_for(args[url_arg_index], options)
    link_to(*args, &block)
  end

  # Localized url_for
  def locale_url_for(url, options = {})
    locale = options[:locale] || I18n.locale
    options[:relative] = false
    url_parts = url.split("#")
    url_parts[0] = extensions[:i18n].localized_path(url_parts[0], locale) ||
                   url_parts[0]
    url = url_parts.join("#")
    url = url_for(url, options)
    # Replace leading locale url segment with domain
    url.sub("/#{locale}/", full_url("/", locale))
  end

  # Get the current_page or match on path starts_with
  def active_page?(path)
    arg_url = url_for(path.split("#")[0], relative: false)
    url_for_page = url_for_current_page()
    path_matches = url_for_page.start_with?(arg_url) && arg_url != "/"

    url_for_page == arg_url || path_matches
  end

  # Link_to with aria_current for active_page
  # https://github.com/thoughtbot/middleman-aria_current
  def nav_link_to(*args, &block)
    url_arg_index = block_given? ? 0 : 1
    options_index = block_given? ? 1 : 2
    args[options_index] ||= {}
    options = args[options_index].dup

    options["aria-current"] = "page" if active_page?(args[url_arg_index])

    args[options_index] = options
    locale_link_to(*args, &block)
  end

  # Get navigation links
  def navigation_items
    all_navigation_items = data["navigations_" + I18n.locale.to_s]
    all_navigation_items.clone
  end
end
