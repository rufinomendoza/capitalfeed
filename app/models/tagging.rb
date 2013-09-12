class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :article
  # attr_accessible :title, :body
  attr_accessible :tag_id, :article_id
end
