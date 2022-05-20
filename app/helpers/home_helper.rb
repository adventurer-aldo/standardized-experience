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

  def journey_table(journey)
    content_tag(:table,
      content_tag(:thead,
                  content_tag(:tr,
                              content_tag(:th, 'Cadeira', rowspan: '2') +
                              content_tag(:th, 'Notas', colspan: '7')
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
                    content_tag(:tr,
                                content_tag(:td, chair.subject.title) +
                                content_tag(:td, (chair.first.nil? ? '---' : chair.first)) +
                                content_tag(:td, chair.second.nil? ? '---' : chair.second) +
                                content_tag(:td, chair.reposition.nil? ? '---' : chair.reposition) +
                                content_tag(:td, chair.dissertation.nil? ? '---' : chair.dissertation) +
                                content_tag(:td, media(chair).to_s) +
                                content_tag(:td, exame(chair).to_s) +
                                content_tag(:td, recurrence(chair).to_s),
                               class: 'table-group-divider')
                  }.join.html_safe), class: 'table table-striped table-striped-columns table-hover'
                )
  end

end