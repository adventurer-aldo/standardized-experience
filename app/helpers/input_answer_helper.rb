module InputAnswerHelper

  def input_answer(answer)
    case answer.question_type
    when 'open', 'formula'
    when 'choice'
    when 'multichoice'
    when 'caption'
    when 'veracity'
    end
  end

end