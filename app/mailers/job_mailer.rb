class JobMailer < ApplicationMailer

  def send_real_time_data_to_trader(wind_farm, global_csv, unit_csv)
    common_name = "#{wind_farm.slug.upcase}_#{Time.now.strftime('%Y%m%d_%H%M%S')}"
    recipients = JSON.parse(wind_farm.trader_email)
    attachments["CNR_LiveData_WF_#{common_name}.csv"] = { mime_type: 'text/csv', content: global_csv }
    attachments["CNR_LiveData_WTG_#{common_name}.csv"] = { mime_type: 'text/csv', content: unit_csv }
    mail(to: recipients['to'], cc: recipients['cc'], subject: wind_farm.trader_mail_subject, body: 'Données temps réel')
  end
end
