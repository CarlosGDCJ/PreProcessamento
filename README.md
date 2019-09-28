# PreProcessamento
Esse repositório contém as técnicas de pré processamento de dados que foram utilizadas na base de dados de explosões 
solares

## Para executar
* Execute os scripts de criação no PostgreSQL
* Importe os arquivos .csv para prencher as tabelas (Windows: importação pode apresentar problemas se o .csv ter mais de 2GB)
* Execute os scripts aqui do repositório e acesse as tabelas criadas por eles

## Scripts
#### **função.sql** (nome temporário)
Contém as functions responsáveis por converter a tabela *solarflare_sharp_720s_BDunificado* no formato desejado. 
    
* preprocessa('*nome da tabela*')
    
    Entrada: Tabela que contém pelo menos os seguintes atributos: *t_rec, xray1 , xray2 , xray3 , xray4 , xray5 , xray6 , xray7 , xray8 , xray9 , xray10 , xray11, xray12, r_value, usflux*. Todos no formato TEXT.

    Cria a tabela **UnifTeste** e preenche ela com os valores de tempo com granularidade de **minutos** insere também o valor de **raio x** medido nesse instante, e a **média, mínimo e máximo para os valores de usflux e r_value**. O nome da tabela passada como parâmetro deve ser colocado entre aspas simples.
    
    


