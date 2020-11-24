ActiveAdmin.register Trip do
  permit_params :title, :trip_duration, :start_location, :agenda, :published, destinations_in_trips_attributes: [:id, :stops_title, :position, :trip_id, :destination_id, :_destroy], map_image: [],  images: []

  scope "All", :all
  scope "Top Choices", :top_choices

  index do
    column :title
    column :trip_duration
    column :published
    column :created_at
    actions defaults: true do |t|
      unless t.is_top_choice
      link_to 'Add to Top Choices', change_top_choice_admin_trip_path(t.id)
      else
      link_to 'Remove from Top Choices', change_top_choice_admin_trip_path(t.id)
      end
    end
  end

  filter :title
  filter :published

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :title
      f.input :images, as: :file, input_html: { multiple: true }
      f.input :trip_duration
      f.input :start_location
      f.input :agenda, as: :quill_editor
      f.input :map_image, as: :file, input_html: { multiple: true }
      f.input :published
    end
    f.inputs 'Choose Trip Destinations' do
      f.has_many :destinations_in_trips,
                 new_record: 'Add Destination',
                 sortable: :position,
                 sortable_start: 1,
                 allow_destroy: true do |b|
        b.input :stops_title
        b.input :destination_id, as: :select, :collection => Destination.all.collect {|destination| [destination.title, destination.id]}, input_html: { style: "width: 250px; height: 30px"}
      end
    end
    f.actions
  end

  # Define member actions.
  member_action  :change_top_choice do
    @trip = Trip.find(params[:id])
    if @trip.is_top_choice
      @trip.is_top_choice = false
      message = "Trip has been removed from Top Choices"
    else
      @trip.is_top_choice = true
      message = "Trip has been added to Top Choices"
    end
    @trip.save!
    redirect_to admin_trips_path, :notice => message
  end

  show do
    attributes_table do
      row :title
      row :images do
        ul do
          trip.images.each do |image|
            li class: "no_ponter" do
              image_tag(image.url, class: "image_container")
            end
          end
        end
      end
      row :agenda do | dst |
        dst.agenda.html_safe
      end
      row :trip_duration
      row :start_location
      row :map_image do
        ul do
          trip.map_image.each do |image|
            li class: "no_ponter" do
              image_tag(image.url, class: "image_container")
            end
          end
        end
      end
      row 'Destinations' do
        ul do
          trip.destinations_in_trips.each do |dip|
            dest_title = dip.destination.nil? ? "" : dip.destination.title + " - "
            li do
              dest_title +  dip.stops_title
            end
          end
        end
      end
      row :published
    end
  end


end
