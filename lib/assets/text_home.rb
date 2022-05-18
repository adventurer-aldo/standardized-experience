module Misc

  class Text
    def self.cheer
        return [['Este é apenas o começo...Tente ver o seu potencial.',
                 'Teste as suas habilidades.',
                 'O nível mais básicos dos básicos...Como você se sairá frente a este desafio?',
                 'Sem mais delongas. Vamos.'],
                ['A luta está para começar.',
                 'O primeiro obstáculo encontra-se a frente. Siga-o!',
                 'A hora do treino acabou. Começemos!',
                 'Será que você conseguirá vencer? Não é mais brincadeira.'],
                ['A primeira batalha terminou, mas ainda tem mais pela frente.',
                 'Uma batalha completamente diferente espera-o...Mas o que aprendeu antes também será usado.',
                 'O segundo obstáculo está aqui. Prepare-se.',
                 'Sem mais delongas. Vamos.'],
                ['Quê? Falhou um dos desafios anteriores? Talvez este campo de batalha não seja para você.',
                 'Esqueca os fracassos e pense em como transformá-los em oportunidades.',
                 'Melhor revisar os seus erros antes de prosseguir.',
                 'Ah, ainda não desistiu? Veremos por quanto tempo aguenta...'],
                ['Está aqui...A "última" batalha...',
                 'Não passamos por todos aqueles obstáculos para cair em frente ao final.',
                 'Sem mais delongas...Pela última vez, vamos!',
                 'Hora de reivindicar a nossa vitória merecida.',
                 'Sem pensamentos. Mente vazia.'],
                ['Esperava não ter que vir aqui...']]
    end
    def self.evaluate(grade)
      return  case grade.round
              when 0..4
                [
                  "...Tem um longo caminho pela frente."
                ].sample
              when 3..6
                [
                  "Precisará esforçar-se ainda mais!"
                ].sample
              when 7..9
                [
                  "Está melhorando, mas ainda está longe de ser bom."
                ].sample
              when 10..12
                [
                  "Boa! Agora tente ganhar mais #{rand(1..8)} na próxima vez."
                ].sample
              when 13..14
                [
                  "Bem acima da média. Talvez você seja capaz de dispensar."
                ].sample
              when 15..17
                [
                  "Incrível! Porquê não tenta alcançar uma nota ainda melhor? Você é capaz!"
                ].sample
              when 18..19
                [
                  "Gostei! Mandou muito bem mesmo! E agora, consegue ver rolar um 20?"
                ].sample
              when 20
                [
                  "Perfeito! Simplesmente perfeito! Você arrasou nessa!"
                ].sample
              end
    end
    
  end


end