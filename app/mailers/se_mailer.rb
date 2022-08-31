class SeMailer < ApplicationMailer
  default from: 'Standardized Experience'

  def test
    mail(
      to: 'givepi1635@xitudy.com', # 'givepi1635@xitudy.com',
      subject: 'Mais um passo'
    )
  end
end
