class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, and :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable
  devise :omniauthable, omniauth_providers: %i[facebook]

  # Relationship that a user initiated (in the user_id column)
  has_many :relationships, class_name: 'Relationship',
                           foreign_key: 'requestor_id',
                           dependent: :destroy
  # Relationship where the user is in the requestee_id column
  has_many :inverse_relationships, class_name: 'Relationship',
                                   foreign_key: 'requestee_id',
                                   dependent: :destroy
  has_many :posts, foreign_key: 'author_id', dependent: :destroy
  has_many :reactions, dependent: :destroy
  has_many :comments,  dependent: :destroy

  before_validation :set_full_name

  NAME_REGEX = /\A[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]+\z/u
  validates :first_name, presence: true, length: { maximum: 30 },
                         format: { with: NAME_REGEX }
  validates :last_name,  presence: true, length: { maximum: 20 },
                         format: { with: NAME_REGEX }
  validates :full_name,  presence: true
  validates :email,      length: { maximum: 255 }

  scope :familiars_for, ->(user) do
    not_strangers_ids = user.relationships.map(&:requestee_id)
    not_strangers_ids << user.inverse_relationships.map(&:requestor_id) << user.id
    where(id: not_strangers_ids.flatten)
  end

  scope :strangers_for, ->(user) { where.not(id: familiars_for(user).ids) }

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

  # Like and Unlike methods

  def likes(post)
    reactions.create(post_id: post.id)
  end

  def likes?(post)
    reactions.exists?(post_id: post.id)
  end

  def unlikes(post)
    reactions.find_by(post_id: post.id).destroy
  end

  # News feed

  def news_feed
    friends_and_self_ids = friends.ids.push(id)
    Post.where(author_id: friends_and_self_ids)
  end


  private

    def set_full_name
      self.full_name = first_name + ' ' + last_name
    end

    def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 18]
        user.first_name = auth.info.first_name
        user.last_name = auth.info.last_name
        # user.image = auth.info.image # assuming the user model has an image
        # If you are using confirmable and the provider(s) you use validate emails, 
        # uncomment the line below to skip the confirmation emails.
        # user.skip_confirmation!
      end
    end
end
