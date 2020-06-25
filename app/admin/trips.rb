ActiveAdmin.register Trip do
  permit_params :title, :content, :is_published

  index do
    column :title
    column :is_published, :label => 'Published'
    column :created_at
    column :published_at
    actions
  end

  filter :title
  filter :is_published

  form do |f|
    f.inputs do
      f.input :title
      f.input :content, as: :text
      f.input :is_published, label: 'Published'
    end
    f.actions
  end

end
