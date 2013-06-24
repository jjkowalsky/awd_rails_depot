class Product < ActiveRecord::Base
  attr_accessible :description, :image_url, :price, :title

  default_scope :order => 'title'

  validates :title, :description, :image_url, :presence => true
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}
  validates :title, :uniqueness => true
  # validates :title, :uniqueness => { :message => "has already been taken" }
  validates :image_url, :format => {
  	:with	 => %r{\.(gif|jpg|png)$}i,
  	:message => 'must be a URL for GIF, JPG, or PNG image'
  }
  validates :title, :length => { :minimum => 10, :message => "must be >= 10 characters!"}
  # validates :title, length: { minimum: 10 } #used w/newer ver of rails?
  
end
