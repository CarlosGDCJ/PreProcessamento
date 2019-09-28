# PreProcessamento
Esse repositório contém as técnicas de pré processamento de dados que foram utilizadas na base de dados de explosões 
solares

## Para executar
* Execute os scripts de criação no PostgreSQL
* Importe os arquivos .csv para prencher as tabelas (Windows: .csv deve ter menos de 2GB)
* Execute os scripts aqui do repositório e acesse as tabelas criadas por eles

## Scripts
#### **função.sql** (nome temporário)
Contém as functions responsáveis por converter a tabela *solarflare_sharp_720s_BDunificado* no formato desejado. 
    
* preprocessa('*nome da tabela*')

    Por enquanto recebe como entrada o nome da tabela que será convertida, cria a tabela **UnifTeste** e preenche ela com os valores de tempo com granularidade de **minutos** insere também o valor de **raio x** medido nesse instante. O nome da tabela deve ser colocado entre aspas simples.
    
    


