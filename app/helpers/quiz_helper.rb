module QuizHelper

  def formula(i)
    case i
    when 0
      '(T1 + T2) * 0.8 + D * 0.2'
    when 1
      '(T1 + T2) / 2'
    when 2
      '(T1) * 0.3 + (T2) * 0.3 + (D) * 0.4'
    end
  end

end