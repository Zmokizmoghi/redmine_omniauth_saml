require_dependency 'account_controller'
require 'onelogin/ruby-saml'


module Redmine::OmniAuthSAML
  module AccountControllerPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        alias_method_chain :login, :saml
      end
    end

    module InstanceMethods

      def login_with_saml
        if settings["enabled"] && settings["replace_redmine_login"]
          redirect_to :controller => "account", :action => "login_with_saml_redirect", :provider => "saml"
        else
          login_without_saml
        end
      end

      def login_with_saml_redirect
        request = OneLogin::RubySaml::Authrequest.new
        redirect_to(request.create(saml_settings))
      end

      def login_with_saml_callback
        response          = OneLogin::RubySaml::Response.new(params[:SAMLResponse], skip_conditions: true)
        response.settings = saml_settings
        if response.is_valid?
          user = User.find_by_login(response.name_id)

          # taken from original AccountController
          # maybe it should be splitted in core
          if user.blank?
            logger.warn "Failed login for '#{response.name_id}' from #{request.remote_ip} at #{Time.now.utc}"
            error = l(:notice_account_invalid_creditentials).sub(/\.$/, '')
            if settings["enabled"]
              link = self.class.helpers.link_to(l(:text_logout_from_saml), saml_logout_url(home_url), :target => "_blank")
              error << ". #{l(:text_full_logout_proposal, :value => link)}"
            end
            if settings["replace_redmine_login"]
              render_error({:message => error.html_safe, :status => 403})
              return false
            else
              flash[:error] = error
              redirect_to signin_url
            end
          else
            user.update_attribute(:last_login_on, Time.now)
            successful_authentication(user)
            #cannot be set earlier, because sucessful_authentication() triggers reset_session()
            session[:logged_in_with_saml] = true
          end
        end
      end

      def login_with_saml_failure
        flash[:error] = "SAML Login failed. Please, contact administrator."
        redirect_to signin_url
      end

      private
      def settings
        Redmine::OmniAuthSAML.settings_hash
      end

      def saml_settings
        Redmine::OmniAuthSAML.saml_settings
      end
    end
  end
end

unless AccountController.included_modules.include? Redmine::OmniAuthSAML::AccountControllerPatch
  AccountController.send(:include, Redmine::OmniAuthSAML::AccountControllerPatch)
  AccountController.skip_before_filter :verify_authenticity_token, :only => [:login_with_saml_callback]
end
