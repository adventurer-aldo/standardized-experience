module QuestionHelper
  def map_with_decoys(variables)
    variables.map do |id|
      choice = Choice.find_by(id: id.to_i)
      if choice.image.attached?
        [choice.texts[0], choice.image.url]
      else
        [choice.texts[0]]
      end
    end
  end

end