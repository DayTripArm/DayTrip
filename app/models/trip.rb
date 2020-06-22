class Trip < ApplicationRecord
  include ActionText::Attachable
  has_rich_text :content

  before_create :set_published
  before_update :set_published

  # Set Published At value for trip
  def set_published
    self.published_at = DateTime.now if is_published?
  end
end
