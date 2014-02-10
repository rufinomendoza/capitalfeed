module ApplicationHelper
  def tag_cloud(tags)
    tags.each do |tag|
      unless tag.name.blank?
        yield(tag)
      end
    end
  end
end
