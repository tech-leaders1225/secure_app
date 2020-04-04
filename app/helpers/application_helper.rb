module ApplicationHelper
  
  

  # ページごとの完全なタイトルを返します。                   # コメント行
  def full_title(page_title = '')                     # メソッド定義とオプション引数
    base_title = "勤怠システム"  # 変数への代入
    if page_title.empty?                              # 論理値テスト
      base_title                                      # 暗黙の戻り値
    else 
      page_title + " | " + base_title                 # 文字列の結合
    end
  end
  
  def user_name_plete
    if logged_in?
      if current_user.admin?
        "admin"
      elsif current_user.sv?
        "supervisor"
      else
        "user"
      end
    end
  end

  
end