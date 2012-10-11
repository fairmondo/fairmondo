class FfpsController < ApplicationController

  before_filter :authenticate_user!

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
end
