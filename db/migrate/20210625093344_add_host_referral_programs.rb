class AddHostReferralPrograms < ActiveRecord::Migration[6.0]
  def change
    create_table :host_referral_programs do |t|
    t.string :name
    t.string :airbnb_link
    t.string :promo_code
    t.datetime :created_at
    end
  end
end
