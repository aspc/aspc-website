ActiveAdmin.register Event do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  permit_params :name, :start, :end, :location, :description, :host, :details_url, :status, :college_affiliation

  # Track the user admin creating an event via admin panel
  before_create do |event|
    event.submitted_by_user_fk = current_user.id
  end

  before_update do |event|
    event.submitted_by_user_fk = current_user.id unless User.exists?(:id => event.submitted_by_user_fk)
  end

  # Customize what appears on sidebar for the event list
  sidebar "Page Info", only: :index, priority: 0 do
    "Review and approve submitted events here. \n Note: To approve/reject multiple events at once, select them with the checkbox and click 'Batch Actions'"
  end

  # Approval/Rejection from admin panel
  member_action :approve, method: :put do
    resource.approve!
    redirect_to :admin_event, notice: "Event Approved"
  end
  member_action :reject, method: :put do
    resource.reject!
    redirect_to :admin_event, notice: "Event Rejected"
  end

  action_item :view, only: [:show, :edit] do
    link_to 'Approve', approve_admin_event_path(event), method: :put
  end
  action_item :view, only: [:show, :edit] do
    link_to 'Reject', reject_admin_event_path(event), method: :put
  end

  # Batch approve/reject
  batch_action :approve do |event_ids|
    batch_action_collection.find(event_ids).each do |event|
      event.approve!
    end
    redirect_to :admin_events, alert: "The posts have been approved."
  end

  batch_action :reject do |event_ids|
    batch_action_collection.find(event_ids).each do |event|
      event.reject!
    end
    redirect_to :admin_events, alert: "The posts have been rejected."
  end

  # Customize what is shown when editing/creating an event via the admin panel
  # https://activeadmin.info/5-forms.html#default
  form do |f|
    f.semantic_errors
    f.actions

    f.inputs "Event Status" do
      input :status
    end

    f.inputs "Event Details", :name, :location, :description, :host, :details_url, :college_affiliation

    f.inputs "Event Start/End Time" do
      input :start, as: :datetime_picker,
        datepicker_options: {
            min_date: 1.years.ago.to_date,
            max_date: "+1Y"
        }

      input :end, as: :datetime_picker,
        datepicker_options: {
            min_date: 1.years.ago.to_date,
            max_date: "+1Y"
        }
    end
  end
end
