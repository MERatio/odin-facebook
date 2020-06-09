class Relationship < ApplicationRecord
  belongs_to :requestor, class_name: 'User'
  belongs_to :requestee, class_name: 'User'

  validates :requestor_id, presence: true
  validates :requestee_id, presence: true
  validate  :unique_relationship
  validate  :cannot_add_self

  def unique_relationship
    if Relationship.where(requestor_id: requestor_id, 
                          requestee_id: requestee_id)
        .or(Relationship.where(requestor_id: requestee_id, 
                               requestee_id: requestor_id)).exists?
      errors.add(:requestor_id, 'already requested')
    end
  end

  def cannot_add_self
    if (requestor_id == requestee_id)
      errors.add(:requestee_id, 'cannot be the same user')
    end
  end
end
