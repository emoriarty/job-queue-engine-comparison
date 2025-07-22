class Film < ApplicationRecord
  validates :title, presence: true, uniqueness: true
end
