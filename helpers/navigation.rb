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

  # Link_to with aria_current for current_page
  # https://github.com/thoughtbot/middleman-aria_current
  def nav_link_to(*args, &block)
    url_arg_index = block_given? ? 0 : 1
    options_index = block_given? ? 1 : 2
    args[options_index] ||= {}
    options = args[options_index].dup

    arg_url = url_for(args[url_arg_index].split("#")[0], relative: false)

    options["aria-current"] = "page" if arg_url == url_for_current_page

    args[options_index] = options
    locale_link_to(*args, &block)
  end
end
