ActiveAdmin.register Hero do
  permit_params :title, :description, :btn_title, :btn_link, :published, :image

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
      f.input :description, as: :text
      f.input :btn_title, label: 'Button Title'
      f.input :btn_link, label: 'Button Link'
      f.input :image
      f.input :published
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :description
      row :btn_title
      row :btn_link
      row :image do |ad|
        image_tag ad.image.url
      end
      row :published
      row :created_at
      row :updated_at
    end
  end

end
