module HomeHelper

  def exame(chair)
    return '---' if media(chair) == '---'

    if media(chair) >= 14.5
      'EXEMPTED'
    elsif media(chair) >= 9.5
      chair.exam.nil? ? 'PASSED' : chair.exam
    else
      'FAILED'
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
      content_tag(:caption, "Journey ##{current_user.journeys.size} -- Started at #{journey.start_time.to_time.day}/#{journey.start_time.to_time.mon}/#{journey.start_time.to_time.year}") +
      content_tag(:thead,
                  content_tag(:tr,
                              content_tag(:th, 'Subject', rowspan: '2', class: 'text-center') +
                              content_tag(:th, 'Grade', colspan: '7', class: 'text-center')
                            ) +
                  content_tag(:tr,
                              content_tag(:th, '1st Test', class: 'text-center') +
                              content_tag(:th, '2nd Test', class: 'text-center') +
                              content_tag(:th, 'Reposition Test', class: 'text-center') +
                              content_tag(:th, 'Course Work', class: 'text-center') +
                              content_tag(:th, 'Average', class: 'text-center') +
                              content_tag(:th, 'Exam', class: 'text-center') +
                              content_tag(:th, 'Recurrence Exam', class: 'text-center')
                            )
                   ) +
      content_tag(:tbody,
                  journey.chairs.order(id: :asc).collect { |chair|
                    highlight = case media(chair)
                                when '---'
                                  ''
                                when 0..9.49
                                  'table-danger'
                                when 9.5..14.4
                                  case exame(chair) 
                                  when '---'
                                    ''
                                  when 0..9.4, 'PASSED'
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
                                content_tag(:td, (chair.first.nil? || chair.second.nil? ? (chair.reposition.nil? ? '---' : chair.reposition.to_s.gsub('.',',')) : '---'), class: 'text-center') +
                                content_tag(:td, chair.dissertation.nil? ? '---' : chair.dissertation.to_s.gsub('.',','), class: 'text-center') +
                                content_tag(:td, media(chair).to_s.gsub('.', ','), class: 'text-center') +
                                content_tag(:td, exame(chair).to_s.gsub('.', ','), class: 'text-center') +
                                content_tag(:td, recurrence(chair).to_s.gsub('.', ','), class: 'text-center'),
                                class: "table-group-divider #{highlight}"),
                    root_path) }.join.html_safe), id: 'journey', class: 'table table-bordered table-striped table-striped-columns table-hover overflow-scroll'
                )
  end

  def nav(to: 'home')
    buttons = case to
              when 'home'
                [[root_path, 'Journey', 'shield-alt'], [classroom_path, 'Lesson', 'language'],
                 ['#', 'Challenges', 'flag-checkered']]
              when 'data'
                [[question_path, 'Questions', 'question-circle'], [subject_path, 'Subjects', 'book'],
                 [statistics_path, 'Statistics', 'graduation-cap'], [configurations_path, 'Settings', 'cogs']]
              when 'devise'
                [[question_path, 'Questions', 'question-circle'], [subject_path, 'Subjects', 'book'],
                 [statistics_path, 'Statistics', 'graduation-cap'], [configurations_path, 'Settings', 'cogs']]
              end
    render 'shared/nav', buttons:
  end
end
