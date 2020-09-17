ActiveAdmin.register Profile, as: "Drivers" do

  scope "All", :drivers_all, default: true
  scope "Approved", :drivers_approved
  scope "Suspended", :drivers_suspended
  scope "Pending Approval", :drivers_pending

  actions :index, :show
  index do
    column :name
    column :phone
    column :status do |resource|
      case resource.status
      when Profile::STATUS_PREREG
        status_tag "Pending Approval", class: 'orange'
      when Profile::STATUS_SUSPENDED
        status_tag "Suspended", class: 'grey'
      when Profile::STATUS_ACTIVE
        status_tag "Approved", class: 'green'
      when Profile::STATUS_DEACTIVATED
        status_tag "Declined", class: 'red'
      end
    end
    actions
  end

  filter :name

  action_item :approve, only: :show do
    link_to 'Approve', approve_admin_driver_path(resource)
  end
  action_item :suspend, only: :show do
    link_to 'Suspend', suspend_admin_driver_path(resource)
  end
  action_item :decline, only: :show do
    link_to 'Decline', decline_admin_driver_path(resource)
  end

  member_action :approve, method: :get do
    current_status = resource.status
    resource.approve!
    if current_status == Profile::STATUS_SUSPENDED
      UserNotifierMailer.notify_drivers_suspend_approval(params[:id]).deliver_later(wait: 30.seconds)
    else
      UserNotifierMailer.notify_profile_approved(params[:id]).deliver_later(wait: 30.seconds)
    end
    redirect_to admin_drivers_path, notice: "Driver profile has been approved!"
  end

  member_action :suspend, method: :get do
    current_status = resource.status
    if current_status == Profile::STATUS_SUSPENDED
      message = "Driver profile is already suspended."
    else
      resource.suspend!
      message =  "Driver profile has been suspended!"
      UserNotifierMailer.notify_drivers_suspend(params[:id]).deliver_later(wait: 30.seconds)
    end
    redirect_to admin_drivers_path, notice: message
  end

  member_action :decline, method: :get do
    current_status = resource.status
    resource.decline!
    if current_status == Profile::STATUS_SUSPENDED
      UserNotifierMailer.notify_drivers_suspend_rejection(params[:id]).deliver_later(wait: 30.seconds)
    else
      UserNotifierMailer.notify_profile_declined(params[:id]).deliver_later(wait: 30.seconds)
    end
    redirect_to admin_drivers_path, notice: "Driver profile has been declined!"
  end

  show do
    attributes_table do
      row :name
      row :gender
      row :phone
      row :date_of_birth
      row :languages
      row 'ID' do
        ul do
          gov_photos = Photo.where({login_id: params[:id], file_type: Photo::GOV})
          gov_photos.each do |gp|
            li do
              image_tag(PhotosHelper::get_photo_full_path(gp.name, "gov_photos", params[:id]))
            end
          end
        end
      end
      row 'Driving License' do
        ul do
          driving_license = Photo.where({login_id: params[:id], file_type: Photo::LICENSE})
          driving_license.each do |dl|
            li do
              image_tag(PhotosHelper::get_photo_full_path(dl.name, "license_photos", params[:id]))
            end
          end
        end
      end
      row 'Registration Card' do
        ul do
          driving_license = Photo.where({login_id: params[:id], file_type: Photo::REG_CARD})
          driving_license.each do |dl|
            li do
              image_tag(PhotosHelper::get_photo_full_path(dl.name, "reg_card_photos", params[:id]))
            end
          end
        end
      end
      row 'Car Photos' do
        ul do
          car_photos = Photo.where({login_id: params[:id], file_type: Photo::CAR})
          car_photos.each do |cp|
            li do
              image_tag(PhotosHelper::get_photo_full_path(cp.name, "car_photos", params[:id]))
            end
          end
        end
      end
      row 'Profile Photos' do
        ul do
          prof_photos = Photo.where({login_id: params[:id], file_type: Photo::PROFILE})
          prof_photos.each do |pp|
            li do
              image_tag(PhotosHelper::get_photo_full_path(pp.name, "profile_photos", params[:id]), size: "200")
            end
          end
        end
      end
    end
  end
end
