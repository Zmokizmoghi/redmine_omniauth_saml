module Redmine::OmniAuthSAML
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_account_login_top, :partial => 'redmine_omniauth_saml/view_account_login_top'
    render_on :view_users_form, :partial => 'users/view_users_form'
  end
end
