ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    h3 "Production Log"
    span simple_format get_production_log
        
   

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #  column do
    #    panel "Unconfirmed Fair Founding Points" do
    #       ul do
    #         Ffp.where("activated = ?", false).map do |ffp|
    #            li link_to(ffp.donator.email, admin_ffp_path(ffp))
    #         end
    #      end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
