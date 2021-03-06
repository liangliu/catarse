class Channel < ActiveRecord::Base
  attr_accessible :description, :name, :permalink
  schema_associations

  validates_presence_of :name, :description, :permalink
  validates_uniqueness_of :permalink

  has_and_belongs_to_many :projects, -> { order("online_date desc") }
  has_and_belongs_to_many :subscribers, class_name: 'User', join_table: :channels_subscribers
  has_and_belongs_to_many :trustees, class_name: 'User', join_table: :channels_trustees
  has_many :subscriber_reports

  delegate :all, to: :decorator

  def has_subscriber? user
    user && subscribers.where(id: user.id).first.present?
  end

  # Links to channels should be their permalink
  def to_param; self.permalink end

  # Using decorators
  def decorator
    @decorator ||= ChannelDecorator.new(self)
  end
end
