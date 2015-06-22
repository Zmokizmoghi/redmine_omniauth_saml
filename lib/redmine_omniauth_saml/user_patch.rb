require_dependency 'project'
require_dependency 'principal'
require_dependency 'user'


module RedmineOmniAuthSaml
  module Patches
    module UserPatch

      def self.included(base) # :nodoc:
        base.class_eval do
          unloadable
          has_one :auth, class_name: "UserAuthType", dependent: :destroy
          accepts_nested_attributes_for :auth, allow_destroy: true
          safe_attributes 'auth_attributes',
                          :if => lambda {|user, current_user| current_user.admin?}

          base.send(:include, InstanceMethods)
        end
      end

      module InstanceMethods

        def auth_parameters=(record)
          puts

        end
      end
    end
  end
end

unless User.included_modules.include?(RedmineOmniAuthSaml::Patches::UserPatch)
  User.send(:include, RedmineOmniAuthSaml::Patches::UserPatch)
end
