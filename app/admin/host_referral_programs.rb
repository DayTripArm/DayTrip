ActiveAdmin.register HostReferralProgram do
  permit_params :name, :airbnb_link
  actions :index, :show, :new, :create, :destroy
  index do
    column :name
    column :airbnb_link
    column :promo_code
    column :created_at
    actions
  end

  filter :name
  filter :promo_code

  form do |f|
    f.inputs do
      f.input :name, label: 'Host Name'
      f.input :airbnb_link, label: 'AirbnbLink'
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :airbnb_link
      row :promo_code
      row :created_at
    end
  end

end
