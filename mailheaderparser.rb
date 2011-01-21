require 'mailheader'
require 'mailheaderoutput'
#require 'CSV'

class MailHeaderParser
  attr_accessor :mail_header_output
  attr_accessor :count
  attr_accessor :received_value
  attr_accessor :header_content
  def initialize
  	@count=0
    @mail_header_output=MailHeaderOutput.new
    @received_value=""
    @header_content=""
  end

  def get_mail_header_output
    return @mail_header_output
  end
  
	#parser the email header
	def parser
		# read mail header from the file
		file= File.open("header.txt","r")
    header=""
		file.each_line { |line|
     header= get_header_content(line).to_s
      check_google_apps(line)
      line=line.downcase
			#parser received value from mail header
			parser_received(line)
      parser_email(line)
      check_google_apps(line)
		}
    lower_case_header=header.downcase;
    check_microsoft_exchange(lower_case_header)
    check_lotus_notes(lower_case_header)
    check_novell_grouwpise(lower_case_header)
    check_other_apps(lower_case_header)
    check_software_conflicts()
    check_software_version_conflicts()
    get_security_software(lower_case_header)
	end
	def get_header_content(line)
    #    @header_content=@header_content+line
    #    if line.strip.length==0 or line.strip.empty?
    #    mail_header_output.header_contents=@header_content
    #      return @header_content
    #    end
    mail_header_output.header_contents=mail_header_output.header_contents+line
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
          #          puts @received_value
        end
        @received_value=""
      else
        @received_value=@received_value+line
      end
    end #end line include?

    # parser the received from the mail header
    if received_value.include? MailHeader.smtp_code_550 or received_value.include? MailHeader.smtp_code_551 or received_value.include? MailHeader.smtp_code_553 or received_value.include? MailHeader.smtp_code_554
      mail_header_output.correct_email_format=MailHeader.unknown
    elsif received_value.include? MailHeader.smtp_code_552
      #the address is correct
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
            mail_header_output.firstname_lastname=MailHeader.unknown
            mail_header_output.flastname=MailHeader.unknown
          end
          mail_header_output.company_url=company_url
          check_firstname_lastname(email_address)
          check_flastname(email_address)
          check_email_name_conflict()
        end #end value.length
      end #end fields.length
    end #end line include
  end

  #get the microsoft exchange's version
  def get_microsoft_exchange_version(line)
    line=line.downcase
    if line.include? 'exchange 4' or line.include? 'exchange v4' or line.include? 'mimeole v4'
      mail_header_output.microsoft_exchange_v_4=true;
    end
    
    if line.include? 'exchange 5.5' or line.include? 'exchange v5.5' or line.include? 'mimeole v5.5'
      mail_header_output.microsoft_exchange_v_5_5=true;
    elsif line.include? 'exchange 4' or line.include? 'exchange v4' or line.include? 'mimeole v4'
      mail_header_output.microsoft_exchange_v_5=true;
    end

    if line.include? 'exchange 6.5' or line.include? 'exchange v6.5' or line.include? 'mimeole v6.5'
      mail_header_output.microsoft_exchange_v_6_5=true;
    elsif line.include? 'exchange 6' or line.include? 'exchange v6' or line.include? 'mimeole v6'
      mail_header_output.microsoft_exchange_v_6=true;
    end
    
    if line.include? 'exchange 8' or line.include? 'exchange server 2007' or line.include? 'microsoft 2007' or line.include? 'exchange2007' or line.include? 'mimeole v8'
      mail_header_output.microsoft_exchange_v_8=true;
    end
  end

  def get_lotus_notes_domino_version(header)
    contains_string="domino release"
    if mail_header_output.lotus_notes_domino
      if header.include? contains_string
        index=line.rindex contains_string
        lotus_notes_domino_version=header[index+contains_string.length,6].strip
        puts lotus_notes_domino_version
      else
        mail_header_output.lotus_notes_domino_version=MailHeader.unknown
      end #end include?
    else
      mail_header_output.lotus_notes_domino_version=MailHeader.null
    end #end if mail_header_output.lotus_notes_domino
  end #end get_lotus_notes_domino_version

  def check_lotus_notes(header)
    if header.include? 'notes' or header.include? 'lotus' or header.include? 'mimeole v4'
      mail_header_output.lotus_notes_domino=true
    end
    get_lotus_notes_domino_version(header)
  end

  def check_microsoft_exchange(header)
    if header.include? MailHeader.microsoft or header.include? MailHeader.microsoft or header.include? MailHeader.microsoft or header.include? MailHeader.microsoft
      mail_header_output.microsoft_exchange=true;
    end
    get_microsoft_exchange_version(header)
  end

  #check novell grouwpise
  def check_novell_grouwpise(header)
    if header.include? 'groupwise' or header.include? 'novell'
      mail_header_output.novell_grouwpise=true;
    end
    contains_string="groupwise internet agent"
    if mail_header_output.novell_grouwpise
      if header.include? contains_string
        index=header.rindex contains_string
        novell_grouwpise_version=header[index+contains_string.length,6].strip
        mail_header_output.novell_grouwpise_version=novell_grouwpise_version
      else
        mail_header_output.novell_grouwpise_version=MailHeader.unknown
      end #end include?
    else
      mail_header_output.novell_grouwpise_version=MailHeader.null
    end #end ifmail_header_output.novell_grouwpise
  end

  def check_google_apps(line)
    if line.start_with?("message-id: ")
      fields=line.split(MailHeader.key_separator)
      if fields.length>1
        value=fields[1].split("@")
        if value.length>1
          mail_google_com= value[1].gsub(/[<>]/,'')
          if mail_google_com=='mail.gmail.com'
            mail_header_output.google_apps=true;
          end
        end #end value.length
      end #end fields.length
    end #end header rindex
  end

  def check_other_apps(header)
    if header.include? "x-mailer: firstclass"
      mail_header_output.other_apps=true;
      mail_header_output
    elsif header.include? "tumbleweed"
      mail_header_output.other_apps=true;
    elsif header.include? "yahoo"
      mail_header_output.other_apps=true;
    elsif header.include? "apple"
      mail_header_output.other_apps=true;
    end
  end

  def check_software_conflicts()
    software_count=0
    mailer_type=""
    if mail_header_output.microsoft_exchange
      software_count=software_count+1
      mailer_type="Microsoft Exchange"
    end
    if mail_header_output.lotus_notes_domino
      software_count=software_count+1
      mailer_type="Lotus Notes"
    end
    if mail_header_output.novell_grouwpise
      software_count=software_count+1
      mailer_type="Novell"
    end
    if mail_header_output.google_apps
      software_count=software_count+1
      mailer_type="Google Apps"
    end
    if mail_header_output.other_apps
      software_count=software_count+1
      mailer_type="Other apps"
    end
    
    if software_count>1
      mail_header_output.software_conflicts=true
    else
       mail_header_output.email_server_type=mailer_type
    end
  end

  def check_software_version_conflicts()
    software_version_count=0
    mailer_type_version=""
    if mail_header_output.microsoft_exchange_v_4.to_s=='true'
       software_version_count=software_version_count+1
       mailer_type_version="Microsoft Exchange 4"
    end
    if mail_header_output.microsoft_exchange_v_5.to_s=='true'
      software_version_count=software_version_count+1
      mailer_type_version="Microsoft Exchange 5"
    end
    if mail_header_output.microsoft_exchange_v_5_5.to_s=='true'
      software_version_count=software_version_count+1
      mailer_type_version="Microsoft Exchange 5.5"
    end
    if mail_header_output.microsoft_exchange_v_6.to_s=='true'
      software_version_count=software_version_count+1
      mailer_type_version="Microsoft Exchange 6"
    end
    if mail_header_output.microsoft_exchange_v_6_5.to_s=='true'
      software_version_count=software_version_count+1
      mailer_type_version="Microsoft Exchange 6.5"
    end
    if mail_header_output.microsoft_exchange_v_8.to_s=='true'
      software_version_count=software_version_count+1
      mailer_type_version="Microsoft Exchange v8 or Exchange 2007"
    end

    if software_version_count>1
      mail_header_output.software_version_conflicts=true
    else
       mail_header_output.software_version=mailer_type_version
    end
  end

  def get_security_software(header)
    if header.include? 'x-mailer: websense' or header.include? 'surfcontrol e-mail filter'
       mail_header_output.security_software='Websense'
    elsif header.include? 'xwall'
       mail_header_output.security_software='Xwall'
    end
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
    if (!mail_header_output.firstname_lastname && !mail_header_output.flastname)
      mail_header_output.correct_email_format=MailHeader.unknown
    end
	end #end check_name_conflicts

#  def generate_csv
#    CSV.open('data.csv','w') do |csv_file|
#      csv_file <<['company_url','correct_email_format','email_server_type','software_version','security_software','header_contents','firstname_lastname','flastname','name_conflicts','microsoft_exchange','microsoft_exchange_v_4','microsoft_exchange_v_5','microsoft_exchange_v_5_5','microsoft_exchange_v_6','microsoft_exchange_v_6_5','microsoft_exchange_v_8','lotus_notes_domino','lotus_notes_domino_version','novell_grouwpise','novell_grouwpise_version','google_apps','other_apps','software_conflicts','software_conflict_version']
#      csv_file <<[mail_header_output.company_url,mail_header_output.correct_email_format.to_s,mail_header_output.email_server_type.to_s,mail_header_output.software_version.to_s,mail_header_output.security_software.to_s,mail_header_output.header_contents.to_s,mail_header_output.firstname_lastname.to_s ,mail_header_output.flastname.to_s,mail_header_output.name_conflicts.to_s,mail_header_output.microsoft_exchange.to_s ,mail_header_output.microsoft_exchange_v_4.to_s ,mail_header_output.microsoft_exchange_v_5.to_s,mail_header_output.microsoft_exchange_v_5_5.to_s,mail_header_output.microsoft_exchange_v_6.to_s,mail_header_output.microsoft_exchange_v_6_5.to_s,mail_header_output.microsoft_exchange_v_8.to_s ,mail_header_output.lotus_notes_domino.to_s,mail_header_output.lotus_notes_domino_version.to_s,mail_header_output.novell_grouwpise.to_s,mail_header_output.novell_grouwpise_version.to_s,mail_header_output.google_apps.to_s,mail_header_output.other_apps.to_s,mail_header_output.software_conflicts.to_s,mail_header_output.software_conflict_version.to_s]
#    end
#    puts "successfully!"
#  end
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
#mailheader.generate_csv()