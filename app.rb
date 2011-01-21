require 'sinatra'
require 'dm-core'
require 'mailheaderparser'

get '/' do
  # Just list all the shouts
  mailheader=MailHeaderParser.new
	mailheader.parser()
	@company_url=mailheader.get_mail_header_output().company_url.to_s
	@correct_email_format=mailheader.get_mail_header_output().correct_email_format.to_s
	@email_server_type=mailheader.get_mail_header_output().email_server_type.to_s
	@software_version=mailheader.get_mail_header_output().software_version.to_s
	@security_software=mailheader.get_mail_header_output().security_software.to_s
	@header_contents=mailheader.get_mail_header_output().header_contents.to_s
	@firstname_lastname=mailheader.get_mail_header_output().firstname_lastname.to_s
	@flastname=mailheader.get_mail_header_output().flastname.to_s
	@name_conflicts=mailheader.get_mail_header_output().name_conflicts.to_s
	@microsoft_exchange=mailheader.get_mail_header_output().microsoft_exchange.to_s
	@microsoft_exchange_v_4=mailheader.get_mail_header_output().microsoft_exchange_v_4.to_s
	@microsoft_exchange_v_5=mailheader.get_mail_header_output().microsoft_exchange_v_5.to_s
	@microsoft_exchange_v_5_5=mailheader.get_mail_header_output().microsoft_exchange_v_5_5.to_s
	@microsoft_exchange_v_6=mailheader.get_mail_header_output().microsoft_exchange_v_6.to_s
	@microsoft_exchange_v_6_5=mailheader.get_mail_header_output().microsoft_exchange_v_6_5.to_s
	@microsoft_exchange_v_8=mailheader.get_mail_header_output().microsoft_exchange_v_8.to_s
	@lotus_notes_domino=mailheader.get_mail_header_output().lotus_notes_domino.to_s
	@lotus_notes_domino_version=mailheader.get_mail_header_output().lotus_notes_domino_version.to_s
	@novell_grouwpise=mailheader.get_mail_header_output().novell_grouwpise.to_s
	@novell_grouwpise_version=mailheader.get_mail_header_output().novell_grouwpise_version.to_s
	@google_apps=mailheader.get_mail_header_output().google_apps.to_s
	@other_apps=mailheader.get_mail_header_output().other_apps.to_s
	@software_conflicts=mailheader.get_mail_header_output().software_conflicts.to_s
	@software_conflict_version=mailheader.get_mail_header_output().software_conflict_version.to_s
  erb :index
end

post '/' do
  #redirect '/'
end


__END__
