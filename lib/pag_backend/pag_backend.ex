defmodule PagBackend do
  @moduledoc """

  Versão em Elixir do desafio de backend da pag! S.A para desenvolvedores.

  > Para visualizar o codigo fonte das funcoes, clique no icone </> no canto superior direito da assinatura da funcao. 
  
  ## Consideracoes

  ### Sem Phoenix?

  Phoenix é o framework mais famoso de Elixir para web, ele é construido encima das libs Cowboy 
  e Plug que sao usadas ostensivamente aqui. Porem ele traz uma bagagem para aplicacoes maiores com 
  conceitos de DDD e Channels e muitas outras coisas que nao seriam utilizadas. Entao optei por nao usa-lo.

  ### Pattern Matching, o que é isso?

  Eu estou a um bom tempo investindo em FP, e umas das features mais legais que eu gosto de usar  
  é o Pattern Matching. Entao se voce ver coisas como isso aqui, eu explico.

  #### Exemplos

      iex> [a, b, :ok] = [1, 2, :ok]
      [1, 2, :ok]
      iex> [a, b]
      [1, 2]

  Como visto, o lado direito se equipara ao lado esquerdo de todas maneiras, sendo assim as variaveis 
  a e b agora valem respectivamente 1 e 2 para a equivalencia ser alcançada.
  A vantagem desse tipo de abordagem é a possibilidade de asserção entre os lados, lançando uma exceção quando a equivalencia nao é alcançada, deixando o codigo mais seguro por crashar uma presunção errada de matching, 
  na minha opinião isso é algo muito poderoso.  
  Deixando bem claro que nao estou lecionando para ninguem, tenho certeza que gente mais capacitada que 
  inclusive pode me ensinar uma coisa ou duas pode estar lendo. Apenas explicitando as minhas preferencias para se entender melhor o estilo do meu codigo.

  ### Testes

  Os suites de testes apesar de pequenos cobrem um bocado. Só lembrando que a ausencia dos assertions é justamente devido ao pattern matching nas chamadas  
  das funcoes, causando uma certa redundancia pois se o PM falhar sera lançada uma exceção falhando assim o teste. 

  ### Estrutura

  Cada modulo da API tem a seguinte estrutura. Primeiro um `Plug` para receber a conexão, pode ser feito algum tratamento adicional e depois a conexao é enviada para 
  um `Plug.Router`.

  ### Decisões

  Minhas decisões sao baseadas em boas praticas que eu acredito. Entao pra expor um pouco oq eu penso eu posso dizer que eu favoreço coesão ao inves de acoplamento, expressividade ao invés de reusabilidade.
  
  ### Docker

  Elixir tem uma maneira bem unica e facil de fazer deploy com releases. Ainda pode dockerizar.
  """
end