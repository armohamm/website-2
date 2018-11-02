# frozen_string_literal: true

# Helpers for content
module Content
  # String to markdown
  def markitdown(string)
    Tilt["markdown"].new { string }.render
  end

  # Full lastname for team members
  def full_last_name(person)
    person.prefix ? "#{person.prefix} #{person.lastname}" : person.lastname
  end

  # Get avatar url for team members
  def team_avatar_url(person)
    return person.avatar if person.avatar
    avatar = "/images/team/#{person.firstname.downcase}.jpg"
    return avatar if sitemap.find_resource_by_path(avatar)
    false
  end

  # Get clients
  def clients
    all_clients = root_locale == :de ? data["clients_de"] : data["clients"]
    all_clients.clone
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
