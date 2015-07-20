class UserAuthType < ActiveRecord::Base
  unloadable
  belongs_to :user
  validates_uniqueness_of :user_id

end
