module InputAnswerHelper

  def input_answer(answer)
    case answer.question_type
    when 'open', 'formula'
      %(<input name="answer[#{answer.id}][]" class="form-control form-control-lg" type="text" placeholder="" aria-label=".form-control-lg example">)
    when 'choice'
    when 'multichoice'
    when 'caption'
    when 'veracity'
    end
    1
  end

end