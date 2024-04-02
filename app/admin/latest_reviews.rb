latest_news_page = Proc.new do
    menu :priority => 2
    permit_params :title, :caption, :details_url, :priority

    show do
        attributes_table do
        row :title
        row :caption
        row :details_url
        row :priority
        end
    end

    end

    ActiveAdmin.register LatestNews, :namespace => :admin, &latest_news_page
    ActiveAdmin.register LatestNews, :namespace => :contributor, &latest_news_page