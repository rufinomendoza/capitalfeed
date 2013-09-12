module ApplicationHelper
  def tag_cloud(tags)
    tags.each do |tag|
      yield(tag)
    end
  end
end
