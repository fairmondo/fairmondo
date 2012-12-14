class TailFile < File

    def tail(n)
      buffer = 1024
      idx = (size - buffer).abs
      chunks = []
      lines = 0
  
      begin
        seek(idx)
        chunk = read(buffer)
        lines += chunk.count("\n")
        chunks.unshift chunk
        idx -= buffer
      end while lines < ( n + 1 ) && pos != 0
  
      tail_of_file = chunks.join('')
      ary = tail_of_file.split(/\n/)
      lines_to_return = ary[ ary.size - n, ary.size - 1 ]
  
    end
end

module ActiveAdmin::ViewHelper
  

  def get_production_log
    begin
      f = TailFile.open(File.join(Rails.root,"log","production.log")) 
      data = f.tail(100)
      log = data.join("\n")
    rescue
      "Problem with the log file!"
    end 
   
  end
end

