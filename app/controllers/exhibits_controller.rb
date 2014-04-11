# # Helper-Controller for Library administration for admins
# class ExhibitsController < InheritedResources::Base
#   defaults :resource_class => Library, :collection_name => 'libraries', :instance_name => 'library'
#   actions :create,:update, :destroy
#   custom_actions :collection => :create_multiple
#   #skip_after_filter :verify_authorized_with_exceptions, only: [:create_multiple]

#   # add a single article to a library with a specific exhibition_name
#   def create
#     authorize build_resource
#     create! do |format|
#       format.html {redirect_to resource.article}
#     end
#   end

#   # add the articles from the params to the library that is currently set to have *exhibition_name*
#   def create_multiple
#     authorize build_resource
#     if params[:exhibit][:exhibition_name] && params[:exhibit][:articles]

#       exhibition_name = params[:exhibit][:exhibition_name]
#       articles = params[:exhibit][:articles]

#       articles.each do |id|
#         if id.present?
#           a = Article.find id
#           e = Exhibit.create({
#             article_id: a.id,
#             exhibition_name: exhibition_name
#           })
#           e.save!
#         end
#       end
#     end
#     redirect_to root_path
#   end

#   private
#     def permitted_params
#       params.permit(:stuff)
#     end

#   # def update
#   #   authorize resource
#   #   update! do |format|
#   #     format.html {redirect_to resource.article}
#   #   end
#   # end

#   # def destroy
#   #   authorize resource
#   #    destroy! do |format|
#   #      format.html {  redirect_to root_path }
#   #    end
#   # end

# end
