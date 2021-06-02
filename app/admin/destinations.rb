ActiveAdmin.register Destination do
  permit_params :title, :description, :published, :image, :lang

  index do
    column :title
    column :published
    column 'Language' do |res|
      LANGUAGES.rassoc("#{res.lang}").first
    end
    actions
  end

  filter :title
  filter :published
  filter :lang , label: 'Language', as: :select, collection: -> {LANGUAGES}

  form do |f|
    f.inputs do
      f.input :lang, :label => 'Language', :as => :select, :collection => LANGUAGES, input_html: { style: "width: 100px; height: 30px"}
      f.input :title
      f.input :description, as: :quill_editor
      f.input :image
      f.input :published
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :description do | dst |
        dst.description.html_safe
      end
      row :image do |dst|
        image_tag dst.image.url
      end
      row :published
    end
  end

end
