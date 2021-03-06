class Tag < ActiveRecord::Base
  attr_accessible :name
  has_many :taggings, dependent: :destroy
  has_many :articles, through: :taggings

  before_save :titleize

  def titleize
    self.name = self.name.titleize
  end
end
