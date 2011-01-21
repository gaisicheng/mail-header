class MailHeader
	public
	@@received="received: "
	@@key_separator=": "
  @@from="from: "
  @@SMTP_CODE_550="550"
  @@SMTP_CODE_551="551"
  @@SMTP_CODE_552="552"
  @@SMTP_CODE_553="553"
	@@SMTP_CODE_554="554"
  @@UNKNOWN="UNKNOWN"
  @@NULL="NULL"
  @@microsoft="microsoft"
  @@exchange="exchange"
  @@MimeOLE="mimeole"
  @@Xwall="xwall"

	def MailHeader.received
		return @@received
	end
	
	def MailHeader.key_separator
		return @@key_separator
	end

  def MailHeader.from
		return @@from
	end

  def MailHeader.smtp_code_550
    return @@SMTP_CODE_550
  end

  def MailHeader.smtp_code_551
    return @@SMTP_CODE_551
  end

  def MailHeader.smtp_code_552
    return @@SMTP_CODE_552
  end
  
  def MailHeader.smtp_code_553
    return @@SMTP_CODE_553
  end

  def MailHeader.smtp_code_554
    return @@SMTP_CODE_554
  end

  def MailHeader.unknown
    return @@UNKNOWN
  end

  def MailHeader.null
    return @@NULL
  end

  def MailHeader.microsoft
    return @@microsoft
  end

  def MailHeader.exchange
    return @@exchange
  end

  def MailHeader.MimeOLE
    return @@MimeOLE
  end

  def MailHeader.Xwall
    return @@Xwall
  end

end