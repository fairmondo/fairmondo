class ImagesController < ApplicationController
  def create
    @image = Image.create(params[:image])
    if @image.save
      flash[:notice] = I18n.t('auction.notices.image')
      redirect_to(@image.auction)
    else
      redirect_to(@image.auction)
    end
  end
  def destroy

    @image = Image.find(params[:id])
    @auction=@image.auction
    @image.destroy
 
    redirect_to(@auction)
  end
end
