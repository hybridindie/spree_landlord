Deface::Override.new(:virtual_path => "spree/layouts/admin",
                     :name => "add_tenant_header_link",
                     :insert_bottom => "ul[data-link=admin_login_navigation_bar]",
                     :text => "<%= configurations_sidebar_menu_item t(:jirafe), admin_analytics_path %>")
