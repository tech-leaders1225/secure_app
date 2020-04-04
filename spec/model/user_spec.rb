require 'rails_helper'

RSpec.describe User, type: :model do
  # Userは名前とemailだけでは無効。
    it "is invalid with only name, email" do
      user = User.new(
        name: "加藤純一",
        email: "加藤純一？　神"
        )
      expect(user).to be_invalid
    end
    
    # Userは名前、email、パスワードがあれば有効
    it "is valid with name, email, password" do
      user = User.new(
        name: "加藤純一",
        email: "changemymind6@gmail.com",
        password: "shotaimai6"
        )
      expect(user).to be_valid
    end
    
    # パスワードは６文字以上で有効。
    it "is valid with password over 6 length" do
      user = User.new(
        name: "加藤純一",
        email: "changemymind6@gmail.com",
        password: "111111"
        )
      expect(user).to be_valid
      
      invalid_user = User.new(
        name: "加藤純",
        email: "changemymind@gmail.com",
        password: "11111"
        )
      expect(invalid_user).to be_invalid
      invalid_user.valid?
      expect(invalid_user.errors[:password]).to include("は6文字以上で入力してください")
    end
    
    # idはユニークでないとだめ
    it "is invalid with unique id" do
        user = User.new(name: "加藤純一",
                        email: "changemymind6@gmail.com",
                        password: "111111",
                        id: "1"
                        )
      expect(user).to be_valid
      
      user_2 = User.new(name: "加藤純",
                              email: "changemymind@gmail.com",
                              password: "111111",
                              id: "1"
                              )
    expect(user_2).to be_valid
    user.save!
    user_2.valid?
    expect(user_2.errors[:id]).to include("はすでに存在します")
    end
    
    # before_saveメソッドのdowncase_emailが有効か検証（大文字を小文字に変換）
    it "before_saveメソッドのdowncase_emailが有効か検証" do
        user = User.new(name: "imai",
                        email: "CHANGEmymind6@gmail.com",
                        password: "141421356")
        user.save!
        expect(user.email).to eq "changemymind6@gmail.com"
    end
    
    # emailは２５５文字以下
    it "emailは２５５文字以下でないとだめ" do
        user = User.new(name: "imai",
                        email: "#{"c@gmail.com" * 225}",
                        password: "141421356")
        expect(user).to be_invalid
        user_2 = User.new(name: "imai",
                        email: "#{"c@gmail.com"}",
                        password: "141421356")
        expect(user_2).to be_valid
    end
    
    # nameは５０文字以下でないとだめ
    it "nameは５０文字以下でないとだめ" do
        user = User.new(name: "imaia" * 11,
                        email: "#{"c@gmail.com"}",
                        password: "141421356")
        expect(user).to be_invalid
        user_2 = User.new(name: "imaia" * 10,
                        email: "#{"c@gmail.com"}",
                        password: "141421356")
        expect(user_2).to be_valid
    end
    
end