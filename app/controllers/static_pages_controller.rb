class StaticPagesController < ApplicationController

include StaticPagesHelper
require 'date'

   def home
    if logged_in?
      @month = Date.today.month
      @days = (Date.new(2018, 6, 1) .. Date.new(2018, 6, 30))
      
    end
      
    
   end

  def help
  end

  def about
  end

  def contact
  end
  
  def create
    work_name
     if @name == "出社" 
         @work = Work.create(user_id:current_user.id, 
                         start_time: Time.now,
                         day: Time.now)
     elsif @name == "退社"
         Work.find(1).update(end_time: Time.now)
     elsif @name == "----"
     end
     redirect_to root_path
  end
  
 
  
   
  
 
  
  
  
  
end