# Edit the options depending on your SAML needs
RedmineSAML = HashWithIndifferentAccess.new(
    host:             "http://redmine.yourhost.com/", # The redmine application hostname
    app_id:           123456,   # Application id
    cert_fingerprint: "xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx", # SSL fingerprint
)

Rails.configuration.saml_options = RedmineSAML
