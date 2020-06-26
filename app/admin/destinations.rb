ActiveAdmin.register Destination do
  permit_params :title, :description, :image

  index do
    column :title
    column :created_at
    actions
  end

  filter :title

  form do |f|
    f.inputs do
      f.input :title
      f.input :description, as: :text
      f.input :image
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :description
      row :image do |ad|
        image_tag ad.image.url
      end
      row :created_at
      row :updated_at
    end
  end

end
