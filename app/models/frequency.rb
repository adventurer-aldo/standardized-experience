class Frequency < ApplicationRecord
  belongs_to :stat, class_name: 'Stat', foreign_key: 'stat_id'
  belongs_to :question, class_name: 'Question', foreign_key: 'question_id'
end
