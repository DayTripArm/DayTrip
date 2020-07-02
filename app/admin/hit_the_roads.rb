ActiveAdmin.register HitTheRoad do
  permit_params :title, :description, :published, :image

  index do
    column :title
    column :created_at
    column :published
    actions
  end

  filter :title
  filter :published

  form do |f|
    f.inputs do
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
        image_tag htr.image.url
      end
      row :published
      row :created_at
      row :updated_at
    end
  end

end
