class User < ApplicationRecord

	validates :fullname, :username, :email, :address, :password, :password_confirmation, :phone, :presence => true
	validates :email, :username, :uniqueness => true
	validates :email, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create}
	validates :password, :confirmation => true
	validates :phone, :length => { :minimum => 5, :maximum => 12 }


	gem 'bcrypt', '~> 3.1.7'
	
end
