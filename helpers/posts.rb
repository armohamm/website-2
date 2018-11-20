# frozen_string_literal: true

# Helpers for Posts
module Posts
  # Get blog author
  def blog_author(article)
    author = article.data.author
    author = author.present? ? author.capitalize : author
    data.team.find { |person| person[:firstname] == author }
  end

  # Get blog author name
  def blog_author_name(author)
    "#{author.firstname} #{author.prefix} #{author.lastname}"
  end

  # Reading time for posts
  def reading_time(input)
    words_per_minute = 200
    words = input.split.size
    minutes = (words / words_per_minute).floor
    minutes <= 1 ? "1" : minutes.to_s
  end

  # Capitalize tagnames
  def capitalize(tagname)
    tagname = tagname.slice(0, 1).capitalize + tagname.slice(1..-1)
    tagname.gsub(/-[a-z]/, &:upcase)
  end

  # Define which partial should be used
  def article_preview_partial_path
    case blog_controller.name
    when :jobs
      "jobs/job-preview"
    when :blog
      "blog/blog-article-preview"
    end
  end

  # Get the other_posts
  def other_posts
    html = +""
    (blog().articles - [current_article])[0...5].each do |article|
      html << "<li>"
      html << partial(article_preview_partial_path, locals: { article: article })
      html << "</li>"
    end
    html
  end
end
