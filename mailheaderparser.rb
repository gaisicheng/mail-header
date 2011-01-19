require 'mailheader'
require 'mailheaderoutput'

class MailHeaderParser
  attr_accessor :mail_header_output
  def initialize
    @mail_header_output=MailHeaderOutput.new
  end

  def get_mail_header_output
    return @mail_header_output
  end
  
	#parser the email header
	def parser
    puts  File.exist?("Received")
		# read mail header from the file
		file= File.open("header.txt","r")
		file.each_line { |line|
			#parser received value from mail header
			parser_received(line)
		}
	end
	
	#parser the received from the mail header
	def parser_received(line)
		if line.rindex(MailHeader.received)!=nil
				fields=line.split(MailHeader.key_separator)
				key=fields[0]
				#puts "Key is :" +key
				if fields.length>1
				value=fields[1].split(" ")
					if value.length>1
						received_value=value[1]
						puts "mail header parser return the value : " + received_value
            mail_header_output.company_url=received_value
						return received_value
					end #end value.length
			  end #end fields.length
			end #end line rindex
	end #end def parser_received

	#check the format of the email
	def check_firstname_lastname(emailAddress)
		pattern ="//d/"
		puts emailAddress.match(pattern)
	end # end check_firstname_lastname
	
	def check_flastname(emailAddress)
		pattern = String.new("")
		puts emailAddress.match(pattern)
	end #end check_flastname
end #end class

mailheader=MailHeaderParser.new
mailheader.parser()
puts mailheader.get_mail_header_output().company_url