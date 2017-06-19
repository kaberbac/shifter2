module ApplicationHelper
  def is_pluralize(count, noun)
    verb = (count == 1) ? "is" : "are"
    "#{verb} #{pluralize(count, noun)}"
  end
end
