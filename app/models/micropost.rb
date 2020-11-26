class Micropost < ApplicationRecord
  belongs_to :user
  scope :recent_posts, ->{order created_at: :desc}
  scope :feed_in, ->following_ids{where user_id: following_ids if following_ids.present? }
  has_one_attached :image
  validates :content, presence: true,
                      length: {maximum: Settings.micro_post.max_content}
  validates :image, content_type: {in: %w(image/jpeg image/gif image/png),
                                   message: I18n.t("post.valid_file_format")},
                    size: {less_than: Settings.image.size.megabytes,
                           message: I18n.t("post.less_than_X_mb",
                                           X: Settings.image.size)}
  def display_image
    image.variant resize_to_limit: [Settings.image.resize,
                                    Settings.image.resize]
  end
end
