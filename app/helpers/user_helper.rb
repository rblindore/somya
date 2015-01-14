module UserHelper

  # This method create a link ffor dashboard page.
  # This methiod required a link name.
  def create_link(name, options={})
    content_tag :div, (content_tag :p, name), class: 'button-label'
  end
end