# frozen_string_literal: true

# Helper for creating page classes without translations
module PageClasses
  # Page Classes
  def page_classes(path = current_path.dup)
    path = default_path(path)

    classes = super(path.sub(%r/^[a-z]{2}\//, ""))

    if blog_index?
      # Replace `blog_#_index` with `blog_index`
      classes.sub!(/blog_\d+_index/, "blog_index")
    elsif is_blog_article?
      classes += " blog-article"
    elsif classes.include? "capp-entwickeln"
      # Replace `capp-entwickeln` with `capp-lms`
      classes.gsub!("capp-entwickeln", "capp-lms")
    elsif classes.include? "veranstaltungskalender"
      # Replace `veranstaltungskalender` with `evenementenagenda`
      classes.gsub!("veranstaltungskalender", "evenementenagenda")
    end

    classes.prepend("#{I18n.locale} ")
  end

  # Get the path which a page is proxied to
  def proxied_path
    sitemap.resources.select do |resource|
      resource.proxied_to ==
        current_page.proxied_to &&
        resource.metadata[:options][:lang] == :nl
    end.first
  end

  # The proxied_path is default when not NL or Blog
  def default_path(path)
    unless I18n.locale == :nl || blog?
      path = proxied_path.destination_path.dup if proxied_path
    end
    path
  end
end
