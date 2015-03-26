module RewritesHelper
  include ActsAsTaggableOn::TagsHelper

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
end
