module HomeHelper

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
    case chair.journey.level
    when 1
      chair.first.nil?
    when 2
      chair.second.nil?
    when 3
      chair.reposition.nil?
    when 4
      chair.dissertation.nil?
    when 5
      chair.exam.nil?
    when 6
      chair.recurrence.nil?
    when 7
      false
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
                              content_tag(:th, '1º Teste', class: 'text-center') +
                              content_tag(:th, '2º Teste', class: 'text-center') +
                              content_tag(:th, 'Teste de Reposição', class: 'text-center') +
                              content_tag(:th, 'Dissertação', class: 'text-center') +
                              content_tag(:th, 'Média Final', class: 'text-center') +
                              content_tag(:th, 'Exame Normal', class: 'text-center') +
                              content_tag(:th, 'Exame de Recorrência', class: 'text-center')
                            )
                   ) +
      content_tag(:tbody,
                  journey.chairs.order(id: :asc).collect { |chair|
                    highlight = case media(chair).round(1)
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
                                when 14.5..20.0
                                  'table-success'
                                end
                    link_to(
                    content_tag(:tr,
                                content_tag(:td, chair_check(chair) ? (link_to(quiz_path(journey: journey.id, level: journey.level, subject: chair.subject.id), class: 'stretched-link'){chair.subject.title}) : chair.subject.title, class: 'position-relative text-center') +
                                content_tag(:td, chair.first.nil? ? '---' : chair.first.to_s.gsub('.',','), class: 'text-center') +
                                content_tag(:td, chair.second.nil? ? '---' : chair.second.to_s.gsub('.',','), class: 'text-center') +
                                content_tag(:td, ((chair.first.nil? || chair.second.nil?) ? (chair.reposition.nil? ? '---' : chair.reposition.to_s.gsub('.',',')) : '---'), class: 'text-center') +
                                content_tag(:td, chair.dissertation.nil? ? '---' : chair.dissertation.to_s.gsub('.',','), class: 'text-center') +
                                content_tag(:td, media(chair).to_s.gsub('.',','), class: 'text-center') +
                                content_tag(:td, exame(chair).to_s.gsub('.',','), class: 'text-center') +
                                content_tag(:td, recurrence(chair).to_s.gsub('.',','), class: 'text-center'),
                               class: "table-group-divider #{highlight}"),
                               root_path)}.join.html_safe), class: 'table table-striped table-striped-columns table-hover overflow-scroll'
                )
  end

end
