module UserHelper
  def campus_news_btn
    content_tag :div, (content_tag :p, t('campus_news')), class: 'button-label'
  end

  def admission
    content_tag :div, (content_tag :p, t('admission')), class: 'button-label'
  end
end