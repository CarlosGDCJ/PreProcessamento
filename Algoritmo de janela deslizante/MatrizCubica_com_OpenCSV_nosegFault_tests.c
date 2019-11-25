#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include<string.h>

#define CHARLINHA 900
#define ATRIBSIZE 100


typedef struct{
	char *palavra;
} String;
char vetPathFile[2000];
char vetPathFileSlided[2000];
char vetCmd[2000];


void slidingWindowMultipleColumns(String **solarDataSet, int futureWindowSize, int jump, char *filename, float tupleQty, int presentWindowSize, int step, int totalArrayLength, int numColumn) {
		FILE *fp;
		int atribSize = 6*(presentWindowSize*(numColumn));
		char *strSave = (char*)malloc(((6*(presentWindowSize) + (20* presentWindowSize+2)))*(numColumn-1)*sizeof(char));
		if(strSave==NULL) printf("Falha de alocacao!!!");
		//char atribName[ATRIBSIZE];
		char *atribName = (char*)malloc(atribSize * sizeof(char));
		char *atrib = (char*)malloc(6 * sizeof(char));
		long int i, j, col, maxi;
		int futureWindowIndex;
		//char solarFlare[] = { 'N','N','Y','Y','Y' };//defines which class is solar flare or not. A, B, C, M, X
		char solarFlare[] = { 'A','B','C','M','X' };//defines which class is solar flare or not. A, B, C, M, X
		printf("%c, %c\n",solarFlare[0],solarFlare[1]);
		unsigned int cont = 0;
		int count;
		sprintf(atrib, "");
		sprintf(strSave, "");
		sprintf(atribName, "");
		printf("futureWindow = %d\njump = %d\ntupleQty = %f\npresentWindowSize = %d\nstep = %d\ntotalArrayLength = %d\nnumColumn = %d\n", futureWindowSize, jump, tupleQty, presentWindowSize, step, totalArrayLength,numColumn);

		//Se der problema MUDAR AQUI!!!!
		//for (i = 0; i < presentWindowSize*(numColumn-1); i++) {
		strcat(atribName,"t_rec,");
		for (i = 0; i < presentWindowSize*(numColumn-2); i++) {
			sprintf(atrib, "at%d,", i);
			strcat(atribName, atrib);
		}
		strcat(atribName, "class");
		fp = fopen(filename, "a+");
		strcat(strSave, atribName);
		printf("%s\n",strSave);
		//===============================
		cont = strlen(strSave);
		int k;

		*(strSave + cont) = '\n';
        fprintf(fp,"%s",strSave);
        fclose(fp);
		free(strSave);
		

		for (cont=0,i = 1; i < tupleQty; i++)
		{
			//Incluir um la�o-XXX para considerar todas as colunas da matriz com a base de dados contendo as s�ries de dados solares. ============================
			
			//Se der problema MUDAR AQUI TAMB�M!!!!
			strSave = (char*)malloc(((6*(presentWindowSize) + (20*presentWindowSize+2)))*(numColumn-1)*sizeof(char));
			if(strSave==NULL) {printf("\n!!!!!!!!!!!!!!!!Falha na alocacao: numero da tupla = %ld\n",i);}
            cont = 0;
            fp = fopen(filename, "a+");
			if(fp==NULL) {printf("\n!!!!!!!!!!!!!!!!Falha na abertura do arquivo: numero da tupla = %ld\n",i);}
            strcpy(atribName, solarDataSet[i*step][0].palavra);
			k = 0;
					
			//printf("%s\n",atribName);
			
			while(k < strlen(atribName)){
				*(strSave + cont) = atribName[k];
				k++;
				cont++;
			}
			*(strSave + cont) = ',';
			cont++;	
				
	
			//Se der problema MUDAR AQUI!!!!
			
			for(col = 1; col < numColumn-1; col++){
				
				
				for (j = 0; j < presentWindowSize; j++)
					{
						strcpy(atribName, solarDataSet[i*step + j][col].palavra);
						
						k = 0;
						
						//printf("%s\n",atribName);
						
						while(k < strlen(atribName)){
							*(strSave + cont) = atribName[k];
							k++;
							cont++;
						}
						*(strSave + cont) = ',';
						cont++;	
				}		
			}
			//printf("%s\n",strSave);
				
		
				
		//At� aqui est� certo!!!		
			
			//Terminar o la�o-XXX aqui ===========================================================================================================================

			///Inclui o label do evento futuro na observa��o atual/////////////////////////////////////////
			futureWindowIndex = i * step + presentWindowSize + jump;
			//printf("futureWindow  = %d\n",futureWindowIndex);
			//////////////////////PAREI AQUI///////////////////////////////////
			int solarClass;
			//printf("Teste: %c\n",solarDataSet[futureWindowIndex][numColumn-1].palavra[1]);

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
			
			
			//maxi = atoi(solarDataSet[futureWindowIndex][numColumn-1].palavra);
			maxi = solarClass;
			//printf("%d\n",maxi);
			//printf("futureWindowIndex + futureWindowSize: %d",futureWindowIndex + futureWindowSize);
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
				//maxi =  (maxi > atoi(solarDataSet[count][numColumn-1].palavra))?maxi:atoi(solarDataSet[count][numColumn-1].palavra);
				maxi =  (maxi > solarClass?maxi:solarClass);
			}
			
			sprintf(atribName, "%c\n", solarFlare[maxi]);
			///////////////////////////////////////////////////////////////////////////////////////////////
			//printf("cheguei aqui");
			for (k = 0; k < 2; k++, cont++) {
				*(strSave + cont) = atribName[k];
			}
		fprintf(fp, "%s", strSave);
        free(strSave);
		fclose(fp);
        
        }
		
		
		//*(strSave + cont) = '\0';



		
		
	}
	
int retFileNumLines(){
	int contNumLines, indexWord = 0;
	char line[1500];
	
	//FILE *in = fopen("C:\\Users\\sergi_000\\Desktop\\testeSS\\06_TestPlan\\All\\all_maxRay2.csv", "r");
	FILE *in = fopen(vetPathFile, "r");
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
	
	String **m;
	long int linhas, colunas, numPalavras = 0, totalLinhas;
	int flagColunas = 0;
//	FILE *in;
	FILE *arquivo;
    
    char buff[512];
    char str[512];
    char line[1500];
    char word[100];
    int indexWord = 0, indexLine = 0, numColunas = 0, i, j;
    int presentWindow = 720, jump = 0, futureWindow = 1440;
    int windowSize = presentWindow + jump  + futureWindow;

strcpy(vetPathFile,"/home/carlos/Downloads/sergio2014.csv");

strcpy(vetPathFileSlided,"/home/carlos/Downloads/sergio2014slided.csv");

    totalLinhas = retFileNumLines();//atoi(str)/CHARLINHA*1.2;
	
	
 	m = (String **)malloc(sizeof(String*) * totalLinhas);
 	arquivo = fopen(vetPathFile, "r");
	
 	if (arquivo == NULL){
         return EXIT_FAILURE;

 }
        
     linhas = 0;    

	while(fgets(line, sizeof line, arquivo) != NULL)
    {	
	    	if(flagColunas==0){
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
		*(m+linhas) = malloc(sizeof(String)*numColunas);
		indexWord = 0;
		indexLine = 0;
		i = 0;
		colunas = 0;
		
		if(numColunas > 0){
			while(line[indexLine] != '\n'){
				if(line[indexLine] != ','){
					word[indexWord] = line[indexLine];//m[linhas][colunas].palavra[indexWord] = line[indexLine];
					indexWord++;
				}
				if((line[indexLine] == ',')||(line[indexLine+1] == '\n')){
					word[indexWord]='\0'; //m[linhas][colunas].palavra[indexWord]='\0';
					indexWord = 0;
					m[linhas][colunas].palavra = (char*)malloc(sizeof(char)*strlen(word));
					strcpy(m[linhas][colunas].palavra,word);
					colunas++;
				}
				indexLine++;
			
			}		
			
		}
		///////////////////////////////////////////////////////////////////////////////////////////////////
       linhas++;   //incremento para preencher a pr�xima linha da matriz
    }
	
 	totalLinhas = linhas;       
		
	
 	float tupleQty = ceil((totalLinhas - windowSize + 1) / (float)1);
	
	printf("\nt_rec[0] = %s\n",m[0][1].palavra);
	printf("t_rec[1] = %s\n",m[1][1].palavra);
	printf("t_rec[2] = %s\n",m[2][1].palavra);


	slidingWindowMultipleColumns(m, futureWindow, jump, vetPathFileSlided, tupleQty, presentWindow, 1, totalLinhas, numColunas);
		
 	free(m);
    
    
//    pclose(in);
 	fclose(arquivo);
	

}

