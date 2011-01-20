class MailHeaderOutput
  
	attr_accessor :company_url
	attr_accessor :correct_email_format
	attr_accessor :email_server_type
	attr_accessor :software_version
	attr_accessor :security_software
	attr_accessor :header_contents
	attr_accessor :firstname_lastname
	attr_accessor :flastname
	attr_accessor :name_conflicts
	attr_accessor :microsoft_exchange
	attr_accessor :microsoft_exchange_v_4
	attr_accessor :microsoft_exchange_v_5
	attr_accessor :microsoft_exchange_v_5_5
	attr_accessor :microsoft_exchange_v_6
	attr_accessor :microsoft_exchange_v_6_5
	attr_accessor :microsoft_exchange_v_8
	attr_accessor :lotus_notes_domino
	attr_accessor :lotus_notes_domino_version
	attr_accessor :novell_grouwpise
	attr_accessor :novell_grouwpise_version
	attr_accessor :google_apps
	attr_accessor :other_apps
	attr_accessor :software_conflicts
	attr_accessor :software_conflict_version

  def initialize
    @company_url=""
    @correct_email_format=""
    @email_server_type=""
    @software_version=""
    @security_software=""
    @header_contents=""
    @firstname_lastname=false
    @flastname=false
    @name_conflicts=false
    @microsoft_exchange=false
    @microsoft_exchange_v_4=false
    @microsoft_exchange_v_5=false
    @microsoft_exchange_v_5_5=false
    @microsoft_exchange_v_6=false
    @microsoft_exchange_v_6_5=false
    @microsoft_exchange_v_8=false
    @lotus_notes_domino=false
    @lotus_notes_domino_version=""
    @novell_grouwpise=""
    @novell_grouwpise_version=""
    @google_apps=""
    @other_apps=""
    @software_conflicts=""
    @software_conflict_version=""
  end
end