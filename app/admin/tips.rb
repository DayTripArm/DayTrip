ActiveAdmin.register Tip do
  permit_params :title, :description, :tip_category_id

  index do
    column :title
    column do |m|
      tc = m.tip_category_id ? TipCategory.find(m.tip_category_id).title : ''
    end
    actions
  end

  filter :title
  filter :tip_category_title , label: 'Category', as: :select, collection: -> {TipCategory.all.map(&:title)}

  form do |f|
    f.inputs do
      f.input :tip_category_id, as: :select, collection: TipCategory.all.collect {|tc| [tc.title, tc.id]}
      f.input :title
      f.input :description, as: :quill_editor
    end
    f.actions
  end

  show do
    attributes_table do
      row 'Category' do | dst |
        TipCategory.find(dst.tip_category_id).title
      end
      row :title
      row :description do | dst |
        dst.description.html_safe
      end
    end
  end

end
