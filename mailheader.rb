class MailHeader
	public
	@@received="Received: "
	@@key_separator=": "
	
	def MailHeader.received
		return @@received
	end
	
	def MailHeader.key_separator
		return @@key_separator
	end
end