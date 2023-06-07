class Evaluable < ApplicationRecord
  belongs_to :stat, class_name: 'Stat', foreign_key: 'stat_id'
  belongs_to :subject
end
