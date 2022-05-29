module QuizHelper

  def media(chair)
    if chair.first && chair.second && chair.dissertation
      case chair.subject.formula
      when 0
        (((chair.first + chair.second) / 2.0 * 0.8) + (chair.dissertation * 0.2)).round(2)
      when 1
        (chair.first + chair.second) / 2.0
      when 2
        (chair.first * 0.3) + (chair.second * 0.3) + (chair.dissertation * 0.4)
      when 3
        (((chair.first + chair.second) / 2.0 * 0.7) + (chair.dissertation * 0.3)).round(2)
      when 4
        (((chair.first + chair.second) / 2.0 * 0.4) + (chair.dissertation * 0.6)).round(2)
      end
    else
      '---'
    end
  end

  def formula(i)
    case i
    when 0
      '(T1 + T2) * 0.8 + D * 0.2'
    when 1
      '(T1 + T2) / 2'
    when 2
      '(T1) * 0.3 + (T2) * 0.3 + (D) * 0.4'
    when 3
      '(T1 + T2) / 2 * 0.7 + D * 0.3'
    when 4
      '(T1 + T2) / 2 * 0.4 + D * 0.6'
    end
  end

end