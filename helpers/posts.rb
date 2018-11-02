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
end
