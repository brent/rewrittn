module ApplicationHelper

  def full_title(page_title)
    base_title = "Rewrittn"
    return "#{base_title} | #{page_title}" if !page_title.empty?
    base_title
  end
end
