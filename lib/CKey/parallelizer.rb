module CKey
  def grab_keyboard
    Thread.new do 
      begin
        start_event_loop
      rescue Exception => e
        p e
      end
    end
    sleep 0.3
  end
end
