ActiveAdmin.register HitTheRoad do
  permit_params :title, :description, :published, :image, :lang

  index do
    column :title
    column 'Language' do |res|
      LANGUAGES.rassoc("#{res.lang}").first
    end
    column :published
    actions
  end

  filter :title
  filter :published

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
      row :description do | htr |
        htr.description.html_safe
      end
      row :image do |htr|
        image_tag htr.image.url, :class => "image_container"
      end
      row :published
      row :created_at
      row :updated_at
    end
  end

end
