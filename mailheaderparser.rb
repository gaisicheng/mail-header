require 'mailheader'
require 'mailheaderoutput'
require 'CSV'

class MailHeaderParser
  attr_accessor :mail_header_output
  attr_accessor :count
  def initialize
  	@count=0
    @mail_header_output=MailHeaderOutput.new
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
      @count=@count+1
			parser_received(line)
      parser_email(line)
		}
	end
	
	#parser the received from the mail header
	def parser_received(line)
		if line.include? MailHeader.received
      fields=line.split(MailHeader.key_separator)
      key=fields[0]
      #puts "Key is :" +key
      if fields.length>1
				value=fields[1].split(" ")
        if value.length>1
          received_value=value[1]
          #ip regex
          ip_regex=/^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$/
          domain_regex=/([a-zA-z0-9]\.).*/
          if ip_regex.match(received_value)==nil && domain_regex.match(received_value)!=nil && @count==3
            mail_header_output.company_url=received_value
          end
          return received_value
        end #end value.length
      end #end fields.length
    end #end line rindex
	end #end def parser_received

  #parser email address from the mail header
  def parser_email(line)
    if line.include? MailHeader.from
      fields=line.split(MailHeader.key_separator)
      key=fields[0]
      #puts "Key is :" +key
      if fields.length>1
				value=fields[1].split(" ")
        if value.length>1
          firstname_lastname=value[0];
          email_address=value[1].gsub(/[<>]/,'')
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