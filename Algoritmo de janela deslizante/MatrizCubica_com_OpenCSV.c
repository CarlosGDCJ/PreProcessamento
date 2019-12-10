#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

#define CHARLINHA 900
#define ATRIBSIZE 100


typedef struct{
	char *palavra;
} String;

char vetPathFile[2000];
char vetPathFileSlided[2000];
char vetCmd[2000];


int slidingWindowMultipleColumns(String **solarDataSet, int futureWindowSize, int jump, char *filename, float tupleQty, int presentWindowSize, int step, int totalArrayLength, int numColumn) {
		FILE *fp;
		// Define o tamanho total dos attr. em uma janela como sendo 100(tamanho de um unico attr) * o tamanho da janela(quantidade de objetos) * número de attr por objeto(número de colunas - 1(t_rec)) 
		int atribSize = 100*(presentWindowSize*(numColumn-1));
		char *atribName;
		if ((atribName = malloc(100*atribSize * sizeof(char))) == NULL) {
			fprintf(stderr, "Estamos alocando memoria d+ no atribName");
		}
		char *atrib;
		if ((atrib = malloc(100 * sizeof(char))) == NULL) {
			fprintf(stderr, "Estamos alocando memoria d+ no atrib");
		}
		char *strSave;
		if ((strSave = malloc(100*(((6*(presentWindowSize*(numColumn-1))) + ((20*(numColumn - 1)) * presentWindowSize+2)*tupleQty)*sizeof(char)))) == NULL) {
			fprintf(stderr, "Estamos alocando memoria d+ no strSave");
		}
		
		long int i, j, col, maxi;
		int futureWindowIndex;
		
		char solarFlare[] = { 'A','B','C','M','X' };
		printf("%c, %c\n",solarFlare[0],solarFlare[1]);
		unsigned int cont = 0;
		int count;
		sprintf(atrib, ""); // Seta a string como ""
		sprintf(strSave, ""); // Seta a string como ""
		sprintf(atribName, ""); // Seta a string como ""
		printf("futureWindow = %d\njump = %d\ntupleQty = %f\npresentWindowSize = %d\nstep = %d\ntotalArrayLength = %d\nnumColumn = %d\n", futureWindowSize, jump, tupleQty, presentWindowSize, step, totalArrayLength,numColumn);

		strcat(atribName,"t_rec,"); // Adiciona t_rec a string atribName
		for (i = 0; i < presentWindowSize*(numColumn-2); i++) {
			sprintf(atrib, "at%d,", i);	// Substitui a string atrib com ati
			strcat(atribName, atrib); // Adiciona a string atribName, at0 ate atN, em que N e o numero de atributos(-t_rec e -classe) * numero de objetos
		}
		strcat(atribName, "class"); // Adiciona class a string atribName
		if((fp = fopen(filename, "w+")) == NULL){
			fprintf(stderr, "Nao foi possivel abrir o arquivo de saida slidingWindowMultipleColumns");
			return -1;
		}
		strcat(strSave, atribName); // Adiciona a string atribName a string strSave
		printf("%s\n",strSave); // Printa a string strSave, que agora contém os atributos t_rec, at0 até atN, e classe

		cont = strlen(strSave); // cont possui o comprimento da string com todos os nomes de attr
		printf("cont = %d\n",cont); // Printa o tamanho da string strSave
		int k;

		*(strSave + cont) = '\n'; // Adiciona \n ao final da string strSave 
		cont++;	// Avança o contador em 1
		
		for (i = 1; i < tupleQty; i++) // Para cada tupla restante - 1, faça
		{
			
			strcpy(atribName, solarDataSet[i*step][0].palavra);
			k = 0;
			
			while(k < strlen(atribName)){
				*(strSave + cont) = atribName[k];
				k++;
				cont++;
			}
			*(strSave + cont) = ',';
			cont++;	
				
			for(col = 1; col < numColumn-1; col++){
				
				
				for (j = 0; j < presentWindowSize; j++)
					{
						strcpy(atribName, solarDataSet[i*step + j][col].palavra);
						
						k = 0;

						while(k < strlen(atribName)){
							*(strSave + cont) = atribName[k];
							k++;
							cont++;
						}
						*(strSave + cont) = ',';
						cont++;	
				}		
			}
			
			futureWindowIndex = i * step + presentWindowSize + jump;

			int solarClass;
			
			if(solarDataSet[futureWindowIndex][numColumn-1].palavra[0]=='A') 
				solarClass = 0;
			else if(solarDataSet[futureWindowIndex][numColumn-1].palavra[0]=='B') 
				solarClass = 1;
			else if(solarDataSet[futureWindowIndex][numColumn-1].palavra[0]=='C') 
				solarClass = 2;
			else if(solarDataSet[futureWindowIndex][numColumn-1].palavra[0]=='M') 
				solarClass = 3;
			else if(solarDataSet[futureWindowIndex][numColumn-1].palavra[0]=='X') 
				solarClass = 4;
			
			maxi = solarClass;
			
			for (count = futureWindowIndex; (count < futureWindowIndex + futureWindowSize)&&(count < totalArrayLength - 1); count++) {
				if(solarDataSet[count][numColumn-1].palavra[0]=='A')
					solarClass = 0;
				else if(solarDataSet[count][numColumn-1].palavra[0]=='B') 
					solarClass = 1;
				else if(solarDataSet[count][numColumn-1].palavra[0]=='C') 
					solarClass = 2;
				else if(solarDataSet[count][numColumn-1].palavra[0]=='M') 
					solarClass = 3;
				else if(solarDataSet[count][numColumn-1].palavra[0]=='X') 
					solarClass = 4;
				
				maxi =  (maxi > solarClass?maxi:solarClass);
			}
			
			sprintf(atribName, "%c\n", solarFlare[maxi]);
			
			
			for (k = 0; k < 2; k++, cont++) {
				*(strSave + cont) = atribName[k];
			}
		*(strSave + cont) = '\0';
		}

		fprintf(fp, "%s", strSave);
		free(strSave);
		fclose(fp);
		return 0;
	}
	
int retFileNumLines(){
	int contNumLines, indexWord = 0;
	char line[1500];
	
	
	FILE *in;
	if((in = fopen(vetPathFile, "r")) == NULL){
			fprintf(stderr, "Nao foi possivel abrir o arquivo de entrada em retFileNumLines");
			return -1;
		}
	while(fgets(line, sizeof line, in) != NULL){
		while(line[indexWord]=='\n')  
			indexWord++;
		indexWord = 0;
		contNumLines++;
	}
	fclose(in);
	return contNumLines;
}

int main(){
	
	String **m; // Matriz de string
	long int linhas, colunas, numPalavras = 0, totalLinhas;
	int flagColunas = 0;
	FILE *arquivo;
    
    char buff[512];
    char str[512];
    char line[1500];
    char word[100];
    int indexWord = 0, indexLine = 0, numColunas = 0, i, j;
    
    int presentWindow = 120, jump = 0, futureWindow = 240;
    int windowSize = presentWindow + jump  + futureWindow;
    

	strcpy(vetPathFile,"/home/carlos/Downloads/sergio2014.csv");

	strcpy(vetPathFileSlided,"/home/carlos/Downloads/sergio2014slided.csv");


    totalLinhas = retFileNumLines();
	
	m = malloc(sizeof(String*) * totalLinhas);
	
	arquivo = fopen(vetPathFile, "r");
	if((arquivo = fopen(vetPathFile, "r")) == NULL){
			fprintf(stderr, "Nao foi possivel abrir o arquivo de entrada em main");
			return EXIT_FAILURE;
		}
        
    linhas = 0;    

	while(fgets(line, sizeof line, arquivo) != NULL) // Enquanto nao chegar no fim, retorna a linha na variavel line
    {	
	    
	    	if(flagColunas==0){ // Conta o numero de colunas uma vez
	    		if(strlen(line)>0){
					while(line[indexLine] != '\n'){
						if(line[indexLine] == ',')
							numColunas++;
						indexLine++;
					}
					numColunas++;
				}
			flagColunas = 1;
			}
		
		
		*(m+linhas) = malloc(sizeof(String)*numColunas); // Para cada linha, aloca numColunas strings
		
		indexWord = 0;
		indexLine = 0;
		i = 0;
		colunas = 0;
		
		if(numColunas > 0){ // Se existir alguma coluna, analisamos a linha caracter por caracter
			while(line[indexLine] != '\n'){ // Enquanto nao chegar no final da linha (caracter nao for \n)
				if(line[indexLine] != ','){ // Se nao for uma virgula, o caractere eh parte do valor de um atributo (o csv recebido nao pode ter header, entao nao pode ser nome dos attrs)
					word[indexWord] = line[indexLine]; // Coloca a parte encontrada em word
					indexWord++; // Avança o indice de word, pra quando colocar o proximo caractere, colocar na frente
				}
				if((line[indexLine] == ',')||(line[indexLine+1] == '\n')){ // Se colocou todas as partes do valor em word (leu o valor ate a virgula ou ate o ultimo caractere antes do \n)
					word[indexWord]='\0'; // Adiciona um \0 no final de word
					indexWord = 0; // Zera o indice de word
					m[linhas][colunas].palavra = malloc(sizeof(char)*strlen(word)); // Aloca espaco do tamanho de word na matriz
					strcpy(m[linhas][colunas].palavra,word); // Copia word para o novo espaco alocado
					colunas++; // Acabou de teminar de ler um valor, o proximo vai ser colocado na coluna seguinte
				}
				indexLine++; // Acabou de ler um caractere, vai pro proximo
			}		
		}
		
       linhas++; // Chegou no \n, vai pra proxima linha
    }

	// Neste ponto, o dataset esta todo carregado em m
	
	totalLinhas = linhas;       

	float tupleQty = ceil((totalLinhas - windowSize + 1) / (float)1); // Define a quantidade de tuplas como o total de linhas - o tamanho da janela + 1(step)
	
	printf("\nt_rec[0] = %s\n",m[0][1].palavra);
	printf("t_rec[1] = %s\n",m[1][1].palavra);
	printf("t_rec[2] = %s\n",m[2][1].palavra);


	int status;
	status = slidingWindowMultipleColumns(m, futureWindow, jump, vetPathFileSlided, tupleQty, presentWindow, 1, totalLinhas, numColunas);
		
	free(m);
	fclose(arquivo);
	
	

}

