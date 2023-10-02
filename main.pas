program main;
uses MainText,UtilisateurUnites;
const NDICT = 1000;
Var 
    T1, T2, T3     : Tab; 
    M1, M2, M3, M4 : Mat;
    MPos           : MatPositive;
    M5             : MatOCC;
    choix , nb, i, tailleD :integer;
    D              : DICTIONNAIRE;
    L1, L2, L3, L4 : LARGE_MOTS;
    
    
begin 
	TextRead('DataText.txt',T1);               
	
	cleaner(T1, T2);
	
	TextWrite('DataTextNettoyé.txt',T2);

	nb_mots(T2,T3);
	
	TextWrite('DataTextNombre.txt',T3);
	   
	extraction(T2,M1);
	
	TextWrite2('DataTextList',M1); 
	
	frequence_de_mot(M1,M2);
	
	TextWrite2('DataTextFrequence',M2);
	
	TextRead2('DataTextList',M3);
	
	liste_sans_repetition(M3,M4, M5, MPos);
	
	TextWrite2('DataTextSansRepetition', afficher_liste_sans_repetition(M4, M5, MPos) );
	
	dico ( M4, M5, MPos, D , tailleD);
	
	TextWrite3('DataTextDico',  afficher_dictionnaire(D, tailleD) , tailleD);
	
	
	writeln('Si vous voulez afficher les mots du dictionnaire ordonné par ordre alphabétique entrez 1');
	writeln('Si vous voulez afficher les mots du dictionnaire ordonné par ordre decroissant de la fréquence des mots entrez 2');
	writeln('Si vous voulez afficher un nombre limité des mots du dictionnaire entrez 3');
	readln(choix);
	case choix of 
	
	1 :    begin   
	           ordre_alphab ( D , L4 );
  			for i:=1 to NDICT do
  			     writeln(L4[i]);
  		end;
  		
  	2 :    begin		 
  		     ordre_decroissant ( D , L3 );
  			for i:=1 to NDICT do
  			    writeln(L3[i]);				
  		end;  
  		
  	3 :     begin	
  			writeln('entrez le nombre de mots que vous voulez afficher ');
  			readln(nb);
  			 L1 := afficher_dictionnaire (D, tailleD);
  			 afficher_mot_voulu (nb,L1,L2);
  			 for i:=1 to nb do
  			      writeln(L2[i]);
  		end;
  	end;
end.
