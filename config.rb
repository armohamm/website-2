##
# Compass
###

require "net/http"

# Determine root locale
root_locale = (ENV["LOCALE"] ? ENV["LOCALE"].to_sym : :nl)
# Accessible as `root_locale` in helpers and `config[:root_locale]` in templates
set :root_locale, root_locale

activate :i18n, mount_at_root: root_locale, langs: %i(nl de en)

set :ga_code, "UA-6700447-1"

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", layout: false
# page "/path/to/file.html", layout: :otherlayout

# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

ready do
  case root_locale
  when :nl
    ignores = ["/blog/de/*", "/jobs/de/*", "/blog/en/*"]
  when :de
    ignores = ["/blog/en/*", "/blog/nl/*", "/jobs/nl/*"]
  when :en
    ignores = ["/blog/de/*", "/blog/nl/*", "/jobs/*"]
  end

  ignores.each do |path|
    ignore path
  end

  sitemap.resources.each do |resource|
    if resource.path =~ /\.html/ &&
       resource.data&.lang_ignore.to_s.include?(I18n.locale.to_s)
      ignore resource.path
    end
  end
end

# # Prevent other locales from building (breaks page_classes)
# if root_locale == :nl
#   (langs - [root_locale, :de]).each do |locale|
#     ignore "/#{locale}/*"
#   end
# else
#   (langs - [root_locale]).each do |locale|
#     ignore "/#{locale}/*"
#   end
# end

page "/*.xml", layout: false
page "/*.json", layout: false
page "/*.txt", layout: false

ignore "/fonts/icons/selection.json"

# Redirects to prevent 404's
unless root_locale == :de
  redirect "blog/tags/learningspaces.html", to: "/blog/tags/capp-agile-learning/"
end

unless root_locale == :en
  redirect "elearning.html", to: "e-learning.html"
  redirect "learningspaces.html", to: "capp-agile-learning.html"
end

# Redirects locale specific
case root_locale
when :nl
  redirect "workshop-convenant-mt.html", to: "convenant-medische-technologie.html"
  redirect "blog/learningspaces-op-websummit.html", to: "/blog/capp-agile-learning-op-websummit/"
  redirect "blog/learningspaces-een-veilige-ruimte-om-te-leren-van-elkaar.html", to: "/blog/capp-agile-learning-een-veilige-ruimte-om-te-leren-van-elkaar/"
when :de
  redirect "elearning-starterkit.html", to: "e-learning-starterkit.html"
  redirect "hosting.html", to: "hosting-sicherheit.html"
  redirect "kundenreferenzen.html", to: "kundenstimmen.html"
when :en
  redirect "capp-11.html", to: "capp-lms.html"
  redirect "organisatie.html", to: "about-us.html"
end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# activate :livereload
# activate :livereload, host: "127.0.0.1"

# Blog
Time.zone = "CET"

activate :blog do |blog|
  blog.name = "blog"
  blog.prefix = "blog"
  blog.permalink = ":title"
  case root_locale
  when :nl
    blog.sources = "/nl/{year}-{month}-{day}-{title}.html"
  when :de
    blog.sources = "/de/{year}-{month}-{day}-{title}.html"
  when :en
    blog.sources = "/en/{year}-{month}-{day}-{title}.html"
  end
  blog.tag_template = "blog/tag.html"
  # blog.calendar_template = "blog/calendar.html"
  blog.paginate = true
  blog.page_link = "{num}"
  blog.per_page = 10
end

activate :blog do |blog|
  blog.name = "jobs"
  blog.prefix = "jobs"
  blog.permalink = ":title"
  case root_locale
  when :nl
    blog.sources = "/nl/{title}.html"
  when :de
    blog.sources = "/de/{title}.html"
  end
  blog.paginate = false
end unless root_locale == :en

page "blog/*", layout: :blog_post_layout
page "blog/tags/*", layout: :blog_layout
page "blog/index.html", layout: :blog_layout
page "blog/feed.xml", layout: false
page "jobs/*", layout: :jobs_post_layout
page "jobs/index.html", layout: :jobs_layout
page "jobs/feed.xml", layout: false

activate :directory_indexes

# Search
activate :search do |search|
  search.resources = ["blog/", "jobs/"]

  ready do
    pages = sitemap.resources.select do |r|
      r.path =~ /\.html/ &&
      r.metadata[:options][:lang] == I18n.locale &&
      !r.path.start_with?(*search.resources) &&
      !(r.data["index"] == false)
    end

    pages.each do |page|
      search.resources << page.path
    end
  end

  case root_locale
  when :nl
    search.language = "du"
  when :de
    search.language = "de"
  when :en
    search.language = "en"
  end

  search.fields = {
    title:   { boost: 100, store: true, required: true },
    content: { boost: 50, store: true },
    url:     { index: false, store: true },
    author:  { boost: 70 },
    type:  { boost: 0, store: true }
  }

  search.before_index = proc do |_to_index, to_store, resource|
    if resource.data.title.is_a?(Hash) && resource.data.title[I18n.locale]
      to_store[:title] = resource.data.title.send(I18n.locale)
    end
    if resource.url.start_with?("/blog/")
      to_store[:type] = "Blog"
    elsif resource.url.start_with?("/jobs/")
      to_store[:type] = t("search.vacancy")
    else
      to_store[:type] = t("search.page")
    end
    if resource.data.author.present?
      to_store[:author] = resource.data.author
    end
  end
end

activate :autoprefixer do |config|
  config.browsers = ["last 3 versions", "Explorer >= 9"]
end

activate :minify_html do |html|
  html.remove_multi_spaces        = true
  html.remove_comments            = true
  html.remove_intertag_spaces     = false
  html.remove_quotes              = true
  html.simple_doctype             = false
  html.remove_script_attributes   = true
  html.remove_style_attributes    = true
  html.remove_link_attributes     = true
  html.remove_form_attributes     = false
  html.remove_input_attributes    = true
  html.remove_javascript_protocol = true
  html.remove_http_protocol       = false
  html.remove_https_protocol      = false
  html.preserve_line_breaks       = false
  html.simple_boolean_attributes  = true
  html.preserve_patterns          = nil
end

set :relative_links, true
set :css_dir, "stylesheets"
set :js_dir, "javascripts"
set :images_dir, "images"

# Middleman syntax (https://github.com/middleman/middleman-syntax)
activate :syntax #, line_numbers: true

set :markdown_engine, :kramdown
set :markdown, input: "GFM", auto_ids: false

#set :markdown_engine, :redcarpet
#set :markdown, fenced_code_blocks: true, smartypants: true

###
# Build
###

configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :asset_hash, ignore: ["images/blog/featured", "images/logos/defacto.png"]

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

###
# Deploy
###

# Deploy for each locale
case root_locale
when :nl
  activate :deploy do |deploy|
    deploy.method = :git
    deploy.remote = "git@github.com:DefactoSoftware/website.git"
  end
when :de
  activate :deploy do |deploy|
    deploy.method = :git
    deploy.remote = "git@github.com:DefactoSoftware/website-de.git"
  end
when :en
  activate :deploy do |deploy|
    deploy.method = :git
    deploy.remote = "git@github.com:DefactoSoftware/website-en.git"
  end
end

###
# Ready callback
###

ready do
  sprockets.import_asset "jquery.js"

  # validate data/downloads.yml
  validate_downloads(data.downloads)
end

after_build do
  # rename CNAME for gh-pages after build
  File.rename "build/CNAME.html", "build/CNAME"
end

###
# Helpers
###

helpers do
  # Get full locale (eg. nl_NL)
  def full_locale(lang=I18n.locale.to_s)
    case lang
      when "en"
        "en_US"
      else
        "#{lang.downcase}_#{lang.upcase}"
    end
  end

  # Get full url
  def full_url(url, locale = I18n.locale)
    URI.join("https://#{I18n.t('CNAME', locale: locale)}", url).to_s
  end

  # Use frontmatter for I18n titles
  def page_title(page, appendCompanyName=true)
    appendTitle = appendCompanyName ? " - Defacto" : ""
    return page.data.title.send(I18n.locale) + appendTitle if
      page.data.title.is_a?(Hash) && page.data.title[I18n.locale]
    return page.data.title + appendTitle if page.data.title
    "Defacto - Developing People"
  end

  # Use frontmatter for meta description
  def meta_description(page = current_page)
    return yield_content(:meta_description) if content_for?(:meta_description)
    return page.data.description.send(I18n.locale) if
      page.data.description.is_a?(Hash) && page.data.description[I18n.locale]
    return page.data.description if page.data.description
    return Nokogiri::HTML(page.summary(160)).text if is_blog_article?
    t("head.default_description")
  end

  # Use frontmatter for canonical urls
  def canonical
    if current_page.data.canonical_url
      html = ""
      if current_page.data.canonical_url.is_a?(Hash) && current_page.data.canonical_url[I18n.locale]
        url = current_page.data.canonical_url.send(I18n.locale)
      else
        url = current_page.data.canonical_url
      end
      html << tag(:link, rel: "canonical", href: url)
    end
    html
  end

  # Use frontmatter for meta robots or use default
  def robots(page = current_page)
    return page.data.robots if page.data.robots
    "noydir,noodp,index,follow"
  end

  # Page body classes
  def page_classes(path = current_path.dup, options = {})
    # Prevent page classes from being translated
    unless I18n.locale == :nl || is_blog?
      default_path = sitemap.resources.select do |resource|
        resource.proxied_to == current_page.proxied_to &&
          resource.metadata[:options][:lang] == :nl
      end.first
      path = default_path.destination_path.dup if default_path
    end

    # Create classes from path
    classes = super(path.sub(/^[a-z]{2}\//, ""), options)

    if is_blog_index?
      # Replace `blog_#_index` with `blog_index`
      classes.sub!(/blog_\d+_index/, "blog_index")
    elsif is_blog_article?
      classes += " blog-article"
    elsif current_page.url == "/capp-entwickeln/"
      # Replace `capp-entwickeln` with `capp-lms`
      classes.sub!("capp-entwickeln capp-entwickeln_index", "capp-lms")
    end

    # Prepend language class
    classes.prepend("#{I18n.locale} ")
  end

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
  def locale_url_for(url, options={})
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

  # Link_to with active class if current_page
  def nav_link_to(*args, &block)
    url_arg_index = block_given? ? 0 : 1
    options_index = block_given? ? 1 : 2
    args[options_index] ||= {}
    options = args[options_index].dup

    is_active = url_for(args[url_arg_index].split("#")[0], relative: false) ==
                url_for(current_page.url, relative: false)
    options[:class] ||= ""
    options[:class] << " active" if is_active

    args[options_index] = options
    locale_link_to(*args, &block)
  end

  # Country flags
  def country_flags
    flag_titles = { nl: "Nederlands", de: "Deutsch", en: "English" }
    html = ""
    (langs - [I18n.locale]).each do |lang|
      img = image_tag("flags/#{lang}.png", alt: flag_titles[lang])
      if is_blog_index?
        url = full_url("/blog/", lang)
      elsif jobs_index?
        url = lang == :en ? "/" : full_url("/jobs/", lang)
      elsif current_page.data.unique_for_locale == true
        url = full_url("", lang)
      elsif lang_ignore?(current_page, lang)
        url = full_url("", lang)
      else
        locale_root_path = current_page.locale_root_path
        url = locale_root_path ? locale_root_path : "/"
      end
      html << locale_link_to(img, url, title: flag_titles[lang], locale: lang)
    end
    html
  end

  # Returns alternate link tags for a given page
  def alternate_link_tags(page)
    link_tags = []
    (langs - [I18n.locale]).each do |locale|
      sitemap.resources.select do |resource|
        if (resource.proxied_to == page.proxied_to &&
            resource.metadata[:options][:lang] == locale &&
            !lang_ignore?(resource, locale))
          href = resource.url.sub("/#{locale}/", full_url("/", locale))
          link_tags << tag(:link, rel: :alternate, hreflang: locale, href: href)
          next
        end
      end
    end

    link_tags.join("\n    ")
  end

  def lang_ignore?(page, locale)
    page.data.lang_ignore&.include?(locale.to_s)
  end

  def root_url?
    current_page.url == "/"
  end

  def capp_agile_url?
    current_page.url == "/capp-agile-learning/"
  end

  # Use frontmatter for white nav trigger on certain pages
  def nav_white?
    current_page.data.nav_white
  end

  def header_style
    if current_page.data.header_style
      "header-#{current_page.data.header_style}"
    end
  end

  # String to markdown
  def markitdown(string)
    # Kramdown::Document.new(string, config[:markdown]).to_html
    # Redcarpet::Markdown.new(Redcarpet::Render::HTML, config[:markdown]).render(string)
    Tilt['markdown'].new { string }.render(scope=self)
  end

  # Full lastname for team members
  def full_last_name(person)
    person.prefix ? "#{person.prefix} #{person.lastname}" : person.lastname
  end

  # Get avatar url for team members
  def team_avatar_url(person)
    return person.avatar if person.avatar
    avatar = gravatar_for(person.email)
    return avatar if avatar
    avatar = "/images/team/#{person.firstname.downcase}.jpg"
    return avatar if sitemap.find_resource_by_path(avatar)
    false
  end

  # Email to gravatar
  def gravatar_for(email)
    return false unless email
    hash = Digest::MD5.hexdigest(email.chomp.downcase)
    url = "http://www.gravatar.com/avatar/#{hash}.png?d=404"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    response.code.to_i == 404 ? false : "https://secure.gravatar.com/avatar/#{hash}.png"
  end

  # Is blog?
  def is_blog?(page = current_page)
    page.url.start_with?("/blog/")
  end

  # Is blog index?
  def is_blog_index?(page = current_page)
    (page.url =~ %r{^\/blog\/(\d+\/)?$}).present?
  end

  # Is jobs?
  def jobs_page?(page = current_page)
    page.url.start_with?("/jobs/")
  end

  # Is jobs index?
  def jobs_index?(page = current_page)
    (page.url =~ %r{^\/jobs\/(\d+\/)?$}).present?
  end

  # Get blog author
  def blog_author(article)
    author = article.data.author
    author = author.present? ? author.capitalize : author
    data.team.find{ |person| person[:firstname] == author }
  end

  # Get blog author name
  def blog_author_name(author)
    "#{author.firstname} #{author.prefix} #{author.lastname}"
  end

  # Capitalize tagnames
  def capitalize(tagname)
    tagname = tagname.slice(0, 1).capitalize + tagname.slice(1..-1)
    tagname.gsub(/-[a-z]/, &:upcase)
  end

  # Used to validate data/downloads.yml
  def validate_downloads(hash)
    hash.each do |key, value|
      if value.is_a?(Hash)
        validate_downloads(value)
      elsif value.is_a?(String)
        unless sitemap.find_resource_by_path(value)
          hash[key] = false
          puts "\033[31mWARNING: Download link does not exist '#{value}'\033[0m"
        end
      end
    end
  end
end
