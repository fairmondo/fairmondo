class InvitationsController < ApplicationController

  # Routes & controller tests commented out for the moment because it is not used in this version

  before_filter :authenticate_user!, :except => [:confirm]
  # GET /invitations
  # GET /invitations.json
  def index

    #@invitations = Invitation.where(:user => current_user)
    @invitations = Invitation.find(:all,:conditions => [ "user_id = ?", current_user.id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @invitations }
    end
  end

  def confirm

    if(params[:id])
      @invitation = Invitation.find(params[:id])
    else
      flash[:error] = t('invitation.notices.activation_error_wrong')
      redirect_to root_path
    end
    if(params[:id])
      if @invitation.activation_key != params[:key]
        flash[:error] = t('invitation.notices.activation_error_wrong')
        redirect_to root_path
      elsif @invitation.activated == true
        flash[:error] = t('invitation.notices.activation_error_exist')
        redirect_to root_path
      else

        session[:invited_email] = @invitation.email
        session[:invitor_id] = @invitation.sender.id
        session[:invitor_name] = @invitation.sender.name
        #session[:invitor_surname] = @invitation.sender.surname

        #session[:key] = params[:key]
        redirect_to "/user/sign_up"
      end
    #@invitation.activated = true
    #@pw = SecureRandom.hex(8)

    #@user = User.new(:email => @invitation.email, :password => @pw, :password_confirmation => @pw, :name => @invitation.name, :surname => @invitation.surname, :invitor => @invitation.sender)

    #if !@user.save || !@invitation.save
    #   flash[:error] = t('invitation.notices.activation_error')
    #else
    # Notification.send_pw(@invitation.name, @invitation.email, @pw).deliver
    #end
    end

  end

  # GET /invitations/1
  # GET /invitations/1.json
  def show
    @invitation = Invitation.find(params[:id],:conditions => [ "user_id = ?", current_user.id])

    if @invitation == nil
      flash[:error] = t('invitation.notices.not_available')
    #redirect_to :controller => 'logins', :action => 'login'
    else
      respond_to do |format|
        format.html # show.html.erb
        format.json { render :json => @invitation }
      end
    end

  end

  # GET /invitations/new
  # GET /invitations/new.json
  def new
    @invitation = Invitation.new

    if(params[:user_id])
      @user= User.find(params[:user_id])
      if @user != nil
        @image = @user.image 
      end
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @invitation }
    end
  end

  # GET /invitations/1/edit
  #def edit
  #  @invitation = Invitation.find(params[:id])
  #end

  # POST /invitations
  # POST /invitations.json
  def create
    @invitation = Invitation.new(params[:invitation])

    #if the invited person already is registered to fairnopoly
    registerd_user = User.find(:first,:conditions => [ "email = ?", @invitation.email])
    if registerd_user != nil
      #flash[:error] = t('invitation.notices.user_exist')
      #TODO: check how we want to do it
      registerd_user.trustcommunity = true
      registerd_user.invitor = current_user
      registerd_user.save
      redirect_to community_path(:id => current_user.id)

    else
      if user_signed_in?
        @invitation.sender = current_user
      end

      # generate the activation key and save it in the invitation
      @invitation.activation_key = SecureRandom.hex(24)
      @invitation.activated = false

      # Check if we can save the invitation
      if @invitation.save
        Notification.invitation(@invitation.id, current_user, @invitation.name, @invitation.email, @invitation.activation_key).deliver
        respond_created
      else
        respond_to do |format|
          format.html { render :action => "new" }
          format.json { render :json => @invitation.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /invitations/1
  # PUT /invitations/1.json
  #def update
  #  @invitation = Invitation.find(params[:id])

  #  respond_to do |format|
  #    if @invitation.update_attributes(params[:invitation])
  #      format.html { redirect_to @invitation, :notice => 'Invitation was successfully updated.' }
  #      format.json { head :no_content }
  #    else
  #      format.html { render :action => "edit" }
  #      format.json { render :json => @invitation.errors, :status => :unprocessable_entity }
  #    end
  #  end
  #end

  # DELETE /invitations/1
  # DELETE /invitations/1.json
  def destroy
    @invitation = Invitation.find(params[:id])
    @invitation.destroy

    respond_to do |format|
      format.html { redirect_to invitations_url }
      format.json { head :no_content }
    end
  end

  def respond_created
    #Throwing User Events
    respond_to do |format|
      format.html { redirect_to @invitation, :notice => I18n.t('invitation.notices.create') }
      format.json { render :json => @invitation, :status => :created, :location => @invitation }
    end
  end
end
