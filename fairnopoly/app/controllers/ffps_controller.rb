class FfpsController < ApplicationController
  
  #TODO: make the destroy and edit actions only accessible for admins!!
   before_filter :authenticate_user!
  
  
  # GET /ffps
  # GET /ffps.json
  def index
    @ffps = Ffp.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @ffps }
    end
  end

  # GET /ffps/1
  # GET /ffps/1.json
  def show
    @ffp = Ffp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @ffp }
    end
  end

  # GET /ffps/new
  # GET /ffps/new.json
  def new    
    @ffp = Ffp.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @ffp }
    end
  end

  # GET /ffps/1/edit
  def edit
    @ffp = Ffp.find(params[:id])
  end

  # POST /ffps
  # POST /ffps.json
  def create

    @ffp = Ffp.new(params[:ffp])
 
    #check how much FFPS the user already has
    ffp_old = current_user.ffps.sum(:price)
    if ffp_old+@ffp.price > 500
        flash[:error] = t('ffp.to_much')
        redirect_to root_path
    else
      @ffp.activated = false
      @ffp.user_id = current_user.id
  
      respond_to do |format|
        if @ffp.save
          
          Notification.send_ffp_created(@ffp).deliver
          
          format.html { redirect_to @ffp, :notice => 'Ffp was successfully created.' }
          format.json { render :json => @ffp, :status => :created, :location => @ffp }
        else
          format.html { render :action => "new" }
          format.json { render :json => @ffp.errors, :status => :unprocessable_entity }
        end
      end    
    end
  end

  # PUT /ffps/1
  # PUT /ffps/1.json
  def update
    @ffp = Ffp.find(params[:id])

    respond_to do |format|
      if @ffp.update_attributes(params[:ffp])
        
        if @ffp.activated ==true      
          Notification.send_ffp_confirmed(@ffp).deliver
        end
        
        format.html { redirect_to ffps_path, :notice => 'Ffp was successfully confirmed.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @ffp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ffps/1
  # DELETE /ffps/1.json
  def destroy
    @ffp = Ffp.find(params[:id])
    @ffp.destroy

    respond_to do |format|
      format.html { redirect_to ffps_url }
      format.json { head :no_content }
    end
  end
end
