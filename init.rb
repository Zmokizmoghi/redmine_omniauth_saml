require 'redmine'
require 'redmine_omniauth_saml'
require 'redmine_omniauth_saml/hooks'
require 'redmine_omniauth_saml/user_patch'


# Patches to existing classes/modules
ActionDispatch::Callbacks.to_prepare do
  require_dependency 'redmine_omniauth_saml/account_helper_patch'
  require_dependency 'redmine_omniauth_saml/account_controller_patch'
end

# Plugin generic informations
Redmine::Plugin.register :redmine_omniauth_saml do
  name 'Redmine Omniauth SAML plugin'
  description 'This plugin adds Onelogin SAML support to Redmine. Based on Redmine Omniauth Saml plugin by Christian Rodriguez'
  author 'Alex Gornov'
  author_url 'mailto:zmokizmoghi@gmail.com'
  url 'https://github.com/Zmokizmoghi/redmine_omniauth_saml'
  version '0.0.1'
  requires_redmine :version_or_higher => '2.0.0'
  settings :default => { 'enabled' => 'true', 'label_login_with_saml' => '', 'replace_redmine_login' => false  },
           :partial => 'settings/omniauth_saml_settings'
end
