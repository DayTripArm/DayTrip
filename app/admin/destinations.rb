ActiveAdmin.register Destination do
  permit_params :title, :description, :published, :image

  index do
    column :title
    column :published
    column :created_at
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
