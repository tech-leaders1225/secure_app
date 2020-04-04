# ユーザー
User.create!(name:  "admin",
             email: "admin@railstutorial.org",
             d_start_worktime: Time.zone.local(2018, 6, 30, 8,0),
             d_end_worktime: Time.zone.local(2018, 6, 30, 19,0),
             basic_work_time: Time.zone.local(2018, 6, 30, 7,30),
             password:              "foobar",
             password_confirmation: "foobar",
             worker_id: 111111,
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)
user = User.create!(name:  "上長A",
             email: "examplea@railstutorial.org",
             d_start_worktime: Time.zone.local(2018, 6, 30, 8,0),
             d_end_worktime: Time.zone.local(2018, 6, 30, 19,0),
             basic_work_time: Time.zone.local(2018, 6, 30, 7,30),
             password:              "foobar",
             password_confirmation: "foobar",
             worker_number: 1111,
             worker_id: 111112,
             sv:     true,
             activated: true,
             activated_at: Time.zone.now)


User.create!(name:  "上長B",
             email: "exampleb@railstutorial.org",
             d_start_worktime: Time.zone.local(2018, 6, 30, 8,0),
             d_end_worktime: Time.zone.local(2018, 6, 30, 19,0),
             basic_work_time: Time.zone.local(2018, 6, 30, 7,30),
             password:              "foobar",
             password_confirmation: "foobar",
             worker_id: 111113,
             worker_number: 1112,
             sv:     true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "上長C",
             email: "examplec@railstutorial.org",
             d_start_worktime: Time.zone.local(2018, 6, 30, 8,0),
             d_end_worktime: Time.zone.local(2018, 6, 30, 19,0),
             password:              "foobar",
             password_confirmation: "foobar",
             worker_id: 111114,
             worker_number: 1113,
             sv:     true,
             activated: true,
             activated_at: Time.zone.now)
             

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now,
               worker_id: 111120+n,
               worker_number: 1112+n,
               d_start_worktime: Time.zone.local(2018, 6, 30, 8,0),
               d_end_worktime: Time.zone.local(2018, 6, 30, 19,0))
end

# works
days = (Date.new(2018,5).all_month)
users = User.order(:created_at).take(2)
start_time = Time.new(2018, 5, 30, 9, 00, 00)
end_time = Time.new(2018, 5, 30, 17, 15, 00)
  users.each do |user|
    days.each do |day|
      work = user.works.create!(day: day,
             start_time: start_time,
             end_time: end_time)
             10.times {
          work.work_logs.create(day: day, 
                               start_time: start_time,
                               end_time: end_time,
                               starttime_change: start_time,
                               endtime_change: end_time,
                               work_check: "上長A",
                               user_id: user.id)
             }
    end
  end
  
    Base.create!(number: 2, name: "拠点A", kind: "出勤")
  


