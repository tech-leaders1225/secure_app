class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :work_log]
  before_action :admin_user,     only: [:destroy, :edit_basic_info, :update_basic_info, :index, :base_delete, :base_update, :base_add, :base_edit]
  
  require 'csv'
  include StaticPagesHelper

  def index
    @users = User.activated.paginate(page: params[:page]).search(params[:search]).order(:id)
  end

  def show
    @user = User.find(params[:id])
    
    "fix/userブランチの修正"
  end

  def new
    @user = User.new
  end

  def create
    # admin　ユーザー一覧からのCSVインポート
    if params[:commit] == "CSVをインポート"
      
      if params[:users_file].content_type == "text/csv"
          registered_count = import_users
          unless @errors.count == 0
            flash[:danger] = "#{@errors.count}件登録に失敗しました"
          end
          unless registered_count == 0
            flash[:success] = "#{registered_count}件登録しました"
          end
          redirect_to users_url(error_users: @errors)
      else
        flash[:danger] = "CSVファイルのみ有効です"
        redirect_to users_url
      end
      
    else
      
      @user = User.new(user_params)
      if @user.save
        log_in @user
        redirect_to user_work_path(@user,Date.today)
      else
        render 'new'
      end
    end
  end

  def edit
    @user = User.find(params[:id])
    @month = Date.today.month
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "アカウントを更新しました。"
      redirect_to users_path
    else
      render 'edit'
    end
    
  end
  
  def update_by_admin
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "アカウントを更新しました。"
      redirect_to users_path
    else
      render 'edit'
    end
    
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "アカウントを削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
    
  end
  
  def update_basic_info
    if User.update_all(basic_work_time: params[:user][:basic_work_time].to_time - 9.hours)
      flash[:success] = "基本情報を更新しました。"
      redirect_to edit_basic_info_path
    else
      render 'edit'
    end
    
  end
  

  def csv_output
    date=params[:date].to_datetime
    @works = current_user.works.where(day: date.beginning_of_month..date.end_of_month ).order(:day)
    send_data render_to_string, filename: "#{current_user.name}_#{params[:date].to_time.strftime("%Y年 %m月")}.csv", type: :csv
  end
  
  
  def working_users
    @users = User.get_working_user.order(:id).paginate(page: params[:page]).search(params[:search])
  end
  
  def work_log
      work_ids = current_user.works.ids
      if params[:value_year]
        date = Date.new(params[:value_year].to_i, params[:value_month].to_i)
        @logs = WorkLog.page(params[:page]).per(30)
                        .where(work_id: work_ids)
                        .where(day: date.beginning_of_month..date.end_of_month)
      else
        @logs = WorkLog.page(params[:page]).per(30).where(work_id: work_ids)
                                                   .where(day: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)
      end
        # view_contextでpaginateメソッドを使いパーシャルの中身と同じものを生成
        paginator = view_context.paginate(
          @logs,
          remote: true
        )
        
        # render_to_stringでパーシャルの中身を生成
        logs = render_to_string(
          partial: 'table_work_log',
          locals: { logs: @logs }
        )
      if request.xhr?  
          render json: {
            paginator: paginator,
            logs: logs,
            success: true # クライアント(js)側へsuccessを伝えるために付加
          }
      end
  end
  
  def base_edit
    @bases = Base.all
    @base = Base.new
  end
  
  def base_add
    @base = Base.new(base_params)
      if @base.save
        flash[:success] = "拠点情報を追加しました。"
        redirect_to base_edit_users_path
      else
        render 'base_edit'
      end
  end
  
  def base_update
    @base = Base.find(params[:id])
      if @base.update(base_params)
        flash[:success] = "拠点情報を更新しました。"
        redirect_to base_edit_users_path
      else
        render 'base_edit'
      end
  end
  
  def base_delete
    @base = Base.find(params[:id])
      if @base.destroy
        flash[:danger] = "拠点情報を削除しました。"
        redirect_to base_edit_users_path
      else
        render 'base_edit'
      end
  end
  
  def base_edit_modal
    @base = Base.find(params[:id])
  end
  
  

  private
    # CSVインポート
    def import_users
      # 登録処理前のレコード数
      current_user_count = ::User.count
      users = []
      @errors = []
      # windowsで作られたファイルに対応するので、encoding: "SJIS"を付けている
      CSV.foreach(params[:users_file].path, headers: true) do |row|
        user = User.new({ id: row["id"], name: row["name"], email: row["email"], team: row["team"], worker_number: row["worker_number"], worker_id: row["worker_id"], basic_work_time: row["basic_work_time"], 
                              d_start_worktime: row["d_start_worktime"], d_end_worktime: row["d_end_worktime"], sv: row["sv"], admin: row["admin"], password: row["password"], activated: "true"})
        if user.valid?
            users << ::User.new({id: row["id"], name: row["name"], email: row["email"], team: row["team"], worker_number: row["worker_number"], worker_id: row["worker_id"], basic_work_time: row["basic_work_time"], 
                              d_start_worktime: row["d_start_worktime"], d_end_worktime: row["d_end_worktime"], sv: row["sv"], admin: row["admin"], password: row["password"], activated: "true"})
        else
          @errors << user.errors.inspect
          Rails.logger.warn(user.errors.inspect)
        end
      end
      # importメソッドでバルクインサートできる
      ::User.import(users)
      # 何レコード登録できたかを返す
      ::User.count - current_user_count
    end

    def user_params
      if User.exists?
        params.require(:user).permit(:name, :email, :team, :password,
                                    :activated, :activated_at,
                                      :password_confirmation,
                                      :worker_number,
                                      :worker_id,
                                      :basic_work_time,
                                      :d_start_worktime,
                                      :d_end_worktime, :admin)
       else
        params.require(:user).permit(:name, :email, :team, :password,
                                    :activated, :activated_at,
                                    :password_confirmation, :specified_work_time,
                                    :basic_work_time, :admin)
      end
    end
    
    def users_basic_params
      params.require(:user).permit(:specified_work_time, :basic_work_time)
    end
    
    def base_params
      params.require(:base).permit(:number, :name, :kind)
    end

    # beforeフィルター

    # 正しいユーザーかどうかを確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうかを確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
