class ImagesController < ApplicationController
  before_filter :authenticate_user!
  def create
    @image = Image.create(params[:image])
    if @image.auction.seller = current_user
      if @image.save
        flash[:notice] = I18n.t('auction.notices.image')
        redirect_to(@image.auction)
      else
        flash[:error] = @image.errors.full_messages[0]
        redirect_to(@image.auction)
      end
     end
  end
  def destroy

    @image = Image.find(params[:id])
    if @image.auction.seller = current_user
      @auction=@image.auction
      @image.destroy
   
      redirect_to(@auction)
    end
  end
end
