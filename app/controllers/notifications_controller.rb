class NotificationsController < ApplicationController
  before_filter :authenticate_user!
  
  before_filter :load_event
    
  def load_context
    @notification_context = @event ? [@event] : [] 
    @notification_context << @notification
    
  end
  
  def load_event
    if params[:event_id]
      @event = Event.find_by_id(params[:event_id])
    end 
  end
  
  # GET /notifications
  # GET /notifications.xml
  def index
    @notifications = current_user.notifications.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notifications }
    end
  end

  # GET /notifications/1
  # GET /notifications/1.xml
  def show
    @notification = current_user.notifications.find(params[:id])
    @receipients = @notification.receipients.paginate(:page => params[:page] || 1, :per_page => 10)    

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @notification }
    end
  end

  # GET /notifications/new
  # GET /notifications/new.xml
  def new
    @notification = current_user.notifications.new
    load_context
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @notification }
    end
  end

  # GET /notifications/1/edit
  def edit
    @notification = current_user.notifications.find(params[:id])
    load_context
  end

  # POST /notifications
  # POST /notifications.xml
  def create
    @notification = current_user.notifications.new(params[:notification])
    @event = Event.find_by_id(params[:event_id]) if params[:event_id]
    @notification.event = @event if @event
    if @notification.save
      if @event
        redirect_to @event 
      else
        redirect_to(@notification, :notice => 'Notification was successfully created.')
      end        
    end
  end

  # PUT /notifications/1
  # PUT /notifications/1.xml
  def update
    @notification = current_user.notifications.find(params[:id])

    respond_to do |format|
      if @notification.update_attributes(params[:notification])
        format.html { redirect_to(@notification, :notice => 'Notification was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @notification.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.xml
  def destroy
    @notification = current_user.notifications.find(params[:id])
    @notification.destroy

    respond_to do |format|
      format.html { redirect_to(notifications_url) }
      format.xml  { head :ok }
    end
  end
  
  # POST /contacts
  # POST /contacts.xml
  def add_contacts    
    params[:contact_ids] = params[:contact_ids][0].split(', ')
    contacts = current_user.contacts.find(params[:contact_ids])    
    @notification = current_user.notifications.find(params[:id])
    
    contacts = contacts.collect{|el| @notification.contacts.include?(el) ? nil : el}.compact
    contacts.each do |el|
      @notification.receipients.create( :contact_id => el.id, :status => 'active' )
    end
     
    render :update do |page|      
      page.redirect_to(@notification)
    end  
  end  
  
  # POST /contacts
  def remove_contacts    
    params[:contact_ids] = params[:contact_ids].split(',')    
    contacts = current_user.contacts.find(params[:contact_ids])    
    if contacts    
      if params[:notification_id]
        notification = current_user.notifications.find(params[:notification_id])
        contacts = contacts.collect{|el| notification.contacts.include?(el) ? nil : el}.compact
        
        notification.receipients = notification.receipients - notification.receipients.where(:contact_id => params[:contact_ids])
        #redirect_to(contacts_path(:group_id => params[:group_id]), :notice => contacts.size.to_s + ' was successfully removed from' + group.name) 
        render :update do |page|
          page << "location.reload();"
        end      
      end
    end
    
  end 
  
  def process_mails
    notification = Notification.find_by_id(params[:notification_id])
    notification.process_all
    redirect_to(notification, :notice => 'Notification was successfully sended.')
    
  end
end
