module WorksHelper
  
    # 出社と退社ボタンの切替
    def work_name
        if select_user.works.find_by(day: Time.now + 9.hour).nil?
          @name = "出社"
        elsif select_user.works.find_by(day: Time.now + 9.hour).end_time
          @name = "----"
        elsif select_user.works.find_by(day: Time.now + 9.hour).start_time
          @name = "退社"
        else
          @name = "出社"
        end
    end
    
    
    # 出社時間の表示
    def start_time(a)
        Work.find_by(day: a, user_id: select_user.id) && Work.find_by(day: a, user_id: select_user.id).start_time
    end
    
    # 退社時間の表示
    def end_time(a)
      Work.find_by(day: a, user_id: select_user.id) && Work.find_by(day: a, user_id: select_user.id).end_time
    end
    
    # 終了予定時間
    def endtime_plan(a)
      Work.find_by(day: a, user_id: select_user.id) && Work.find_by(day: a, user_id: select_user.id).endtime_plan
    end
    
    # 翌日判定
    def tomorrow?(work, day)
      if work.end_time && work.end_time == day.tomorrow
        return "(翌日)"
      end
    end
    
    # 勤怠変更　翌日判定
    def change_tomorrow?(a)
      if Work.find_by(user_id: select_user.id, day: a) && Work.find_by(user_id: select_user.id, day: a).endtime_change && Work.find_by(user_id: select_user.id, day: a).endtime_change.day == a.tomorrow.day
        return "(翌日)"
      end
    end
    
    
    # 業務処理内容
    def work_content(a)
      Work.find_by(day: a, user_id: select_user.id) && Work.find_by(day: a, user_id: select_user.id).work_content
    end
    
    # 申請状況（指示者確認）
    def over_check(work)
      if work
        work && work.over_check
        if work.over_check=="上長A" || work.over_check=="上長B" || work.over_check=="上長C"
          "残業を#{work.over_check}に申請中"
        elsif work.over_check=="否認"
          "残業否認"
        elsif work.over_check=="承認"
          "残業承認済"
        end
      end
    end
    
    # 勤怠変更　申請状況（指示者確認）
    def work_check(work)
      if work
        work && work.work_check
        if work.work_check=="上長A" || work.work_check=="上長B" || work.work_check=="上長C"
          "勤怠変更を#{work.work_check}に申請中"
        elsif work.work_check=="否認"
          "勤怠変更否認"
        elsif work.work_check=="承認"
          "勤怠変更承認済"
        end
      end
    end
    
    # 在社時間の合計
    def total_time(y,m)
      days = (Date.new(y,m).all_month)
      works = Work.where(user_id: select_user.id, day: days)
      works.map do |work|
        if work.start_time && work.end_time
          (work.end_time - work.start_time)/60/60
        else
          0
        end
      end
    end
    
    # 総合勤務時間
    def total_works_time(y,m)
      select_user.works.where(day: Time.new(y,m).all_month).select("end_time").count * basic_time
    end
    
   
    
    
    # 現在のユーザーIDパラメーターを持っているユーザー（カレントユーザーとは違う）
    def select_user
      User.find(params[:user_id])
    end
    
    # 指定勤務時間
    def specified_time
      if User.find(1).specified_work_time
        BigDecimal(((User.find(1).specified_work_time-User.find(1).specified_work_time.beginning_of_day)/60/60).to_s).round(3).to_f
      end
    end
    
    # 基本時間
    def basic_time
      if User.find(1).basic_work_time
        BigDecimal(((User.find(1).basic_work_time-User.find(1).basic_work_time.beginning_of_day)/60/60).to_s).round(3).to_f
      end
    end
    
    # １ヶ月分の申請の承認表示
    def month_check_window
      if params[:piyo]
        day = params[:piyo].to_datetime.beginning_of_month
      else
        day = params[:id].to_datetime.beginning_of_month
      end
      if current_user.works.find_by(day: day).nil? || current_user.works.find_by(day: day).month_check.nil?
        "未"
      else
         current_user.works.find_by(day: day).month_check
      end
    end
    
    # 時間外時間の計算
        # 時間の日付を揃えて比較する。
    def overwork_time(over_work)
      a=over_work.day
      a_1=over_work.endtime_plan
      b=select_user.d_end_worktime
      c=Time.new(a.year,a.month,a.day,b.hour,b.min,b.sec)
      d=Time.new(a_1.year,a_1.month,a_1.day,a_1.hour,a_1.min,a_1.sec)
      (d-c)/60/60
    end
    
    def time_change(day, time)
      day=day.to_datetime
      time=time.to_datetime
      Time.new(day.year,day.month,day.day,time.hour,time.min,time.sec)
    end
    
    
end
