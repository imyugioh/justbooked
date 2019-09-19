ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    # Here is an example of a simple dashboard with columns and panels.

    columns do
      column do
        panel "Recent Chefs" do
          ul do
            Chef.last(5).map do |chef|
              li link_to(chef.name, admin_chef_path(chef))
            end
          end
        end
      end

      column do
        panel "Recent Menus" do
          ul do
            Menu.last(5).map do |menu|
              li link_to(menu.name, admin_menu_path(menu))
            end
          end
        end
      end

      column do
        panel "Log in as user:" do
          # para "Welcome to ActiveAdmin."
          switch_user_select
        end
      end
    end
  end # content
end
