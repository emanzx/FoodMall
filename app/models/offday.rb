class Offday < ApplicationRecord
  validates :date_off, :uniqueness => true, :presence => true
end
