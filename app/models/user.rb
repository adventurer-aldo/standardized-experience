class User < ApplicationRecord
  has_one :stat, class_name: 'Stat', foreign_key: 'user_id'
end