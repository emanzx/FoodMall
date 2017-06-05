
module OrderCron

  def self.cron_job
    today = Date.today.strftime("%d/%m/%Y")
    offday = Offday.find_by(date_off: today)
    if offday.nil?
      @days = Date.today.strftime("%A").downcase
      HardWorker.perform_async(@days)
    end
  end

end