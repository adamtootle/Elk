class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :apps
  has_and_belongs_to_many :dist_lists
  has_many :roles, :class_name => "UserRole", :dependent => :destroy
  has_many :devices, :dependent => :destroy

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  def is_admin_for_app app
    role = self.roles.select{|role| role.app_id == app.id}.first
    !role.nil? && role.role == UserRole::ROLES[:admin]
  end

  def is_tester_for_app app
    role = UserRole.where(:app_id => app.id, :user_id => self.id).first
    !role.nil? && role.role == UserRole::ROLES[:tester]
  end
end
