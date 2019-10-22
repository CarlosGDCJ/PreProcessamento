# PreProcessamento
Esse repositório contém as técnicas de pré processamento de dados que foram utilizadas na base de dados de explosões 
solares

## Para executar
* Execute os scripts de criação no PostgreSQL
* Importe os arquivos .csv para prencher as tabelas (Windows: importação pode apresentar problemas se o .csv ter mais de 2GB)
* Execute os scripts aqui do repositório e acesse as tabelas criadas por eles

## Scripts
### preProc1
#### **funcao.sql** (nome temporário)
Contém as functions responsáveis por converter a tabela *solarflare_sharp_720s_BDunificado* no formato desejado. 
    
* preprocessa('*nome da tabela*')
    
    Entrada: Tabela que contém pelo menos os seguintes atributos: *t_rec, xray1 , xray2 , xray3 , xray4 , xray5 , xray6 , xray7 , xray8 , xray9 , xray10 , xray11, xray12, r_value, usflux*. Todos no formato TEXT.

    Cria a tabela **UnifTeste** e preenche ela com os valores de tempo com granularidade de **minutos** insere também o valor de **raio x** medido nesse instante, e a **média, mínimo e máximo para os valores de usflux e r_value**. O nome da tabela passada como parâmetro deve ser colocado entre aspas simples.
    
### preProc2
#### **criaTabelaTeste.sql**
Contém as functions responsáveis por converter a tabela *solarflare_sharp_720s_BDunificado* no formato desejado, gerando a tabela Teste. 
    
* preProcessaRA('*nome da tabela*')
    
    Entrada: Tabela que contém pelo menos os seguintes atributos: *t_rec, xray1 , xray2 , xray3 , xray4 , xray5 , xray6 , xray7 , xray8 , xray9 , xray10 , xray11, xray12, r_value, usflux*. Todos no formato TEXT.

    Cria a tabela **Teste** e preenche ela com os valores de tempo com granularidade de **minutos** insere também o valor de **raio x** medido nesse instante, e a **noaa_ar, usflux e r_value**. O nome da tabela passada como parâmetro deve ser colocado entre aspas simples.

#### **criaColunasRegioesAtivas.sql**
Contém as functions responsáveis por adicionar colunas de rvalue e usflux à tabela *Teste* para cada uma das regiões ativas noaa_ar e retirar as colunas de noaa_ar, rvalue(geral) e usflux(geral).
    
* criaColunasRegioesAtivas('*nome da tabela*')    
    
    Entrada: Tabela que contém pelo menos os seguintes atributos: *t_rec, rx, noaa_ar, r_value, usflux*. Todos no formato TEXT.
    
    Atualiza a tabela passado como parâmetro, adicionando colunas de usflux e rvalue para cada uma das diferentes regiões ativas (noaa_ar) contidas na tabela. Além disso, retira as colunas de noaa_ar, rvalue(geral) e usflux(geral). O nome da tabela passada como parâmetro deve ser colocado entre aspas simples.

### Otimizacao
Essa pasta contém os scripts que, se tudo der certo, rodarão na base toda em tempo aceitável
#### funcmin.sql
Mesma abordagem do funcao.sql, mas utiliza índice e menos SQL dinâmico. A *function* preprocessa() agora não recebe argumento nenhum. Quando executada vai pegar a tabela de nome **unifmin** e deixar no formato desejado.
#### funcminDel.sql
Mesma abordagem do funcmin.sql, mas deleta as entradas da tabela original depois de serem utilizadas. **Altera a tabela que é passada**
