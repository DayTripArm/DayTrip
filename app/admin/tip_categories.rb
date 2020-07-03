ActiveAdmin.register TipCategory do
  permit_params :title, :category_type


  index do
    column :title
    column :category_type do |resource|
      case resource.category_type
      when TipCategory::CAR_UPLOAD
       "Car upload tip"
      when TipCategory::DRIVER_PRICE
        "Driver price tip"
      end
    end
    actions
  end

  filter :title
  filter :category_type,  label: 'Category Type', as: :select, collection: -> {TipCategory::TIPS_TYPE}


  form do |f|
    f.inputs do
      f.input :title
      f.input :category_type, as: :select, collection: TipCategory::TIPS_TYPE
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
    end
  end

end
