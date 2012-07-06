ActiveAdmin.register Questionnaire do
  scope :active
  scope :future
  scope :past

  index do
    column :title
    column :organization do |q|
      auto_link q.organization
    end
    column :starts_at do |q|
      l(q.starts_at, format: :short) if q.starts_at?
    end
    column :ends_at do |q|
      l(q.ends_at, format: :short) if q.ends_at?
    end
    column :sections do |q|
      link_to_if can?(:read, Section), q.sections.count, [:admin, q, :sections]
    end
    default_actions
  end

  form partial: 'form'

  show do
    attributes_table do
      row :title
      row :organization do |q|
        auto_link q.organization
      end
      row :locale do |q|
        Locale.locale_name(q.locale) if q.locale?
      end
      row :logo do |q|
        link_to(image_tag(q.logo.medium.url), q.logo_url) if q.logo?
      end
      row :description
      row :starts_at do |q|
        l(q.starts_at, format: :long) if q.starts_at?
      end
      row :ends_at do |q|
        l(q.ends_at, format: :long) if q.ends_at?
      end
      row :introduction do |q|
        RDiscount.new(q.introduction).to_html.html_safe if q.introduction?
      end
      row :domain do |q|
        link_to(q.domain, q.domain_url) if q.domain?
      end
      row :google_analytics
      row :twitter_screen_name
      row :twitter_text
      row :twitter_share_text
      row :facebook_app_id
      row :reply_to do |q|
        mail_to(q.reply_to) if q.reply_to?
      end
      row :thank_you_template do |q|
        if q.thank_you_template?
          simple_format Mustache.render(q.thank_you_template, name: t(:example_name), url: 'http://example.com/xxxxxx')
        end
      end
      row :sections do |q|
        ul(class: can?(:update, q) ? 'sortable' : '') do
          q.sections.each do |s|
            li(id: dom_id(s)) do
              if can?(:update, s)
                i(class: 'icon-move')
              end
              text_node link_to_if can?(:read, s), s.title, [:admin, q, s]
            end
          end
        end
        if can? :create, Section
          div link_to t(:new_section), [:new, :admin, q, :section], class: 'button'
        end
        '@todo https://github.com/gregbell/active_admin/pull/1479'
      end
    end
  end

  member_action :sort, method: :post do
    resource.sections.each do |s|
      s.update_attribute :position, params[:section].index(s.id.to_s)
    end
    render nothing: true, status: 204
  end
end
