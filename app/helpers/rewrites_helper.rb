module RewritesHelper
  include ActsAsTaggableOn::TagsHelper
  # TODO not sure if above is necessary

  def parse_source_url(url)
    url = "http://#{url}" if URI.parse(url).scheme.nil?
    host = URI.parse(url).host.downcase
    host.start_with?('www.') ? host[4..-1] : host
  end

  def link_to_you_or_user(user)
    link_to "you", user if user == current_user
    link_to user.name, user if user != current_user
  end

  def written_by(rewrite)
    if rewrite.user == current_user
      link_to "by you", current_user
    else
      if rewrite.anonymous == true
        "anonymously"
      else
        link_to "by #{rewrite.user.name}", rewrite.user
      end
    end
  end

  def reading_time(rewrite)
    content = ""
    content << rewrite.content_before_snippet if rewrite.content_before_snippet?
    content << rewrite.snippet.content
    content << rewrite.content_after_snippet if rewrite.content_after_snippet?

    read_time = content.split.count / 300
    if read_time < 1
      "less than a minute"
    else
      "#{read_time.round} min"
    end
  end
end
