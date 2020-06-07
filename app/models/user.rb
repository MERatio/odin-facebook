class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable

  before_validation :set_full_name

  NAME_REGEX = /\A[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]+\z/u
  validates :first_name, presence: true, length: { maximum: 30 },
                         format: { with: NAME_REGEX }
  validates :last_name,  presence: true, length: { maximum: 20 },
                         format: { with: NAME_REGEX }
  validates :full_name,  presence: true
  validates :email,      length: { maximum: 255 }

  private

    def set_full_name
      self.full_name = first_name + ' ' + last_name
    end
end
