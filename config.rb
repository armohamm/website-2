# frozen_string_literal: true

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

# Set target environments
staging = ENV["STAGING"] == "true"
set :staging, staging

production = ENV["PRODUCTION"] == "true"
set :production, production

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
    ignores = ["/blog/de/*", "/jobs/de/*", "/blog/en/*", "/cases/de/*"]
  when :de
    ignores = ["/blog/en/*", "/blog/nl/*", "/jobs/nl/*", "/cases/nl/*"]
  when :en
    ignores = ["/blog/de/*", "/blog/nl/*", "/jobs/*", "/cases/*"]
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
  redirect "events.html", to: "evenementenagenda.html"
  redirect "events/gebruikersbijeenkomst-november-2018.html", to: "/evenementenagenda/gebruikersbijeenkomst-november-2018/"
  redirect "workshop-convenant-mt.html", to: "convenant-medische-technologie.html"
  redirect "capp-lms-nieuw.html", to: "capp-lms.html"
  redirect "blog/learningspaces-op-websummit.html", to: "/blog/capp-agile-learning-op-websummit/"
  redirect "blog/learningspaces-een-veilige-ruimte-om-te-leren-van-elkaar.html", to: "/blog/capp-agile-learning-een-veilige-ruimte-om-te-leren-van-elkaar/"
  redirect "referenties.html", to: "klanten.html"
when :de
  redirect "events.html", to: "veranstaltungskalender.html"
  redirect "jobs/consultant.html", to: "/jobs/projektleiter-consultant-softwareimplementierung/"
  redirect "datenschutz.html", to: "datenschutzerklarung.html"
  redirect "elearning-starterkit.html", to: "e-learning-starterkit.html"
  redirect "hosting.html", to: "hosting-sicherheit.html"
  redirect "kundenreferenzen.html", to: "kundenstimmen.html"
  redirect "qualitatspass.html", to: "qualitatspass-qualitatsmonitor.html"
  redirect "referenzen.html", to: "kunden.html"
when :en
  redirect "capp-11.html", to: "capp-lms.html"
  redirect "organisatie.html", to: "about-us.html"
  redirect "references.html", to: "clients.html"
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
end

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

activate :directory_indexes

# Search
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

    if resource.data.author.present?
      to_store[:author] = resource.data.author
    end
  end
end

# Store content types for search
def to_store(resource)
  if resource.url.start_with?("/blog/")
    "Blog"
  elsif resource.url.start_with?("/jobs/")
    t("search.vacancy")
  else
    t("search.page")
  end
end

activate :autoprefixer do |config|
  config.browsers = ["last 3 versions", "Explorer >= 9"]
end

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

set :relative_links, true
set :css_dir, "stylesheets"
set :js_dir, "javascripts"
set :images_dir, "images"

# Middleman syntax (https://github.com/middleman/middleman-syntax)
activate :syntax #, line_numbers: true

set :markdown_engine, :kramdown
set :markdown, input: "GFM",
               auto_ids: true

#set :markdown_engine, :redcarpet
#set :markdown, fenced_code_blocks: true, smartypants: true

# Raise exception when there is a wrong/no i18n key
class TestExceptionLocalizationHandler
  def call(exception, locale, key, options)
    raise exception.to_exception if exception.is_a?(I18n::MissingTranslation)
    super
  end
end

###
# Build
###

configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :asset_hash, ignore: [
    "images/logos/defacto.png",
    "images/blog/featured",
    "images/blog/flexible-cover-images-using-intrinsic-ratio/aspect-ratio-demo.png"
  ]

  I18n.exception_handler = TestExceptionLocalizationHandler.new
end

###
# Deploy
###

# Deploy for each locale
activate :deploy do |deploy|
  deploy.method = :git
  deploy.remote =
    if staging
      "git@github.com:DefactoSoftware/website-staging.git"
    else
      case root_locale
      when :nl
        "git@github.com:DefactoSoftware/website.git"
      when :de
        "git@github.com:DefactoSoftware/website-de.git"
      when :en
        "git@github.com:DefactoSoftware/website-en.git"
      end
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
