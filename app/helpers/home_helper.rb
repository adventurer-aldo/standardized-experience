module HomeHelper

  def formula(i)
    case i
    when 0
      "(T1 + T2) * 0.8 + D * 0.2"
    end
  end

  def media(chair)
    if chair.first && chair.second && chair.dissertation
      case chair.subject.formula
      when 0
        (((chair.first + chair.second) / 2 * 0.8) + (chair.dissertation * 0.2)).round(2)
      end
    else
      '---'
    end
  end

  def exame(chair)
    return '---' if media(chair) == '---'

    if media(chair) >= 14.5
      'DISPENSADO'
    elsif media(chair) >= 9.5
      chair.exam.nil? ? 'ADMITIDO' : chair.exam
    else
      'EXCLUÍDO'
    end
  end

  def recurrence(chair)
    return '---' if exame(chair).is_a?(String)

    if exame(chair) > 9.5 || chair.recurrence.nil?
      '---'
    else
      chair.recurrence
    end
  end

  def chair_check(chair)
    level = chair.journey.level
    case level
    when 1
      return chair.first.nil?
    when 2
      return chair.second.nil?
    when 3
      return chair.reposition.nil?
    when 4
      return chair.dissertation.nil?
    when 5
      return chair.exam.nil?
    when 6
      return chair.recurrence.nil?
    when 7
      return false
    end
  end

  def journey_table(journey)
    content_tag(:table,
      content_tag(:caption, "Jornada #{journey.id}") +
      content_tag(:thead,
                  content_tag(:tr,
                              content_tag(:th, 'Cadeira', rowspan: '2') +
                              content_tag(:th, 'Notas', colspan: '7', class: 'text-center')
                            ) +
                  content_tag(:tr,
                              content_tag(:th, '1º Teste') +
                              content_tag(:th, '2º Teste') +
                              content_tag(:th, 'Teste de Reposição') +
                              content_tag(:th, 'Dissertação') +
                              content_tag(:th, 'Média Final') +
                              content_tag(:th, 'Exame Normal') +
                              content_tag(:th, 'Exame de Recorrência')
                            )
                   ) +
      content_tag(:tbody,
                  journey.chairs.collect { |chair|
                    highlight = case media(chair)
                                when '---'
                                  ''
                                when 0..9.4
                                  'table-danger'
                                when 9.5..14.4
                                  case exame(chair) 
                                  when '---'
                                    ''
                                  when 0..9.4, 'ADMITIDO'
                                    case recurrence(chair)
                                    when '---'
                                      'table-warning'
                                    when 0..9.4
                                      'table-danger'
                                    else
                                      'table-success'
                                    end
                                  else
                                    'table-success'
                                  end
                                when 14.5..20
                                  'table-success'
                                end
                    link_to(
                    content_tag(:tr,
                                content_tag(:td, chair_check(chair) ? (link_to(quiz_path(journey: journey.id, level: journey.level, subject: chair.subject.id), class: 'stretched-link'){chair.subject.title}) : chair.subject.title) +
                                content_tag(:td, (chair.first.nil? ? '---' : chair.first)) +
                                content_tag(:td, chair.second.nil? ? '---' : chair.second) +
                                content_tag(:td, ((chair.first.nil? || chair.second.nil?) ? (chair.reposition.nil? ? '---' : chair.reposition) : '---')) +
                                content_tag(:td, chair.dissertation.nil? ? '---' : chair.dissertation) +
                                content_tag(:td, media(chair).to_s) +
                                content_tag(:td, exame(chair).to_s) +
                                content_tag(:td, recurrence(chair).to_s),
                               class: "table-group-divider #{highlight}"),
                               root_path)}.join.html_safe), class: 'table table-striped table-striped-columns table-hover overflow-scroll'
                )
  end

end