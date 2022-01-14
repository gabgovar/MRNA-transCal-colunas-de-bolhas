#===============================================================================================#
#============================ALGORITMO DE REDES NEURAIS ARTIFICIAIS ============================#
#===============================================================================================#
#======================================GABRIEL GOMES VARGAS=====================================#
#===============================================================================================#
#===============================================================================================#

cat('\014') #LIMPA OS CONSOLE
graphics.off() #LIMPA O ESPAÇO DOS GRÁFICOS
rm(list = ls()) #LIMPA A WORKSPACE

#====================================== BIBLIOTECAS ============================================#

library(neuralnet)  # Neuralnet
library(plyr)       # Progress bar

#===============================================================================================#
#===============================================================================================#
#=======================SELEÇÃO DO NÚMERO DE NEURONIOS DA CAMADA OCULTA=========================#
#===============================================================================================#
#===============================================================================================#

#============================== FUNÇÃO DE VALIDAÇÃO CRUZADA=====================================#

crossvalidate <- function(data_,hidden_l=c(5))
{
  # @params
  
  
  # hidden_l      a numeric vector with number of neurons for each hidden layer
  #               default to 5.
  
  # Scaling the _data (min-max scaling)
  maxs <- apply(data_, 2, max) 
  mins <- apply(data_, 2, min)
  scaled <- as.data.frame(scale(data_, center = mins, scale = maxs - mins))
  
  # Initialize cv.error vector
  cv.error <- NULL
  
  # Number of train-test splits
  k <- 10
  
  # Cross validating
  for(j in 1:k)
  {
    # Train-test split
    index <- sample(1:nrow(scaled),round(0.90*nrow(scaled)))
    train.cv <- scaled[index,]
    test.cv <- scaled[-index,]
    
    # NN fitting
    nn <- neuralnet(f,data=train.cv,hidden=hidden_l,linear.output=T)
    
    # Predicting
    pr.nn <- compute(nn,test.cv[,1:7])
    
    # Scaling back the predicted results
    pr.nn <- pr.nn$net.result*(max(scaled$h)-min(scaled$h))+min(scaled$h)
    
    # Real results
    test.cv.r <- (test.cv$h)*(max(scaled$h)-min(scaled$h))+min(scaled$h)
    
    # Calculating MSE test error
    cv.error[j] <- sum((test.cv.r - pr.nn)^2)/nrow(test.cv)
  }
  
  # Return average MSE
  return(mean(cv.error))
}

#=================SELECIONANDO O NÚMERO DE NEURÔNIOS DA CAMADA OCULTA======================#

setwd('D:/R/trabalho') #ABRE O DIRETÓRIO DE TRABALHO

data_<-read.csv2("dados.csv",
                 header = TRUE) #LEITURA DOS DADOS

#=================INICIALIZANDO VETORES DE ERRO DE TESTE E TREINAMENTO======================#

test.error <- NULL
train.error <- NULL

#===================================ESCALONAMENTO DE nn=====================================#
 
maxs <- apply(data_, 2, max) 
mins <- apply(data_, 2, min)
scaled <- as.data.frame(scale(data_, center = mins, scale = maxs - mins))

n <- names(scaled)
f <- as.formula(paste("h ~", paste(n[!n %in% "h"], collapse = " + ")))
col<- ncol(7)

#==============================GERANDO BARRA DE PROGRESSO==================================#
 
pbar <- create_progress_bar('text')
pbar$init(7)

set.seed(100)

#==================TESTE E VALIDAÇÃO CRUZADA ( PODE DEMORAR UM POUCO)======================#
 
for(i in 1:7)
{
  # Fit the net and calculate training error (point estimate)
  nn <- neuralnet(formula=f,data=scaled,hidden=c(i),linear.output=TRUE)
  train.error[i] <- sum((as.data.frame(nn$net.result) - scaled$h)^2)/nrow(scaled)
  
  # Calculate test error through cross validation
  test.error[i] <- crossvalidate(data_,hidden_l=c(i))
  
  # Step bar
  pbar$step()
}

# Print out test and train error vectors
test.error
train.error

# Plot train error
plot(train.error,main='MSE vs hidden neurons',xlab="Hidden neurons",ylab='Train error MSE',type='l',col='green',lwd=2)
# Plot test error
plot(test.error, main='MSE vs hidden neurons',xlab="Hidden neurons",ylab='Test error MSE',ylim = c(0,0.03),type='l',col='purple',lwd=2)

# Number of neurons (index) that minimizes test/train error
which(min(test.error) == test.error)
which(min(train.error) == train.error)

#===============================================================================================#
#===============================================================================================#
#=================================INICIO DA REDE NEURAL=========================================#
#===============================================================================================#
#===============================================================================================#

setwd('D:/R/trabalho') #ABRE O DIRETÓRIO DE TRABALHO

dados<-read.csv2("dados.csv",
                 header = TRUE) #LEITURA DOS DADOS

str(dados)

col<-ncol(dados) #QUANTIDADE DE COLUNAS DA MATRIZ

dadosN<-dados #CRIANDO A VARIÁVEL dadosN


#==========================NORMALIZAÇÃO VALORS DE dados E ======================================# 
#===============================SALVANDO EM dadosN =============================================#


for (j in 1:col) { 
  dadosN[,j]<-(dados[,j]-min(dados[,j]))/(max(dados[,j])-min(dados[,j]))
}

#=========================PARTIÇÃO DE DADOS (80% TREINAMENTO - 20% TESTE)=======================#

set.seed(222) #PARA O FIXAR A QUANTIDADE DE DADOS RANDOMICOS 

ind<-sample(2,
            nrow(dadosN),
            replace = TRUE,
            prob = c(0.80,0.20)) # sample(subconjuntos, , cria dois vetores um com 80% e outro com 20% dos dados )

training<-dadosN[ind==1,] #SELEÇÃO DOS ELEMENTOS DE TREINAMENTO
testing<-dadosN[ind==2,] #SELEÇÃO DOS ELEMENTOS DE TESTE

#==============PLOT DOS VALORES de teste e treinamento dentro do conjunto dadosN ===============#

plot(dadosN$h)

plot(rownames(training),
     training$h,
     col=3) # rownames(training) coloca os dados em relação ao conjunto de dados da matriz dadosN (eixo y)

lines(rownames(testing),
      testing$h,
      col=2,
      type="p") #insere outro conjuntos dados no gráfico anterior, type="p" transforma linha em ponto

allvars<-colnames(dadosN)
predictorvars<-allvars[!allvars%in%"h"]

predictorvars<-paste(predictorvars,
                     collapse = "+")
form<-as.formula(paste("h~",
                       predictorvars,
                       collapse = "+"))

#REDE NEURAL

library(neuralnet) #chama a biblioteca de redes neurais

set.seed(333) #PARA O FIXAR A QUANTIDADE DE DADOS DA REDE NEURAL

# "!" negação, retirar dados ou di
#form => indica os imput e output (output => CO conver) (input => outros elementos)
#data => leitura dos dedos para treino ou teste
#hidden = > numero de neuronios da camada oculta (o numero de neuronios deve estar entre o numero de entradas e saidas)
#err.fct => erro da rede neural (sse = > soma dos erros quadrados) (ce => entropia cruzada)
#linear.output => (TRUE => REGRESSÃO) (FALSE = classificação)

n<-neuralnet(formula = form,
             data = training,
             hidden = 4,
             err.fct = "sse",
             linear.output = TRUE,
             lifesign = "full")

names(n)

n$model.list

n$net.result

n$result.matrix

plot(n,
     radius = 0.1,
     information = T)

#PREDIÇÃO

#USANDO O CONJUNTO DE TREINAMENTO

predictions.train<-compute(n,
                           training[,-ncol(training)])

#USANDO O CONJUNTO DE TESTE

predictions.test<-compute(n,
                          testing[,-ncol(testing)])

#USANDO TODO O CONJUNTO DE DADOS

prediction.all<-compute(n,
                        dadosN[,-ncol(dadosN)])

# CALCULO DO COEFICENTE DE DETERMINAÇÃO R² (TREINAMENTO)

SQtot.train<-sum((training$h - mean(training$h))^2)

SQres.train<-sum((training$h - predictions.train$net.result)^2)

R2.train<-1-SQres.train/SQtot.train

R2.train

# Resultados não escalados para o treinamento

predictions.train.unscaled<-predictions.train$net.result*(max(dados$h) - min(dados$h))+min(dados$h)

training.unscaled<-training$h*(max(dados$h)-min(dados$h))+min(dados$h)

MSE.train<-sum((training.unscaled-predictions.train.unscaled)^2)/nrow(training)

plot(training.unscaled,
     predictions.train.unscaled,
     main="Training Correlation",
     xlab = "Observed transfer coefficient",
     ylab = "predicted transfer coefficient",
     col="red")

#linha em 45°
abline(0,1,
       lty=2) 

R2.train.plot<-round(R2.train,
                     digits=3)

text(x=2,y=8, label=bquote("R²"==.(R2.train.plot)))

# CALCULO DO COEFICENTE DE DETERMINAÇÃO R² (TESTE)

SQtot.test<-sum((testing$h - mean(testing$h))^2)

SQres.test<-sum((testing$h - predictions.test$net.result)^2)

R2.test<-1-SQres.test/SQtot.test

R2.test

# Resultados não escalados para o treinamento

predictions.test.unscaled<-predictions.test$net.result*(max(dados$h) - min(dados$h))+min(dados$h)

testing.unscaled<-testing$h*(max(dados$h)-min(dados$h))+min(dados$h)

MSE.test<-sum((testing.unscaled-predictions.test.unscaled)^2)/nrow(testing)

plot(testing.unscaled,
     predictions.test.unscaled,
     main="Testing Correlation",
     xlab = "Observed transfer coefficient",
     ylab = "predicted transfer coefficient",
     col="Blue")

#linha em 45°
abline(0,1,
       lty=2) 

R2.test.plot<-round(R2.test,
                    digits=3)

text(x=2,y=8, label=bquote("R²"==.(R2.test.plot)))