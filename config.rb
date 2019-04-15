# frozen_string_literal: true

# Determine root locale
root_locale = (ENV["LOCALE"] ? ENV["LOCALE"].to_sym : :nl)
# Accessible as `root_locale` in helpers and `config[:root_locale]` in templates
set :root_locale, root_locale

# Activate i18n for root locale
activate :i18n, mount_at_root: root_locale, langs: %i[nl de en]

# Set Google Analytics id
set :ga_code, "UA-6700447-1"

# Set target environments
staging = ENV["STAGING"] == "true"
set :staging, staging

production = ENV["PRODUCTION"] == "true"
set :production, production

# Set timezone
Time.zone = "CET"

# Set a CNAME per target environment
set :cname,
    if staging
      "staging.defacto.nl"
    else
      case root_locale
      when :nl
        "www.defacto.nl"
      when :de
        "www.defactolearning.de"
      when :en
        "en.defacto.nl"
      end
    end

###
# Page options, layouts, aliases and proxies
###

# Ignore the content types in other locales
ready do
  case root_locale
  when :nl
    ignores = [
      "/blog/de/*",
      "/blog/en/*",
      "/jobs/de/*",
      "/jobs/en/*",
      "/cases/de/*"
    ]
  when :de
    ignores = [
      "/blog/en/*",
      "/blog/nl/*",
      "/jobs/en/*",
      "/jobs/nl/*",
      "/cases/nl/*"
    ]
  when :en
    ignores = [
      "/blog/de/*",
      "/blog/nl/*",
      "/jobs/de/*",
      "/jobs/nl/*",
      "/cases/*"
    ]
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

# Ignore the selection file for Icomoon
ignore "/fonts/icons/selection.json"

# Redirects
#
# To prevent 404's we redirect old paths to new paths
# We define redirects per locale in data/redirects.yml

unless root_locale == :de
  redirect "blog/tags/learningspaces.html", to:
           "/blog/tags/capp-agile-learning/"
end

unless root_locale == :en
  redirect "elearning.html", to:
           "e-learning.html"
  redirect "learningspaces.html", to:
           "capp-agile-learning.html"
  redirect "update.html", to:
           "upgrade.html"
end

# Get data yml per locale for redirects
data_redirects =
  case root_locale
  when :nl
    data.redirects_nl
  when :de
    data.redirects_de
  when :en
    data.redirects_en
  end

# Redirect each defined old to new path
data_redirects.each do |redirect|
  redirect redirect.from.to_s, to: redirect.to.to_s
end

# Blog content types

# Activate and setup the blog content type
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
  blog.paginate = true
  blog.page_link = "{num}"
  blog.per_page = 10
end

# Activate and setup the jobs content type
activate :blog do |blog|
  blog.name = "jobs"
  blog.prefix = "jobs"
  blog.permalink = ":title"
  case root_locale
  when :nl
    blog.sources = "/nl/{title}.html"
  when :de
    blog.sources = "/de/{title}.html"
  when :en
    blog.sources = "/en/{title}.html"
  end
  blog.paginate = false
end

# Activate and setup the cases content type
activate :blog do |blog|
  blog.name = "cases"
  blog.prefix = "cases"
  blog.permalink = ":title"
  case root_locale
  when :nl
    blog.sources = "/nl/{title}.html"
  when :de
    blog.sources = "/de/{title}.html"
  end
  blog.paginate = false
end

# Layouts

# With no layout
page "/*.xml", layout: false
page "/*.json", layout: false
page "/*.txt", layout: false

# With layout
page "blog/*", layout: :post_layout
page "blog/tags/*", layout: :blog_layout
page "blog/index.html", layout: :blog_layout
page "blog/tags.html", layout: :blog_layout
page "blog/feed.xml", layout: false
page "jobs/*", layout: :post_layout
page "jobs/index.html", layout: :jobs_layout
page "jobs/feed.xml", layout: false
page "cases/*", layout: :post_layout
page "cases/index.html", layout: :cases_layout
page "cases/feed.xml", layout: false

# Activate directory indexes for pretty urls
activate :directory_indexes

# Activate and setup middleman-search
# https://github.com/manastech/middleman-search
activate :search do |search|
  search.resources = ["blog/", "cases/", "jobs/"]

  ready do
    pages = sitemap.resources.select do |r|
      r.path =~ /\.html/ &&
        r.metadata[:options][:lang] == I18n.locale &&
        !r.path.start_with?(*search.resources) &&
        (r.data["index"] != false)
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

    to_store[:type] = to_store(resource)

    to_store[:author] = resource.data.author if resource.data.author.present?
  end
end

# Store content type metadata for search
def to_store(resource)
  if resource.url.start_with?("/blog/")
    "Blog"
  elsif resource.url.start_with?("/jobs/")
    t("search.vacancy")
  else
    t("search.page")
  end
end

# Activate and setup autoprefixer
activate :autoprefixer do |config|
  config.browsers = ["last 3 versions", "Explorer >= 9"]
end

# Activate and setup minify_html
unless staging
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
end

# Set relative_links to true
set :relative_links, true

# Set assets directories
set :css_dir, "stylesheets"
set :js_dir, "javascripts"
set :images_dir, "images"

# Middleman syntax (https://github.com/middleman/middleman-syntax)
activate :syntax

# Use kramdown for markdown
# https://kramdown.gettalong.org/
set :markdown_engine, :kramdown
set :markdown, input: "GFM",
               auto_ids: true

###
# Build
###

configure :build do
  # Minify CSS on build
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :asset_hash, ignore: [
    "images/logos/defacto.png",
    "images/blog/featured",
    # Image below is used in sn3p's codepen https://codepen.io/snap/pen/NGxgLr
    # and therefore should never be changed
    "images/blog/flexible-cover-images-using-intrinsic-ratio/aspect-ratio-demo.png"
  ]

  # Raise exception for missing translations during build
  require "lib/test_exception_localization_handler"

  I18n.exception_handler = TestExceptionLocalizationHandler.new
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
