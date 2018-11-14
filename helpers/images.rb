# frozen_string_literal: true

# https://robots.thoughtbot.com/organized-workflow-for-svg
# https://gist.github.com/bitmanic/0047ef8d7eaec0bf31bb
# Module to inline svg files with a title
module Images
  def inline_svg(filename, options = {})
    asset = sprockets.find_asset(filename)
    file = asset.source.force_encoding("UTF-8")
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css "svg"
    title = options[:title]

    add_title(doc, svg, title) if title

    svg["class"] = options[:class] if options[:class].present?

    doc
  end

  def add_title(doc, svg, title)
    title_node = ::Nokogiri::XML::Node.new "title", doc
    title_node.content = title

    svg.search("title").each(&:remove)
    svg.prepend_child(title_node)
  end
end
