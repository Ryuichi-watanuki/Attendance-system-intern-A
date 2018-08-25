class Attendance < ApplicationRecord
  belongs_to :user # usersテーブルとの関連付け
  # validates :user_id, presence: true　#user_idは存在しているか
  
  
  
end
