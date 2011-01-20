require 'mailheader'
require 'mailheaderoutput'
require 'CSV'

class MailHeaderParser
  attr_accessor :mail_header_output
  attr_accessor :count
  attr_accessor :received_value
  def initialize
  	@count=0
    @mail_header_output=MailHeaderOutput.new
    @received_value=""
  end

  def get_mail_header_output
    return @mail_header_output
  end
  
	#parser the email header
	def parser
		# read mail header from the file
		file= File.open("header.txt","r")
		file.each_line { |line|
			#parser received value from mail header
			parser_received(line)
      parser_email(line)
		}
	end
	def get_header_content(line)
    header_content=header_content+line;
    if line=="\r\n" or line.strip.empty?

    end
  end

	#parser the received from the mail header
	def parser_received(line)
		if line.include? MailHeader.received
      @count=@count+1
#      fields=line.split(MailHeader.key_separator)
      if line.length>1
          @received_value=@received_value+line
      end #end fields.length
    else
      if line.include? MailHeader.key_separator
        if received_value.start_with? MailHeader.received
          #get the received value
          puts @received_value
        end
        @received_value=""
      else
        @received_value=@received_value+line
      end
    end #end line include?

    # parser the received from the mail header
    if received_value.include? MailHeader.smtp_code_550 or received_value.include? MailHeader.smtp_code_551 or received_value.include? MailHeader.smtp_code_553 or received_value.include? MailHeader.smtp_code_554

    end
	end #end parser_received

  #parser email address from the mail header
  def parser_email(line)
    if line.include? MailHeader.from
      fields=line.split(MailHeader.key_separator)
      if fields.length>1
				value=fields[1].split(" ")
        if value.length>1
          firstname_lastname=value[0];
          email_address=value[1].gsub(/[<>]/,'')
          company_url="www."+email_address.split('@')[1];
          # if the email address is not contains the '@',the address is not correct
          unless email_address.include? "@"
            mail_header_output.firstname_lastname="UNKNOWN"
            mail_header_output.flastname="UNKNOWN"
          end
          mail_header_output.company_url=company_url
          check_firstname_lastname(email_address)
          check_flastname(email_address)
          check_email_name_conflict()
        end #end value.length
      end #end fields.length
    end #end line rindex
  end
  
	#check the format of the email whether is firstname.lastname
	def check_firstname_lastname(emailAddress)
		firstname_lastname_regex=/^([_a-z0-9-]+)*\.([a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$/
     if firstname_lastname_regex.match(emailAddress) !=nil
      mail_header_output.firstname_lastname = true;
      mail_header_output.correct_email_format="firstname.lastname"
    end
	end # end check_firstname_lastname

  #check the format whether is flastname
	def check_flastname(emailAddress)
		flastname_regex=/^[_a-z0-9-]*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$/
    if flastname_regex.match(emailAddress) !=nil
      mail_header_output.flastname = true;
      mail_header_output.correct_email_format="flastname"
    end
	end #end check_flastname

	#check the name whether conflicts
	def check_email_name_conflict()
    mail_header_output.name_conflicts = mail_header_output.firstname_lastname && mail_header_output.flastname
	end #end check_name_conflicts

  def generate_csv
    CSV.open('data.csv','w') do |csv_file|
      csv_file <<['company_url','correct_email_format','email_server_type','software_version','security_software','header_contents','firstname_lastname','flastname','name_conflicts','microsoft_exchange','microsoft_exchange_v_4','microsoft_exchange_v_5','microsoft_exchange_v_5_5','microsoft_exchange_v_6','microsoft_exchange_v_6_5','microsoft_exchange_v_8','lotus_notes_domino','lotus_notes_domino_version','novell_grouwpise','novell_grouwpise_version','google_apps','other_apps','software_conflicts','software_conflict_version']
      csv_file <<[mail_header_output.company_url,mail_header_output.correct_email_format.to_s,mail_header_output.email_server_type.to_s,mail_header_output.software_version.to_s,mail_header_output.security_software.to_s,mail_header_output.header_contents.to_s,mail_header_output.firstname_lastname.to_s ,mail_header_output.flastname.to_s,mail_header_output.name_conflicts.to_s,mail_header_output.microsoft_exchange.to_s ,mail_header_output.microsoft_exchange_v_4.to_s ,mail_header_output.microsoft_exchange_v_5.to_s,mail_header_output.microsoft_exchange_v_5_5.to_s,mail_header_output.microsoft_exchange_v_6.to_s,mail_header_output.microsoft_exchange_v_6_5.to_s,mail_header_output.microsoft_exchange_v_8.to_s ,mail_header_output.lotus_notes_domino.to_s,mail_header_output.lotus_notes_domino_version.to_s,mail_header_output.novell_grouwpise.to_s,mail_header_output.novell_grouwpise_version.to_s,mail_header_output.google_apps.to_s,mail_header_output.other_apps.to_s,mail_header_output.software_conflicts.to_s,mail_header_output.software_conflict_version.to_s]
    end
    puts "successfully!"
  end
end #end class

mailheader=MailHeaderParser.new
mailheader.parser()
puts "company_url:"+mailheader.get_mail_header_output().company_url
puts "correct_email_format:"+ mailheader.get_mail_header_output().correct_email_format.to_s
puts "email_server_type:"+ mailheader.get_mail_header_output().email_server_type.to_s
puts "software_version:"+ mailheader.get_mail_header_output().software_version.to_s
puts "security_software:"+ mailheader.get_mail_header_output().security_software.to_s
puts "header_contents:"+ mailheader.get_mail_header_output().header_contents.to_s
puts "firstname_lastname:"+ mailheader.get_mail_header_output().firstname_lastname.to_s
puts "flastname:"+ mailheader.get_mail_header_output().flastname.to_s
puts "name_conflicts:"+ mailheader.get_mail_header_output().name_conflicts.to_s
puts "microsoft_exchange:"+ mailheader.get_mail_header_output().microsoft_exchange.to_s
puts "microsoft_exchange_v_4:"+ mailheader.get_mail_header_output().microsoft_exchange_v_4.to_s
puts "microsoft_exchange_v_5:"+ mailheader.get_mail_header_output().microsoft_exchange_v_5.to_s
puts "microsoft_exchange_v_5_5:"+ mailheader.get_mail_header_output().microsoft_exchange_v_5_5.to_s
puts "microsoft_exchange_v_6:"+ mailheader.get_mail_header_output().microsoft_exchange_v_6.to_s
puts "microsoft_exchange_v_6_5:"+ mailheader.get_mail_header_output().microsoft_exchange_v_6_5.to_s
puts "microsoft_exchange_v_8:"+ mailheader.get_mail_header_output().microsoft_exchange_v_8.to_s
puts "lotus_notes_domino:"+ mailheader.get_mail_header_output().lotus_notes_domino.to_s
puts "lotus_notes_domino_version:"+ mailheader.get_mail_header_output().lotus_notes_domino_version.to_s
puts "novell_grouwpise:"+ mailheader.get_mail_header_output().novell_grouwpise.to_s
puts "novell_grouwpise_version:"+ mailheader.get_mail_header_output().novell_grouwpise_version.to_s
puts "google_apps:"+ mailheader.get_mail_header_output().google_apps.to_s
puts "other_apps:"+ mailheader.get_mail_header_output().other_apps.to_s
puts "software_conflicts:"+ mailheader.get_mail_header_output().software_conflicts.to_s
puts "software_conflict_version:"+ mailheader.get_mail_header_output().software_conflict_version.to_s
mailheader.generate_csv()