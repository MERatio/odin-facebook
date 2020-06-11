module ApplicationHelper
  def full_title(page_title = '')
    base_title = 'Odin Facebook'
    page_title.empty? ? base_title : page_title + ' | ' + base_title
  end

  def format_date(date)
    date.strftime("%B %d %Y at %I:%S %p")
  end
end
