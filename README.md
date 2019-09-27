# PreProcessamento
Esse repositório contém as técnicas de pré processamento de dados que foram utilizadas na base de dados de explosões 
solares

## Para executar
* Execute os scripts de criação no PostgreSQL
* Importe os arquivos .csv para prencher as tabelas (Windows: .csv deve ter menos de 2GB)
* Execute os scripts aqui do repositório

## Scripts
#### **função.sql** (nome temporário)
Contém as functions responsáveis por converter a tabela *solarflare_sharp_720s_BDunificado* no formato desejado. 
    
* preprocessa(*nome da tabela*)

    Por enquanto recebe como entrada o nome da tabela que será convertida, cria uma tabela de testes e insere uma entrada *t_rec* qualquer.


