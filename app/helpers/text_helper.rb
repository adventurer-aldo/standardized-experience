module TextHelper

  def markdown(text)
    text.gsub!("\n", "<br>")
    text.html_safe
  end

end