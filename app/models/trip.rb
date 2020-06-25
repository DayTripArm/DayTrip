class Trip < ApplicationRecord

  before_create :set_published
  before_update :set_published

  # Set Published At value for trip
  def set_published
    self.published_at = DateTime.now if is_published?
  end
end
