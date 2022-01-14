# Modelo de rede neural artificial:transferência de calor em colunas de bolhas

<div style="text-align: justify;">

## INTRODUÇÃO
É apresentado o desenvolvimento de um modelo baseado em rede neural
artificial (RNA) para prever o coeficiente de transferência de calor em uma coluna
de bolhas (Verma e Srivastava 2003). Não existe uma correlação única que
possa ajustar o coeficiente de transferência de calor em uma coluna de bolhas
estudada por vários pesquisadores. Um modelo baseado em RNA pode ser
usado nessas condições. A primeira etapa no desenvolvimento do modelo
baseado em RNA é identificar a entrada no modelo.
  
<div style="text-align: justify;">

## SELEÇÃO DE ENTRADAS

Considera-se que a transferência de calor é independente do diâmetro da coluna
(Fair et al. 1962; Kast 1962; Nishikawa et al. 1977). Kolbel et al. (1958) utilizaram
placa de peneira, bico único e bico sinterizado e não observaram efeito do tipo
aspersor no coeficiente de transferência de calor. Os estudos de transferência
de massa em colunas de bolhas mostram sua dependência do diâmetro da
coluna (Patil e Sharma 1983) e do projeto de aspersão (Rai 1997). Os estudos
de transferência de calor indicaram sua dependência da retenção de gás (Joshi
et al. 1980; Verma 1989). A velocidade de circulação do líquido depende da
retenção de gás e contribui para a transferência de calor por convecção. O efeito
do projeto de aspersão na retenção de gás no 'regime de fluxo borbulhante' é
conhecido (Reilly et al. 1986). O processo de transferência depende da
hidrodinâmica, que depende do comportamento da bolha nas colunas. A
hidrodinâmica varia na direção axial.
Portanto, a altura expandida do leito pode ser tomada como entrada do modelo.
Indica indiretamente a altura estática do leito e a retenção de gás. As variáveis
selecionadas como entrada do modelo são velocidade superficial do gás,
propriedades do fluido, projeto de aspersor, retenção de gás e altura do leito
estático. O design do aspersor pode ser descrito pelo menos dois parâmetros, o
número de bicos e o diâmetro do furo.
  
</div>

## OBTENÇÃO DE DADOS EXPERIMENTAIS
Os modelos baseados em ANN requerem um grande conjunto de dados para
treiná-los. Embora existam vários estudos experimentais, apenas alguns deles
têm todos os dados necessários como entrada do modelo (Tabela 1). Os dados
de Fair et al. (1962), Hart (1976), Hikita et al. (1981), Lewis et al. (1982) e Verma
(1989) relataram todos os dados disponíveis necessários como entrada na RNA.
Todos os dados sobre o coeficiente de transferência de calor em função da
velocidade superficial não puderam ser descritos por uma única correlação. Os
parâmetros geométricos e as condições operacionais dos estudos de
transferência de calor relatados na literatura são apresentados na Tabela 1.

![image](https://user-images.githubusercontent.com/64149081/149550226-9b2ba886-4053-41a7-9b74-272ee7a7bb42.png)

## RESULTADOS

Empregou-se uma rede neural feedforward de três camadas para modelar o
processo, ou seja, cada camada se conecta à seguinte, mas não há como voltar
das “informações”, fazendo com que todas as conexões tenham a mesma
direção, a partir da entrada camada em direção à camada de saída. A figura 1
mostra o diagrama da RNA com as variáveis consideradas. A única suposição
deste modelo de RNA proposto é que todos os dados coletados representam o
sistema em estudo.

![image](https://user-images.githubusercontent.com/64149081/149550471-415ddc80-12b5-421f-b7e4-10a75035acf5.png)

As variáveis de entrada são categóricas ou quantitativas categóricas, sendo
representadas por matrizes zero unidimensionais com o valor de composição do
componente diferente de zero. Como resultado, no total, 8 neurônios foram
inseridos no esquema da RNA com 7 entradas e 1 saída.
Para o ajuste catalítico dos dados, foi utilizado o pacote neuralnet - versão 1.33
disponível no ambiente de software R. Treinar uma RNA é estimar
os pesos w correspondentes às conexões entre dois neurônios de camadas
consecutivas, o que analogamente se refere a uma sinapse - um fenômeno no
qual as informações passam de um neurônio para outro. Para isso, um conjunto
de dados grande o suficiente é comparado à previsão da RNA. Este
procedimento de treinamento é interrompido quando todas as derivadas parciais
da função de erro em relação aos pesos (∂E/∂w) são menores que uma
determinada tolerância, por exemplo, 0,01. A expressão para a função de erro
empregada foi a soma dos erros quadráticos entre os valores observados e os
previstos pela RNA.
Os dados foram pré-processados por meio da normalização min-max, que variou
seus valores entre 0 e 1, a fim de evitar a influência de uma variável na previsão
do modelo devido à sua ordem de magnitude. Além disso, eles foram divididos
aleatoriamente em dois ubsets como mstrado na figura 2:
 - 80% para o conjunto de treinamento, que foi usado para estimar os pesos da
RNA; e
 - 20% para o conjunto de teste, usado apenas para verificar o desempenho da
RNA.

![image](https://user-images.githubusercontent.com/64149081/149550809-59071b75-2ca9-4152-b4cf-83f89d17ec08.png)

Para determinar o número de neurônios na camada oculta, os dados foram
particionados 10 vezes (k = 10) em diferentes conjuntos de treinamento e teste
para cada valor de NH considerado. A Fig. 3a ilustra o gráfico do erro quadrático
médio para o conjunto de testes em função do NH como resultado da aplicação
da técnica de validação cruzada k-fold. Como observado, o valor mínimo de MSE
ocorre em NH = 4 e, em seguida, começa a subir e oscilar, indicando uma
possível adaptação excessiva. Portanto, 4 neurônios foram escolhidos para
compor a camada oculta da RNA, sem perda de qualidade no desempenho da
representação do sistema, como será visto nos gráficos de previsão. Observe
também que o valor MSE para o conjunto de treinamento (Fig. 3b) sempre tende
a diminuir com a adição de mais neurônios - conseqüentemente mais parâmetros
no modelo, levando a uma superestimação do modelo.

![image](https://user-images.githubusercontent.com/64149081/149550926-d055885e-c29c-4b4b-a377-d2d208c7eb06.png)

O processo de treinamento para estimar os pesos da RNA exigiu 1911 etapas
para convergir, atingindo um erro de 0,033984. O gráfico de previsão do
coeficiente de troca térmica por convecção para o conjunto de treinamento é
ilustrado na Fig. 4a. O valor de R² foi de 0,987, indicando um excelente ajuste do
modelo de RNA aos dados desse grupo. Seu erro quadrático médio (MSE) entre
o valor observado e o previsto foi de 0,000436. Os valores satisfatórios dessas
métricas – R² e MSE - podem ser explicados pelo fato de o conjunto de
treinamento conter a maioria dos dados coletados - 80% de todo o conjunto de
dados - e esses dados foram usados para estimar os pesos da RNA.

![image](https://user-images.githubusercontent.com/64149081/149551034-7b2fb322-9ff8-4dbf-a569-8d0f4e3d0148.png)

Como pode ser visto na Fig. 5a, para validar o modelo de RNA, foi utilizado o
conjunto de testes, obtendo-se um R² de 0,983 e um MSE de 0,00813 - um pouco
pior que os anteriores - que mostram uma capacidade de previsibilidade
plausível da rede para a rede. dados que não foram usados para estimar seus
pesos.

![image](https://user-images.githubusercontent.com/64149081/149551139-dd1920ea-ec94-4288-bc40-6166ba029783.png)

## REFERENCIAS

 - Fair, J.R., Lambright, A.J., and Andersen, J.W. 1962. Heat transfer and gas
holdup in a sparged gas contactors. Ind. Eng. Chem. Process Des. Dev. 1(1):
33–36.
 - Hart, W.F. 1976. Heat transfer in bubble-agitated systems: A general correlation.
Ind.Eng. Chem. Process Des. Dev. 15(1): 109–114.
 - Hikita, H., Asai, S., Kikukawa, H., Zaike, T., and Ohue, M. 1981. Heat transfer
coefficientin bubble columns.Ind. Eng. Chem. Process Des. Dev. 20: 540–545.
 - Joshi, J.B., Sharma, M.M., Shah, Y.T., Singh, C.P.P., Ally, M., and Klinzing, G.E. 1980. Heat transfer in multiphase contactors. Chem. Eng. Commun. 6: 157–271.
 -  Kast, W. 1962. Analyse des wärmeübergangs in blasensäulen. Int. J. Heat Mass
Tranfer. 5(3–4): 329–336.
 - Kolbel, H., Siemes, W., Maas, R., and Muller, K. 1958. Warmeubergang an
Blasensaulen. Chemie. Ing. Techn. 20(6): 400–404. English translation: Heat
transfer in bubble columns. Retrieved from
www.fischertropsch.org/DOE/DOE_reports/.../de89012412_toc.htm
 - Lewis, D.A., Field, R.W., Xavier, A.M., and Edwards, D. 1982. Heat transfer in
bubble columns. Trans. Inst. Chem. Eng. 60: 40–47.
 - Nishikawa, M., Kato, H., and Hashimoto, K. 1977. Heat transfer in aerated tower
filled with non-Newtonian liquids. Ind. Eng. Chem. Process Des. Dev. 16(1): 133–137.
 - Patil, V.K., and Sharma, M.M. 1983. Solid-liquid mass transfer coefficient in
bubble columns up to 1 m diameter. Chem. Eng. Res. Des. 61: 23–61.
 - Rai, S. 1997. Studies on Mass Transfer with Immersed Surface in Bubble
Columns Using Electrochemical Technique. PhD dissertation, Institute of
Technology, Banaras Hindu University, Varanasi, India.
 - Reilly, I.G., Scott, D.S., Bruijn, T.De., Jain, A., and Piskorz, J. 1986. A correlation
for gas holdup in turbulent coalescing bubble columns. Can. J. Chem. Eng. 64(5): 705–717.
 - Verma, A.K. 1989. Heat transfer mechanism in bubble columns. Chem. Eng. J. 42: 205–208.
 - Verma, A.K., and Srivastava, A. 2003. ANN based model for heat transfer from
immersed tubes in a bubble column: Effects of immersed surface and sparger
geometry. In Proceedings of Fourth National Seminar on Thermal Systems,
February 22–23, Varanasi, India: Institute of Technology, Banaras Hindu
University.


