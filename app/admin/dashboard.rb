ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    div :class => "blank_slate_container", :id => "dashboard_default_message" do
      span :class => "blank_slate" do
        span "Welcome to Active Admin. This is the default dashboard page."
        small "To add dashboard sections, checkout 'app/admin/dashboards.rb'"
      end
    end

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
