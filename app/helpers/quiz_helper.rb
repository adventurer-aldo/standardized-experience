module QuizHelper
  def input_answer(answer)
    case answer.question_type
    when 'open', 'formula'
      puts content_tag :input, name: "answer[#{answer.id}][]", class: 'form-control form-control-lg', placeholder: 'Hello there', 'aria-label' => '.form-control-lg example'
      return content_tag :input, name: "answer[#{answer.id}][]", class: 'form-control form-control-lg', placeholder: 'Hello there', 'aria-label' => '.form-control-lg example'
    when 'choice'
    when 'multichoice'
    when 'caption'
    when 'veracity'
    end
  end
end