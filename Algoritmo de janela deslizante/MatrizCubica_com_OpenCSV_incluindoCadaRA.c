#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include<string.h>

#define CHARLINHA 900
#define ATRIBSIZE 100
#define TOTALNUMBEROFACTIVEREGION 5000


typedef struct{
	char *palavra;
} String;

typedef struct{
	int startIndexActiveRegion;
	int numberOfLinesActiveRegion;
} ARInfo;

char path[200];
char fileName[100];
char pathAndName[200];
char pathfileNameSlided[100];

void slidingWindowMultipleColumns(String **solarDataSet, int futureWindowSize, int jump, char *filename, float tupleQty, int presentWindowSize, int step, int totalArrayLength, int numColumn, ARInfo *arInfo) {
		FILE *fp;
		int atribSize = 6*(presentWindowSize*(numColumn-1));
		char *strSave = (char*)malloc(((6*(presentWindowSize*(numColumn-1))) + ((20*(numColumn - 1)) * presentWindowSize+2)*tupleQty)*sizeof(char));
		//char atribName[ATRIBSIZE];
		char *atribName = (char*)malloc(atribSize * sizeof(char));
		char *atrib = (char*)malloc(6 * sizeof(char));
		long int i, j, col, maxi;
		int futureWindowIndex;
		int windowSize = futureWindowSize + presentWindowSize + jump;
		float noaa_AR_tupleQty;
		char solarFlare[] = { 'N','N','Y','Y','Y' };//defines which class is solar flare or not. A, B, C, M, X
		//char solarFlare[] = { 'A','B','C','M','X' };//defines which class is solar flare or not. A, B, C, M, X
		unsigned int cont = 0;
		int count;
		sprintf(atrib, "");
		sprintf(strSave, "");
		sprintf(atribName, "");
			
		int ci = 0;
		
		strcat(strSave, "region,");

		for (i = 0; i < presentWindowSize*(numColumn-2); i++) {
			sprintf(atrib, "at%d,", i);
			strcat(atribName, atrib);
		}
		strcat(atribName, "class");
		fp = fopen(filename, "w+");
		strcat(strSave, atribName);
		
		//===============================
		cont = strlen(strSave);
		
		int k;

		*(strSave + cont) = '\n';
		cont++;	
		
		
		

	ci = 0;
	while(arInfo[ci].startIndexActiveRegion != 0){

		noaa_AR_tupleQty = ceil((arInfo[ci].numberOfLinesActiveRegion - windowSize + 1) / (float)1);

		for (i = arInfo[ci].startIndexActiveRegion; i < noaa_AR_tupleQty + arInfo[ci].startIndexActiveRegion; i++)
		{
			//Incluir um laço-XXX para considerar todas as colunas da matriz com a base de dados contendo as séries de dados solares. ============================
			

					j = 0;
					strcpy(atribName, solarDataSet[i][0].palavra);
					
					k = 0;
					
					
					
					while(k < strlen(atribName)){
						*(strSave + cont) = atribName[k];
						k++;
						cont++;
					}
					*(strSave + cont) = ',';
					cont++;	
					col++;			
	
			for(col = 1; col < numColumn-1; col++){
				for (j = 0; j < presentWindowSize; j++){
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
			
				
		

			///Inclui o label do evento futuro na observação atual/////////////////////////////////////////
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
			
			
			//maxi = atoi(solarDataSet[futureWindowIndex][numColumn-1].palavra);
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
				//maxi =  (maxi > atoi(solarDataSet[count][numColumn-1].palavra))?maxi:atoi(solarDataSet[count][numColumn-1].palavra);
				maxi =  (maxi > solarClass?maxi:solarClass);
			}
			
			sprintf(atribName, "%c\n", solarFlare[maxi]);
			///////////////////////////////////////////////////////////////////////////////////////////////
			
			for (k = 0; k < 2; k++, cont++) {
				*(strSave + cont) = atribName[k];
			}
		*(strSave + cont) = '\0';
		}
		
		ci++;
	}



		fprintf(fp, "%s", strSave);
		free(strSave);
		fclose(fp);
	}
	
int retFileNumLines(){
	int contNumLines, indexWord = 0;
	char line[1500];
	FILE *in = fopen(pathAndName, "r");
	
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
	ARInfo arInfo[TOTALNUMBEROFACTIVEREGION];
	long int linhas, colunas, numPalavras = 0, totalLinhas;
	int flagColunas = 0;
	FILE *in;
	FILE *arquivo;
    
    char buff[512];
    char str[512];
    char line[1500];
    char word[100];
    int indexWord = 0, indexLine = 0, numColunas = 0, i, j, contAR = 0;
    int presentWindow = 1, jump = 0, futureWindow = 120;
    int windowSize = presentWindow + jump  + futureWindow;
    int firstNOAA_AR = 1, noaa_AR_Index = -1;
    char noaa_AR[15];
    char cmd[300];
    
    printf("Processando...");
    
    strcpy(noaa_AR," ");
    
	strcpy(path,"/home/marcela/Documentos/01_Doutorado/_01_ArquivosDR/05_Experimentos/21_Bobra/00_ArquivoFonte/");
	strcpy(fileName,"noaa_ar_trec_bobra.csv");
	strcpy(pathAndName,path);
	strcat(pathAndName,fileName);
	
	//strcpy(cmd,"cd ");
	//strcat(cmd,path);
	//strcat(cmd," && FORFILES /S /M *.csv /C \"cmd /c echo @fsize\"");
	
	strcpy(pathfileNameSlided,path);
	strncat(pathfileNameSlided,fileName,strlen(fileName)-4);
	strcat(pathfileNameSlided,"_slided.csv");
	
    for(i=0; i<TOTALNUMBEROFACTIVEREGION; i++){
    	arInfo[i].numberOfLinesActiveRegion = 0;
    	arInfo[i].startIndexActiveRegion = 0;
	}
    
    
    //if(!(in = popen("cd C:\\Users\\sergi_000\\Google Drive\\Doutorado\\19_DadosDeTestes\\04_MagneticField\\complete\\ && FORFILES /S /M *.csv /C \"cmd /c echo @fsize\"", "r"))){
    //if(!(in = popen("cd C:\\Users\\sergi_000\\Desktop\\testeSS\\ && FORFILES /S /M *.csv /C \"cmd /c echo @fsize\"", "r"))){
    //if(!(in = popen(cmd, "r"))){
    //    exit(1);
    //}
    //while(fgets(buff, sizeof(buff), in)!=NULL){
    //    sprintf(str, buff);
    //}
    totalLinhas = retFileNumLines();//atoi(str)/CHARLINHA*1.2;
	
	m = malloc(sizeof(String*) * totalLinhas);
	arquivo = fopen(pathAndName, "r");
	//arquivo = fopen("C:\\Users\\sergi_000\\Google Drive\\Doutorado\\19_DadosDeTestes\\04_MagneticField\\complete\\todo_1.csv", "r");
	
	if (arquivo == NULL)
        return EXIT_FAILURE;
        
    linhas = 0;    
	while(fgets(line, sizeof line, arquivo) != NULL)
    {	
	    //descobre a qtde de colunas do arquivo CSV/////////////////////

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
		////////////////////////////////////////////////////////////////
		//aloca o vetor de string na matriz
		*(m+linhas) = malloc(sizeof(String)*numColunas);
		//faz o parser na linha separada por vírgula e coloca na linha da matriz principal/////////////////
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
					m[linhas][colunas].palavra = malloc(sizeof(char)*strlen(word));
					strcpy(m[linhas][colunas].palavra,word);
					colunas++;
				}
				indexLine++;			
			}		
			
		}
		///////////////////////////////////////////////////////////////////////////////////////////////////
       if(linhas>0){
			if(strcmp(noaa_AR,m[linhas][0].palavra) != 0){
				noaa_AR_Index++;
				arInfo[noaa_AR_Index].startIndexActiveRegion = linhas;
				strcpy(noaa_AR,m[linhas][0].palavra);
			}
			arInfo[noaa_AR_Index].numberOfLinesActiveRegion++;
		}
		linhas++;   //incremento para preencher a próxima linha da matriz
    }
	
	totalLinhas = linhas;       
	
	
	float tupleQty = ceil((totalLinhas - windowSize + 1) / (float)1);
	
	slidingWindowMultipleColumns(m, futureWindow, jump, pathfileNameSlided, tupleQty, presentWindow, 1, totalLinhas, numColunas, arInfo);
		
	free(m);
    
    
    pclose(in);
	fclose(arquivo);
	

}

