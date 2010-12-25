class ContactsController < ApplicationController
  before_filter :authenticate_user!
  # GET /contacts
  # GET /contacts.xml
  def index
    
    if(params[:group_id])
      @contacts = current_user.groups.find(params[:group_id]).contacts.paginate(:page => params[:page] || 1, :per_page => 10)
    else
      @contacts = current_user.contacts.paginate(:page => params[:page] || 1, :per_page => 10)
    end

  end

  # GET /contacts/1
  # GET /contacts/1.xml
  def show
    @contact = current_user.contacts.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.xml
  def new
    @contact = current_user.contacts.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact = current_user.contacts.find(params[:id])
  end

  # POST /contacts
  # POST /contacts.xml
  def create
    @contact = current_user.contacts.new(params[:contact])

    respond_to do |format|
      if @contact.save
        format.html { redirect_to(@contact, :notice => 'current_user.contacts was successfully created.') }
        format.xml  { render :xml => @contact, :status => :created, :location => @contact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # POST /contacts
  # POST /contacts.xml
  def add_to_group
    contacts = current_user.contacts.find(params[:contact_ids])    
    group = current_user.groups.find(params[:group_id])
    contacts = contacts.collect{|el| group.contacts.include?(el) ? nil : el}.compact
    group.contacts << contacts
    redirect_to(contacts_path, :notice => contacts.size.to_s + ' was successfully added to' + group.name) 
    
  end
  
  # POST /contacts
  # POST /contacts.xml
  def remove_multiple    
    params[:contact_ids] = params[:contact_ids].split(',')    
    contacts = current_user.contacts.find(params[:contact_ids])    
    if contacts    
      if params[:group_id]
        group = current_user.groups.find(params[:group_id])
        contacts = contacts.collect{|el| group.contacts.include?(el) ? nil : el}.compact
        
        group.contacts = group.contacts - group.contacts.where(:id => params[:contact_ids])
        #redirect_to(contacts_path(:group_id => params[:group_id]), :notice => contacts.size.to_s + ' was successfully removed from' + group.name) 
        render :update do |page|
          page << "location.reload();"
        end
        
      else  
        current_user.contacts.where(:id => params[:contact_ids]).destroy_all
        #redirect_to(contacts_path, :notice => contacts.size.to_s  + ' was successfully removed ') 
        render :update do |page|
          page << "location.reload();"
        end        
      end
    end
    
  end  

  # PUT /contacts/1
  # PUT /contacts/1.xml
  def update
    @contact = current_user.contacts.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to(@contact, :notice => 'current_user.contacts was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.xml
  def destroy
    @contact = current_user.contacts.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(contacts_url) }
      format.xml  { head :ok }
    end
  end
  
  def process_gmail
    gmail_contacts = GmailContacts.new
    redirect_url = response_gmail_contacts_path(:email => params['email'], :group_id => params['group_id'], :group_name => params['group_name'], :only_path => false)
    redirect_to gmail_contacts.authsub_url(redirect_url)
  end
  
  def response_gmail
    importer = GmailContacts.new(params["token"].to_s)
    importer.fetch params["email"]
    
    if (importer.contacts.size > 0)
      if(params["group_id"] && params["group_id"].to_i > 0)
        group = current_user.groups.find(params[:group_id])
      else if (params["group_id"] && params["group_id"].to_i == -1 && params["group_name"] && params["group_name"].to_s.length > 0)
          current_user.groups.create(:name => params["group_name"], :description => "Imported contacts from Gmail.")
          group = current_user.groups.find_by_name(params["group_name"])  
      else      
        current_user.groups.create(:name => "Gmail contacts:" + params["email"] , :description => "Imported contacts from Gmail.")
        group = current_user.groups.find_by_name("Gmail contacts:" + params["email"])
      end
      end
      importer.contacts.each do |contact|
         #{:email=>contact.emails.first, :title=>contact.}

         if(contact)
           if(current_user.contacts.where(:email => contact.emails.first).size > 0)
             group.contacts << current_user.contacts.where(:email => contact.emails.first)
           else
           
             contact.title.gsub(",", " ")
             contact.title.gsub("@", " ")
             first_name = contact.title.split(" ")[0]
             unless(contact.title.include?("@")) 
               last_name = contact.title.split(" ")[1]
             end
             unless(first_name)
               first_name = contact.emails.first.split("@")[0]
             end
             group.contacts.create(:user_id => current_user.id, :firstname => first_name, :lastname => last_name, :email => contact.emails.first, :phonenumber => contact.phone_numbers.first)
           end
         end
      end
    end
    
    redirect_to contacts_path(:group_id => group.id)
  end
  
  def get_by_group
    notification = Notification.find_by_id(params[:notification_id])
    if params[:group_id]
      @contacts = Group.find_by_id(params[:group_id]).contacts 
    else
      @contacts = current_user.contacts
    end
    
    @contacts = @contacts.collect{|el| notification.contacts.include?(el) ? nil : el}.compact    
    render :update do |page|
      page.replace_html :contacts_div, :partial => "contacts_for_notification", :locals => {:contacts => @contacts}     
      page << "link_lists();init_filter();"
    end
  end
  
end