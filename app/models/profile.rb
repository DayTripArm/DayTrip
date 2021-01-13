class Profile < ApplicationRecord
  belongs_to :login, optional: true
  has_many :booked_trips
  validates_presence_of  :name, message: "cannot be blank"
  scope :user_basic_info, -> (login_id) { select("logins.id, logins.email, profiles.name").joins(:login).find_by(login_id: login_id) }

  scope :drivers_all, -> { includes(:login).where(logins: {user_type: 2}) }
  scope :drivers_all_registered, -> { includes(:login).where(logins: {user_type: 2}).where.not(status: STATUS_PREREG ) }
  scope :drivers_prereg, ->   { includes(:login).where(logins: {user_type: 2}, :status => STATUS_PREREG) }
  scope :drivers_pending, ->   { includes(:login).where(logins: {user_type: 2}, :status => STATUS_REG) }
  scope :drivers_approved, ->  { includes(:login).where(logins: {user_type: 2}, :status => STATUS_ACTIVE) }
  scope :drivers_suspended, ->  { includes(:login).where(logins: {user_type: 2}, :status => STATUS_SUSPENDED) }
  scope :drivers_declined, ->  { includes(:login).where(logins: {user_type: 2}, :status => STATUS_DEACTIVATED) }

  STATUS_PREREG = 0
  STATUS_REG = 1
  STATUS_SUSPENDED = 2
  STATUS_ACTIVE = 3
  STATUS_DEACTIVATED = 4

  def self.STATUSES
    {
        0 => self.TXT_STATUS_PREREG,
        1 => self.TEXT.STATUS_REG,
        2 => self.TXT_STATUS_SUSPENDED,
        3 => self.TXT_ACTIVE,
        4 => self.TXT_STATUS_DEACTIVATED
    }
  end

  def self.TXT_STATUS_PREREG
    I18n.translate("profiles.statuses.preregistrated")
  end

  def self.TXT_STATUS_REG
    I18n.translate("profiles.statuses.registrated")
  end

  def self.TXT_STATUS_SUSPENDED
    I18n.translate("profiles.statuses.suspended")
  end

  def self.TXT_ACTIVE
    I18n.translate("profiles.statuses.active")
  end

  def self.TXT_STATUS_DEACTIVATED
    I18n.translate("profiles.statuses.deactivated")
  end

  def approve!
    update(status:STATUS_ACTIVE)
  end

  def decline!
    update(status: STATUS_DEACTIVATED)
  end

  def suspend!
    update(status: STATUS_SUSPENDED)
  end
end
