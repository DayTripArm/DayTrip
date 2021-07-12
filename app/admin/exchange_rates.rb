ActiveAdmin.register ExchangeRate do
  menu :parent => "Setting"
  actions :all, except: [:show]
  config.filters = false
  permit_params :currency, :exchange_rate

  CURRENCY = ["USD", "EUR", "RUB"]

  index do
    column :currency
    column :exchange_rate
    column :updated_at
    actions
  end


  form do |f|
    f.inputs do
      f.input :currency, :as => :select, :collection => CURRENCY, include_blank: false , input_html: { style: "width: 100px; height: 30px"}
      f.input :exchange_rate, input_html: { style: "width: 100px; height: 20px"}
    f.actions
    end
  end

end
