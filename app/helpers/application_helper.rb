module ApplicationHelper

  def full_title(page_title)
    base_title = "Rewrittn"
    return "#{base_title} | #{page_title}" if !page_title.empty?
    base_title
  end

  def parse_source_url(url)
    url = "http://#{url}" if URI.parse(url).scheme.nil?
    host = URI.parse(url).host.downcase
    host.start_with?('www.') ? host[4..-1] : host
  end
end
