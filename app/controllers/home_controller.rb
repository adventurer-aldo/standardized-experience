class HomeController < ApplicationController
    def index
        @journeyProgress = Statistic.first.activejourneylevel
        @ost =  if @journeyProgress == 0
                    @ost = 'https://cdn.discordapp.com/attachments/962345513825468456/964951311831416922/home.ogg'
                elsif @journeyProgress == 1
                    @ost = 'https://cdn.discordapp.com/attachments/962345513825468456/964951312083062844/prep.ogg'
                elsif @journeyProgress < 4
                    @ost = 'https://cdn.discordapp.com/attachments/962345513825468456/964951311294537768/prep2.ogg'
                elsif @journeyProgress > 3
                    @ost = 'https://cdn.discordapp.com/attachments/962345513825468456/964951311542026250/prepexam.ogg'
                end
        
        @tip = Question.where("subject LIKE 'Bioq%'").order(Arel.sql('RANDOM()')).limit(1)[0]
        
        @cheer = [["Este é apenas o começo...Tente ver o seu potencial.",
                    "Teste as suas habilidades.",
                    "O nível mais básicos dos básicos...Como você se sairá frente a este desafio?",
                    "Sem mais delongas. Vamos."],
                    ["A luta está para começar.",
                    "O primeiro obstáculo encontra-se a frente. Siga-o!",
                    "A hora do treino acabou. Começemos!",
                    "Será que você conseguirá vencer? Não é mais brincadeira."],
                    ["A primeira batalha terminou, mas ainda tem mais pela frente.",
                    "Uma batalha completamente diferente espera-o...Mas o que aprendeu antes também será usado.",
                    "O segundo obstáculo está aqui. Prepare-se.",
                    "Sem mais delongas. Vamos."],
                    ["Quê? Falhou um dos desafios anteriores? Talvez este campo de batalha não seja para você.",
                    "Esqueca os fracassos e pense em como transformá-los em oportunidades.",
                    "Melhor revisar os seus erros antes de prosseguir.",
                    "Ah, ainda não desistiu? Veremos por quanto tempo aguenta..."],
                    ['Está aqui...A "última" batalha...',
                    'Não passamos por todos aqueles obstáculos para cair em frente ao final.',
                    'Sem mais delongas...Pela última vez, vamos!',
                    'Hora de reivindicar a nossa vitória merecida.',
                    'Sem pensamentos. Mente vazia.'],
                    ['Esperava não ter que vir aqui...']]
    end

    def data
        @subjects = Subject.select(:title).order(title: 'asc')
    end

    def submit_question
        @oldQuestion = Question.last
        @newQuestion = Question.create(question: params[:question],
        questiontype: "[#{params[:type]}]",
        answer: params[:answer],
        subject: params[:subject],
        level: params[:level].to_i,
        tags: '[]',
        frequency: 0,
        parameters: "[#{params[:parameters].join(',')}]"
        )
        case params[:reuse_image]
        when "0"
            @newQuestion.image.attach(params[:image]) unless params[:image] == nil
        when "1"
            @newQuestion.image.attach(@oldQuestion.image.blob) unless @oldQuestion.image == nil
        end

        unless params[:choice] == nil
            params[:choice].uniq.each do |choice|
                Choice.create(decoy: choice, question: @newQuestion.id)
            end
            cookies[:choices] = params[:choice].size
        else
            cookies[:choices] = 0
        end

        cookies[:level] = params[:level]
        cookies[:type] = params[:type]
        cookies[:subject] = params[:subject]
        cookies[:reuse_image] = params[:reuse_image]

        redirect_to data_path
    end

    def about

    end
end
