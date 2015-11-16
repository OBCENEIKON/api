# == Schema Information
#
# Table name: authentications
#
#  id                 :integer          not null, primary key
#  created_at         :datetime
#  updated_at         :datetime
#  staff_id           :integer
#  uid                :string           default(""), not null
#  provider           :string           default(""), not null
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

class Authentication < ActiveRecord::Base
  belongs_to :staff

  validates :provider, :uid, presence: true

  def self.find_with_omniauth(auth)
    find_by(uid: auth['uid'], provider: auth['provider'])
  end

  def self.create_with_omniauth(auth)
    create(uid: auth['uid'], provider: auth['provider'])
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |staff|
      staff.email = auth.info.email
      staff.password = Devise.friendly_token[0,20]
      staff.name = auth.info.name
    end
  end
end
