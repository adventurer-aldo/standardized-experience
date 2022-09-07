module Misc

  class Text
    def self.cheer
      [['Este é apenas o começo...Tente ver o seu potencial.',
        'Teste as suas habilidades.',
        'O nível mais básicos dos básicos...Como você se sairá frente a este desafio?',
        'Sem mais delongas. Vamos.'],
       ['A luta está para começar.',
        'O primeiro obstáculo encontra-se a frente. Siga-o!',
        'A hora do treino acabou. Começemos!',
        'Está preparado?',
        'Se prepare.',
        'O início decide o fim.',
        'Os primeiros passos são importantes.',
        'Será leve para quem estiver preparado.',
        'A luta começou.',
        'Não vá se acovardar no começo.',
        'Espero que esteja preparado.',
        'Nervoso? Ótimo.',
        'Será que você conseguirá vencer? Não é mais brincadeira.'],
       ['A primeira batalha terminou, mas ainda tem mais pela frente.',
        'Uma batalha completamente diferente espera-o...Mas o que aprendeu antes também será usado.',
        'O segundo obstáculo está aqui. Prepare-se.',
        'Sem mais delongas. Vamos.'],
       ['Para alguns, este é o momento para se preparar.',
        'Uma segunda chance para aqueles que perderam a sua primeira.',
        'Esqueça os fracassos e pense em como transformá-los em oportunidades.',
        'Melhor revisar os seus erros antes de prosseguir.',
        'Ah, ainda não desistiu? Veremos por quanto tempo aguenta...'],
       ['Mostre o que sabe.',
        'Prove que o seu conhecimento não é uma farsa.',
        'Não será um teste qualquer. Não baixe sua guarda.'],
       ['Está aqui...A "última" batalha...',
        'Não passamos por todos aqueles obstáculos para cair em frente ao final.',
        'Sem mais delongas...Pela última vez, vamos!',
        'Não percebi porquê você não tentou dispensar?',
        'Hora de reivindicar a nossa vitória merecida.',
        'Sem pensamentos. Mente vazia.',
        'Exame nada. Isto é apenas mais outro obstáculo.'],
       ['Esperava não ter que vir aqui...',
        'Ser confiante demais deu nisto.',
        'Ninguem falou que isso seria fácil.',
        'Ora, ora. Olha quem está aqui...',
        'Sabia que mais cedo ou tarde estaria aqui. Vacilou.',
        'Segundas chances não implicam mais leniência no julgamento, apenas mais severidade.',
        'Nisso que dá ficar relaxado demais.',
        'Enfim.'
       ],
       ['A batalha acabou...',
        'Precisa de descansar.',
        'Finalmente terminou...',
        'Uma pausa é necessária. E bem vinda.',
        'Tome um copo de água.',
        'O que achou dos seus esforços?',
        'Tudo que começa tem um fim.',
        'Para a próxima, dominarás.',
        'Você ganhou experiência.',
        'Adiante para o próximo nível.',
        'Você está apenas começando.',
        'Bora mais uma vez.',
        'E agora? O que você fará?']]
    end
    def self.evaluate(grade)
      return  case grade.round
              when 0..4
                [
                  '...Tem um longo caminho pela frente.',
                  'Talvez você deva desistir disto.',
                  'Não seria melhor escolher outro curso?',
                  'Melhor nem falar nada.',
                  'Sem comentários.',
                  'Tá de brincadeira? Os resultados não brincam...',
                  'Tente de novo. Bora.',
                  'Precisa praticar mais para não ver essa miséria!',
                  'Que bom que estava apenas testando, né? Você estava estando, certo?',
                  'Outlook, not so good.',
                  'Vamos consertar isto.',
                  ''
                ].sample
              when 3..6
                [
                  'Precisará esforçar-se ainda mais!',
                  'Não é o pior que você já fez. Essa é uma vitória por mim!',
                  'Sério isto?',
                  'Se você continuar assim, vou passar vergonha.',
                  'Treine. Treine. Treine. Treine!',
                  'TENTA MAIS UMA VEZ!',
                  'E você pensa que poderá passar assim?',
                  'Alguma pergunta te surpreendeu?',
                  'Você não está no zero. Está nos primeiros passos.',
                  'Vamos com espírito de luta!',
                  ''
                ].sample
              when 7..9
                [
                  'Está melhorando, mas ainda está longe de ser bom.',
                  'Bem, esta é a nota média que muitos conseguiriam neste teste. Se muitos fossem apenas 10 pessoas que conheço.',
                  'Melhor revisar antes de tentar de novo.',
                  'Estudou?',
                  'Não vou pegar leve com você, hein!',
                  'Nunca dispensará se continuar assim.',
                  'E você pensa que pode dispensar assim...',
                  ''
                ].sample
              when 10..12
                [
                  "Boa! Agora tente ganhar mais #{rand(1..8)} valores na próxima vez.",
                  'Gostei!',
                  'Na verdade, esse foi um pouco fácil.',
                  'Peguei leve. Não fique feliz.',
                  'Metade da meta. Você está chegando lá!',
                  'Boa nota. Dá pra proceder com a vida.',
                  'Melhor celebrar se você esteve falhando ultimamente.',
                  'Não durma ainda. Ainda tem mais pela frente.',
                  'Comemore, mais só por 5 minutos.',
                  ''
                ].sample
              when 13..14
                [
                  'Bem acima da média. Talvez você seja capaz de dispensar.',
                  'Está me mostrando resultados!',
                  'Estou ficando orgulhoso, mas não baixe sua guarda!',
                  'Treine! Ainda não chegou no topo.',
                  'Que é isso? Você tá melhorando!',
                  ''
                ].sample
              when 15..17
                [
                  'Incrível! Porquê não tenta alcançar uma nota ainda melhor? Você é capaz!',
                  'É ISSO AÍ!',
                  'Você tem nota para dispensar aqui.',
                  'Acho que você não precisa fazer mais testes.',
                  ''
                ].sample
              when 18..19
                [
                  'Gostei! Mandou muito bem mesmo! E agora, consegue ver rolar um 20?',
                  'Eita! Quando que você estudou tanto assim?',
                  'Melhor arregaçar as mangas, que da próxima vai ser mais difícil.',
                  'Finalmente começou a levar isso a sério.',
                  ''
                ].sample
              when 20
                [
                  'Perfeito! Simplesmente perfeito! Você arrasou nessa!',
                  'Tamanha sabedoria. Gostei!',
                  '...Estou sonhando, não estou?',
                  'Bom trabalho.',
                  'Melhor acordar que cê tá sonhando.',
                  'Por essa eu não esperava...',
                  'Difícil acreditar que você já teve abaixo de 10 antes.',
                  'Por isso que eu confio em você.',
                  ''
                ].sample
              end
    end
    
  end


end
