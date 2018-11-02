# frozen_string_literal: true

# Helpers for current page functions
module Page
  # Root url?
  def root_url?(page = current_page)
    page.url == "/"
  end

  # Url for current_page?
  def url_for_current_page(page = current_page)
    url_for(page.url, relative: false)
  end

  # Blog?
  def blog?(page = current_page)
    page.url.start_with?("/blog/")
  end

  # Case?
  def case?(page = current_page)
    page.url.start_with?("/cases/")
  end

  # Blog index?
  def blog_index?(page = current_page)
    (page.url =~ %r{^\/blog\/(\d+\/)?$}).present?
  end

  # Jobs (post)?
  def jobs_post?(page = current_page)
    page.url.start_with?("/jobs/")
  end

  # Jobs index?
  def jobs_index?(page = current_page)
    (page.url =~ %r{^\/jobs\/(\d+\/)?$}).present?
  end

  # CAPP Agile Learning page?
  def capp_agile_url?(page = current_page)
    page.url == "/capp-agile-learning/"
  end

  # 404?
  def x404?(page = current_page)
    page.url == "/404.html"
  end
end
