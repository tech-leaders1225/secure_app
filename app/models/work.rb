class Work < ApplicationRecord
    belongs_to :user
    #validates :note, length: { maximum: 20 }
    has_many :work_logs
    # スコープ
      scope :select_user, -> (select_user_id){ where(user_id: select_user_id) }
      scope :month_all, -> (month_all){ where(day: month_all) }
      
    
    
    
  
end
