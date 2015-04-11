module ApplicationHelper
  def welcome_info(user)
    unless user.nil?
      content_tag :li do
	link_to t("shared.welcome", email: user.email), user
      end
    end
  end

  def header_html(user)
    if !user
      login_html = content_tag :li do
       	link_to t("shared.login"), login_path, class: "login-btn button round"
      end
      signup_html = content_tag :li do
	link_to t("shared.sign_up"), signup_path, class: "signup-btn button round"
      end
      login_html + signup_html
    else
      setting_html = content_tag :li, class: "setting" do
	link_to settings_path do
	  fa_icon("gear", class: "fa-2x")
	end
      end
      logout_html = content_tag :li do
	link_to t("shared.logout"), logout_path, class: "login-btn button round"
      end
      setting_html + logout_html
    end
  end
end
