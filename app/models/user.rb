class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friendships, foreign_key: :inviter_id
  has_many :invitees, through: :friendships

  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: :invitee_id
  has_many :inviters, through: :inverse_friendships

  has_many :comfirmed_friendships, -> { where status: true }, class_name: 'Friendship', foreign_key: :inviter_id
  has_many :friends, through: :comfirmed_friendships, source: :invitee, class_name: 'User'

  def friends_and_own_posts
    Post.where(user_id: [*self.friends, self])
  end

  def friend_requests
    Friendship.where(invitee_id: self, status: false)
  end

  def pending_requests
    Friendship.where(inviter_id: self, status: false)
  end
end
