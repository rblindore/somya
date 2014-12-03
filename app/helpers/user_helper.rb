module UserHelper
  def campus_news_btn
    contan_tag :div, (contan_tag :p, t('campus_news')), class: 'button-label'
  end
end