ActiveAdmin.register TipCategory do
  permit_params :title

  index do
    column :title
    actions
  end

  filter :title

  form do |f|
    f.inputs do
      f.input :title
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
    end
  end

end
