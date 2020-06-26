ActiveAdmin.register HitTheRoad do
  permit_params :title, :description, :published, :image

  index do
    column :title
    column :created_at
    column :published
    actions
  end

  filter :title

  form do |f|
    f.inputs do
      f.input :title
      f.input :description, as: :text
      f.input :image
      f.input :published
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
      row :published
      row :created_at
      row :updated_at
    end
  end

end
