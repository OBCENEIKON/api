# == Schema Information
#
# Table name: authentications
#
#  id                 :integer          not null, primary key
#  created_at         :datetime
#  updated_at         :datetime
#  staff_id           :integer
#  provider           :string           default(""), not null
#  uid                :string           default(""), not null
#  sign_in_count      :integer          default(0), not null
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :inet
#  last_sign_in_ip    :inet
#
# Indexes
#
#  index_authentications_on_staff_id                       (staff_id)
#  index_authentications_on_uid_and_provider_and_staff_id  (uid,provider,staff_id) UNIQUE
#

class Authentications < ActiveRecord::Base
  belongs_to :staff

  validates :provider, :uid, presence: true
end
