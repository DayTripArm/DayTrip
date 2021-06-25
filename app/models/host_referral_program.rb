class HostReferralProgram < ApplicationRecord

  validates_presence_of :name
  validates_presence_of :airbnb_link

  before_create :generate_promo_code

  def generate_promo_code
    self.promo_code = SecureRandom.urlsafe_base64(8)
  end
end
