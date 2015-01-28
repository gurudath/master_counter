module Increment
  class Counter
   FIELDS = ['sequence_char','year','month','date','count']
   
   def self.initialize_values(options={})
     @sequence_char = options[:sequence_char] || 'G'
     @precision = options[:precision] || 4
     @uniq_string = options[:uniq_string] || ""
     @uniq_string_flag = options[:uniq_string_flag] || false
     @uniq_string_pression = options[:uniq_string_pression] || 4
     @reset_time = options[:reset_time] || 1 
     @reset_time_in = options[:reset_time_in] || "D"
     @reset_time_flag = options[:reset_time_flag] || false
     @time = Time.zone.now
     @year = @time.strftime('%Y')
     @month = @time.strftime('%m')
     @date = @time.strftime('%d')
   end

   def self.time_diff(start_time, end_time)
     seconds_diff = (start_time - end_time).to_i.abs
     hours = seconds_diff / 3600
     seconds_diff -= hours * 3600
     minutes = seconds_diff / 60
     seconds_diff -= minutes * 60
     seconds = seconds_diff
     minutes.to_s.rjust(2, '0') 
   end

   def self.evaluate_counter
    if @reset_time_flag and !Models::MasterCounterList.all.blank?
     if @reset_time_in == "D"
       diff_date = (Time.zone.now.to_date - Models::MasterCounterList.order('created_at desc').last.created_at.to_date).to_i
     else
       diff_date =  self.time_diff(Time.zone.now,Models::MasterCounterList.order('created_at desc').last.created_at)      
     end 
     @count = if diff_date.to_i >= @reset_time  
                Models::MasterCounterList.delete_all 
                "0"
              else 
                Models::MasterCounterList.order('created_at desc').first.counter.to_s     
              end
    else
     @count = Models::MasterCounterList.all.blank? ? (Models::MasterCounterList.delete_all;"0") : Models::MasterCounterList.order('created_at desc').first.counter.to_s
    end
   end

   def self.save_counter(string)
     increment_counter = (@count.to_i + 1).to_s.rjust(@precision.to_i , '0')
     Models::MasterCounterList.create(counter: increment_counter, counter_string: string)
   end   

   def self.build_counter_string
     string = ""
     FIELDS.each do |field_str|
         evaluated_string = eval("@#{field_str}")
         string +=  evaluated_string.to_s if !evaluated_string.blank?
     end
     return string
   end

   def self.increment(options={})
     self.initialize_values(options)
     self.evaluate_counter
     @count = @count.rjust(@precision.to_i , '0')
     string = self.build_counter_string
     string.insert(@uniq_string_pression,@uniq_string) if @uniq_string_flag
     self.save_counter(string)
     puts string
   end
  end
end

