class Tagging < ActiveRecord::Base
  belongs_to :tag, dependent: :destroy
  belongs_to :article, dependent: :destroy
  # attr_accessible :title, :body
  attr_accessible :tag_id, :article_id
end
