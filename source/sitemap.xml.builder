---
layout: false
---

xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  sitemap.resources.select { |page|
    page.path =~ /\.html/ &&
    page.metadata[:options][:lang] == I18n.locale &&
    !(page.data.robots && page.data.robots.include?("noindex")) &&
    !(page.path =~ /CNAME.html/)
    }.each do |page|
      xml.url do
        xml.loc full_url(page.url)
        xml.lastmod Date.today.to_time.iso8601
        if page.data.sitemap_priority
          xml.priority page.data.sitemap_priority
        elsif page.url.start_with?("/blog/tags")
          xml.priority "0.3"
        elsif page.url.start_with?("/blog/") ||
              page.url.start_with?("/cases/") ||
              page.url.start_with?("/jobs/")
          xml.priority "0.5"
        else
          xml.priority "0.8"
        end
      end
  end
end
