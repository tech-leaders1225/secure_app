require 'csv'

# bomを作成
bom = "\uFEFF"
 
CSV.generate(bom) do |csv|
  csv_column_names = ["日付","出社時間","退社時間","備考"]
  csv << csv_column_names
  @works.each do |work|
    csv_column_values = [
      work.day,
      if work.start_time
        work.start_time.strftime("%R")
      end,
      if work.end_time
        work.end_time.strftime("%R")
      end,
      work.note,
    ]
    csv << csv_column_values
  end
end