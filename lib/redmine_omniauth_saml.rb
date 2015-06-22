module Redmine::OmniAuthSAML
  class << self

    def saml_settings
      options = Rails.configuration.saml_options
      settings = OneLogin::RubySaml::Settings.new

      settings.assertion_consumer_service_url = "#{options[:host]}/auth/saml/consume"
      settings.issuer                         = "https://app.onelogin.com/saml/metadata/#{options[:app_id]}"
      settings.idp_sso_target_url             = "https://app.onelogin.com/saml/metadata/#{options[:app_id]}"
      settings.idp_entity_id                  = "https://app.onelogin.com/saml/metadata/#{options[:app_id]}"
      settings.idp_sso_target_url             = "https://opsway.onelogin.com/trust/saml2/http-post/sso/#{options[:app_id]}"
      settings.idp_slo_target_url             = "https://opsway.onelogin.com/trust/saml2/http-redirect/slo/#{options[:app_id]}"
      settings.idp_cert_fingerprint           = options[:cert_fingerprint]
      settings.idp_cert_fingerprint_algorithm = "http://www.w3.org/2000/09/xmldsig#sha1"
      settings.name_identifier_format         = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"

      # Optional for most SAML IdPs
      settings.authn_context = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"

      # Optional bindings (defaults to Redirect for logout POST for acs)
      settings.assertion_consumer_service_binding = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST"
      settings.assertion_consumer_logout_service_binding = "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect"

      settings
    end

    def settings_hash
      Setting["plugin_redmine_omniauth_saml"]
    end

    def enabled?
      settings_hash["enabled"]
    end

    def onthefly_creation?
      enabled? && settings_hash["onthefly_creation"]
    end

    def label_login_with_saml
      settings_hash["label_login_with_saml"]
    end

  end

end
