class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable

  # Relationship that a user initiated (in the user_id column)
  has_many :relationships, class_name: 'Relationship',
                           foreign_key: 'requestor_id',
                           dependent: :destroy
  # Relationship where the user is in the requestee_id column
  has_many :inverse_relationships, class_name: 'Relationship',
                                   foreign_key: 'requestee_id',
                                   dependent: :destroy

  before_validation :set_full_name

  NAME_REGEX = /\A[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]+\z/u
  validates :first_name, presence: true, length: { maximum: 30 },
                         format: { with: NAME_REGEX }
  validates :last_name,  presence: true, length: { maximum: 20 },
                         format: { with: NAME_REGEX }
  validates :full_name,  presence: true
  validates :email,      length: { maximum: 255 }

  # Friending methods

  def send_friend_request_to(user)
    relationships.create(requestee_id: user.id)
  end

  def sent_friend_requests
    relationships.where(status: 'pending')
  end

  def friend_requests
    inverse_relationships.where(status: 'pending')
  end

  def destroy_relationship_with(user)
    relationship_id = relationships.where(requestee_id: user.id)
          .or(inverse_relationships.where(requestor_id: user.id)).ids
    Relationship.delete(relationship_id.first)
  end

  def requestees
    requestees_ids = sent_friend_requests.pluck(:requestee_id)
    User.where(id: requestees_ids)
  end

  def requestors
    requestors_ids = friend_requests.pluck(:requestor_id)
    User.where(id: requestors_ids)
  end

  def accept_friend_request(user)
    friend_requests.find_by(requestor_id: user.id).update_attribute(:status, 'friends')
  end

  def friends
    friend_ids = relationships.where(status: 'friends').pluck(:requestee_id) + 
         inverse_relationships.where(status: 'friends').pluck(:requestor_id)
    User.where(id: friend_ids)
  end

  def friends_with?(user)
    friends.include?(user)
  end

  def determine_relationship_with(user)
    if requestees.include?(user) 
      'requestee'
    elsif requestors.include?(user) 
      'requestor'
    elsif friends_with?(user) 
      'friends'
    else 
      'stranger'
    end
  end

  def find_relationship_with(user)
    relationship_id = relationships.where(requestee_id: user.id)
      .or(inverse_relationships.where(requestor_id: user.id)).ids
    Relationship.find(relationship_id.first)
  end

  private

    def set_full_name
      self.full_name = first_name + ' ' + last_name
    end
end
