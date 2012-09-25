class UsereventsController < ApplicationController
  # GET /userevents
  # GET /userevents.json
  def index
    @userevents = Userevent.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @userevents }
    end
  end

  # GET /userevents/1
  # GET /userevents/1.json
  def show
    @userevent = Userevent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @userevent }
    end
  end

  # GET /userevents/new
  # GET /userevents/new.json
  def new
    @userevent = Userevent.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @userevent }
    end
  end

  # GET /userevents/1/edit
  def edit
    @userevent = Userevent.find(params[:id])
  end

  # POST /userevents
  # POST /userevents.json
  def create
    @userevent = Userevent.new(params[:userevent])

    respond_to do |format|
      if @userevent.save
        format.html { redirect_to @userevent, :notice => 'Userevent was successfully created.' }
        format.json { render :json => @userevent, :status => :created, :location => @userevent }
      else
        format.html { render :action => "new" }
        format.json { render :json => @userevent.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /userevents/1
  # PUT /userevents/1.json
  def update
    @userevent = Userevent.find(params[:id])

    respond_to do |format|
      if @userevent.update_attributes(params[:userevent])
        format.html { redirect_to @userevent, :notice => 'Userevent was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @userevent.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /userevents/1
  # DELETE /userevents/1.json
  def destroy
    @userevent = Userevent.find(params[:id])
    @userevent.destroy

    respond_to do |format|
      format.html { redirect_to userevents_url }
      format.json { head :no_content }
    end
  end
end
