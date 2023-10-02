unit UtilisateurUnites;

interface
	uses crt;
	
	const NMax = 24; MMax=50;
		NDICT = 1000;
		
	type  Tab = array [1..NMax] of string;
              LIST_MOTS = record
	           contenu : array[1..100] of String[20];
                   nb_mots : integer;
	      end;
	      
	      Mat = Array[1..NMax, 1..100] of String[40];
	      MatOcc =Array[1..NMax, 1..100] of integer;
	      MatPositive = Array[1..NMax, 1..100] of boolean;
	      
	      
	      MOTDICTIONNAIRE = Record
	      	mot : String[20];
	      	occ : integer;
	      	nature : boolean; //nature = true : mot positif sinon mot negatif
	      End;
	      
	      DICTIONNAIRE   = Array[1..NDICT] of MOTDICTIONNAIRE;
	       LARGE_MOTS   = Array[1..NDICT] of String;


	procedure cleaner(T : Tab; var V : Tab);  // clean the contents of the array T of all special characters and put it in V
	procedure nb_mots( T : Tab ; Var V : Tab); // calculate the number of words 
	procedure extraire_list_mot(message: string; var listmots : List_Mots); //extract the words off of one string 
	procedure extraction(T:Tab ; var V:Mat); //extract the words of all the data base 
	procedure TextWrite2(name : string; T : Mat);//Writes in a text file 
	procedure TextRead2(name : string; var T : Mat);//Reads from a text file 
	procedure TextWrite3(name : string; T : LARGE_MOTS; taille : integer);//Writes in a text file 
	procedure Frequence_de_mot(T : mat; var M : Mat);//Calculate the frequency of words 
	procedure  liste_sans_repetition( T : Mat ; var M:Mat; var MOcc : MatOcc; VAR MPos : MatPositive);
	           //list the words without any repetition 
	function  afficher_liste_sans_repetition(M:Mat; MOcc : MatOcc; MPos : MatPositive) : Mat; 
	      // concaténer entre les trois matrices obtenues grace à la fonction précedente et mettre le résultat dans une matrice      
	procedure dico ( M : Mat; MOcc : MatOcc; MPos : MatPositive ; var D : DICTIONNAIRE; var taille : integer);
// concaténer entre trois matrices de contenues différents dans un tableau d'enregistrement a trois champs en retournantla taille de ce derneir 
	function  afficher_dictionnaire(D : DICTIONNAIRE ; taille : integer) : LARGE_MOTS; 
// concaténer entre le le tableaux d'enregistrement et sa taille pour avoir un tableau contenant que des chaines de caractères
	procedure echange_i(VAR a,b : integer); // permuter entre deux valeurs numériques
	procedure echange_c(VAR a,b : string);  // permuter entre deux mots
	procedure ordre_decroissant ( D : DICTIONNAIRE ; var L : LARGE_MOTS );  
    // afficher les Mot du tableau d'enregistrement selon l'ordre décroissant de leur fréquence 
	procedure ordre_alphab ( D : DICTIONNAIRE ; var L : LARGE_MOTS); 
//afficher les Mot du tableau d'enregistrement selon l'ordre alphabétique
	procedure afficher_mot_voulu ( N : integer; D: LARGE_MOTS; var V : LARGE_MOTS );

implementation


	procedure cleaner(T : Tab; Var V:Tab);
	 var
		m, n : String;
		i, index : integer;
	Begin
		for i:=1 to 24 do
		   begin
		    n:='';
		     m:=T[i];
		      for Index:=1 to Length(m) do 
		       begin
			if (m[Index] in ['A'..'Z','a'..'z']) or (m[Index]=' ') then
			  begin
			  	n:=n+m[Index];               {ecrire les mots ne contenant que des caractères alphabtiques}
				 if (n[length(n)-1] in [ ' ']) and (n[length(n) ]= ' ') then 
		     		   n:=copy(n,1,length(n)-1);                  {supprimé un espace s'il y'en a deux qui se suivent }
			  end; 
		       end;
		     V[i]:=n; 
		    end;
	End;
	
	
	
	
	
	procedure nb_mots( T : Tab ; Var V : Tab);
        var
            tabl : Tab;
            i,index,nb,e : integer;
            b,m,f: string;
  
       Begin
            e:=0;
            for i:=1 to 24 do
            begin 
                 m:= T[i];
                 nb:= 0;    { initialiser à 0 afin de pas compter le dernier mot de chaque phrase qui est soit 'positive' ou 'negative'}
                 for index:= 1 to length(m) do 
                 begin
                      if m[index]=' ' then
                         nb:= nb +1 
                      else
                         nb:=nb;
                end;
                e:=e+nb;          {afin de calculer le nombre de mots de toute la base}
                str(nb,b);        
                str(e,f);
                tabl[i]:=b+'/'+f;     
          {b est le nombre de mots du message, f est le nombre de tous les mots du premier message jusqu'au message n°i}
                V[i] := T[i] + tabl[i];
           end;
      end;

	procedure extraire_list_mot(message: string; var listmots : List_Mots);   {extraire les mots d'une seule chaine de caractère}
        var
			mot : String;
			i: integer;
	begin
	       mot := '';
	       listmots.nb_mots := 0;
	       for i:=1 to length(message) do
	       begin
	  	  if message[i] <> ' ' then
		     mot := mot + message[i]
	  	  else
	  	  begin
		     if (mot <> '') then
		     begin
	  		listmots.nb_mots := listmots.nb_mots + 1;
	  		listmots.contenu[listmots.nb_mots] := mot;        {permet de sauter une ligne a chaque fois qu'il écris un mot}
	  		
	  		mot:='';
	  	      end;
	  	 end;
	       end;
	  
	    if (mot <> '') then
	    begin
	  	listmots.nb_mots := listmots.nb_mots + 1;
	  	listmots.contenu[listmots.nb_mots] := mot;
	    end;
	 end;




	procedure extraction(T:Tab ; var V:Mat);   { extraire les mots de plusieurs chaines de caractère}
	var
	    i,index:integer;
	    m:string;
	    listmots:list_mots;
	begin
	    for  i:=1 to 24 do 
	    begin
	       m:=T[i];
	       
	       extraire_list_mot(m,listmots);        { faire la liste des mots de chaque messages }
	       for index:=1 to listmots.nb_mots do
	  	   V[i, index]:=listmots.contenu[index];
	    end;
	end;



	procedure TextWrite2(name : string; T : Mat);
	var i,j: integer;
	Fout : text;

	begin
	assign(Fout, name);
	Rewrite(Fout);

	for i:=1 to Nmax do
	    begin
	    	j:=1;
	    	if (T[i, 1] <> '') then
	    		writeln(Fout, 'Les mots du twitte N ', i, ' : ');
	    	
	    	while (T[i, j] <> '') do
	    	begin
			writeln(Fout, T[i, j]);
			j:=j+1;
		end;
	    end;

	close(Fout);
	end;
	
	
	
	
	
	
	procedure TextRead2(name : string; var T : Mat);
	var i,j, ps : integer;
	    fin : text;
	    ligne : String;
	begin

	assign(Fin, name);
	reset(Fin);

	for i:=1 to NMax do
	    begin
	    for j:= 1 to Mmax do
	    begin
			readln(Fin, ligne);
			ps := pos('Les mots du twitte', ligne);
			if (ps = 1) And (j=1) then
			begin
				readln(Fin, ligne);
			end
			else if (ps = 1) then
				break;               { forcer le sortie de la boucle j a chaque fois que les mots du twitte est trouvé }
			
			T[i,j] := ligne;
	    end;
	end;    	
	close(Fin);
     end;    
	
	
	
	procedure TextWrite3(name : string; T : LARGE_MOTS; taille : integer); // Writes in a text file 
	var i: integer;
		Fout : text;

	begin
		assign(Fout, name);
		Rewrite(Fout);

		for i:=1 to taille do
	    begin
	    	writeln(Fout, T[i]);
		end;

		close(Fout);
	end;
	
      
      procedure frequence_de_mot( T:mat ; var M:mat );
      var
	    i,j,h,oc: integer;
	    occ : string;
      
      begin
			for i:=1 to NMax do
			begin
				for j:=1 to MMax do
				begin
					if (T[i,j] <> '') then        
					begin		
			     			oc:=0;
				       	for h:=1 to MMax do
				       	begin 
					       	if T[i,j]=T[i,h] then
					       	begin
					       		oc:= oc + 1;
					       		str(oc,occ);       { convertir les chiffres en chaine de caractères }
					       	end;
				       
				      		end;
				      		M[i,j]:= T[i,j] + '(' + occ + ')'; { concaténer entre le mot et sa fréquence d'aaparition}
				      	end
				      	else
				      	begin
				      		M[i,j]:= '';
				      	end;
			       end;
		       end;
	end;
     
     
     
     


	procedure  liste_sans_repetition( T : Mat ; var M:Mat; var MOcc : MatOcc; VAR MPos : MatPositive);
	{ la matrice M , MOcc, MPos marchent ensemble }
	var
	    i,j,h,MMax,indice:integer;
	begin
		MMax:=50;
		
		for i:=1 to NMax do
			for j:=1 to MMax do
				M[i,j] := '';
				
		for i:=1 to NMax do
		begin
			for j:=1 to MMax do
			begin
				indice := -1;
				h := 1;
				while (h<=MMax) AND (M[i,h]<>'') AND (indice =-1) do 
				begin
					if M[i, h] = T[i,j] then
						 indice := h
					else
						h := h+1;
				end;
				
				if (indice = -1) then   { c'est a dire le mot n'existe pas }
				begin
					M[i,h] := T[i,j];  { on ecrit le mot dans la matrice de mot }
					MOcc[i,h] := 1;     { on met la frequence du mot a 1 dans la matrice d'occurences }
				end
				else
					MOcc[i,h] := MOcc[i,h] + 1;   
			 { si le mot existe deja on ne le réécrit pas on augumente seulement le nombre d'occurences}
			end;
	       end;
	       
	       for i:=1 to NMax do 
	       begin
	       	for j:=1 to MMax do
	       	begin
	       		if (M[i,j+1] = '') then  { si la case est vide on force la sortie de la boucle for }
	       			break;
	       	end;
	       	
	       	if ( lowercase(M[i, j])='positive' ) OR ( lowercase(M[i, j])='negative' ) then 
	{ lowercase permet de convertir les mots de la matrice en miniscules afin de ne pas avoir de problème par rapport au code ASCII }
	       	begin
		       	if ( lowercase(M[i, j])='positive' ) then
		       		for h:=1 to j-1 do
		       			MPos[i, h] := true 
		    { si le dernier mot du twitte est positif alors tout les mots du twitte sont considérés comme étant positifs }
		       	else
			       	if ( lowercase(M[i, j])='negative' ) then
			       		for h:=1 to j-1 do
			       			MPos[i, h] := false;
		       	
		       	M[i, j]:= '';   
		       	MOcc[i, j]:= 0;
		       { supprimer le dernier mot de chaque message ainsi que la fréquence de son apparition }
		      	end;
	       end;
	       
	end;
	
	
	
	function IntToStr(n : integer) : String;  { convertir un chiffre en chaine de caractère }
		var
			s : string;
	begin
		STR(n, s);
		IntToStr := s;
	end;
	

	
	
	function  afficher_liste_sans_repetition(M:Mat; MOcc : MatOcc; MPos : MatPositive) : Mat;  
	         { concaténer les trois matrices générées pendant la suppression des mots répétés }
		var
			M2 : Mat;
			i, j : integer;
	begin
		for i:=1 to NMax do
			for j:=1 to MMax do
				M2[i, j] := '';
		
		for i:=1 to NMax do
		begin
			for j:=1 to MMax do
			begin
				if (M[i,j] <> '') then
				begin
					M2[i, j] := M[i,j]+'('+IntToStr(MOcc[i,j])+')';  
					if (MPos[i, j]) then   { j'ai remarqué que lorsque'on ne met rien cela veut dire que = true}
						M2[i, j] := M2[i, j] + ' : POSITIVE'
					else
						M2[i, j] := M2[i, j] + ' : NEGATIVE'
				end
				else
					break; 
			end;
		end;
	
		afficher_liste_sans_repetition := M2;
	end;
	
	
	
	
	
	procedure dico ( M : Mat; MOcc : MatOcc; MPos : MatPositive ; var D : DICTIONNAIRE; var taille : integer);
 { concaténer les trois matrices afin de former un seul tableau d'enregistrement de manière à ce que chaque champs        
                             d'enregistrement represente le contenu d'une seul matrice}
	var
		i,j,h, indice : integer;
		mot : String;
	begin
		taille := 0;

		for i:=1 to NMax do
		begin
			for j:=1 to MMax do
			begin
				mot := M[i, j];

				h:=1;
				indice := -1;
				while (h<=taille)AND(indice = -1) do
					if D[h].mot = mot then
						indice := h          
 {si le mot existe dans le tableau on retient l'indice de la case qui le contient afin de pouvoir la traiter plus tard }
					else
						h:=h+1;

				if (indice = -1) then { c'est à dire le mot n'existe pas  }
				begin
					taille := taille + 1;      { si le mot n'exsite pas on l'inscirit dans une nouvelle case  }
					D[taille].mot := mot;
					D[taille].occ := MOcc[i, j];
					D[taille].nature := MPos[i, j];
				end
				else
				begin
					if D[indice].occ < MOcc[i, j] then                 
						D[indice].nature := MPos[i, j];
					D[indice].occ := D[indice].occ + MOcc[i, j];   { additionner les occurences du mots }
				end;
			end;
		end;
	end;
	

		
	{	
		for h:=1 to NDic do
		begin
			MOTDICTIONNAIRE.mot[h] := lowercase( MOTDICTIONNAIRE.mot[h] ) ; //transformer tous les mots en miniscules 
		end; 
		
		for index:=1 to NDic do
		begin
		     for iindex:=1 to Ndic do
		     begin
		    	 with MOTDICTIONNAIRE[h] do
		    	 begin
		     		if ( mot[index]= mot[iindex]) and ( nature[index]= nature[iindex] ) then 
		     // si le mot de la case index et le meme que celui de la case iindex et quils sontde meme nature
		     			OCC[index] := OCC[index] + OCC[iindex]; 
		     			 	// on additionne leur occurence 
					D[iindex]:=D[iindex] + 1; 
						// on supprime le mot répété 
					NDic := NDic - 1
				else
					if ( mot[index]= mot[iindex]) and ( nature[index] <> nature[iindex] ) then
		     // si le mot de la case index et le meme que celui de la case iindex  mais qu'ils n'ont pas le meme sens 
					begin
						if occ[index] < occ[iindex] then  
					//si le mot est répéter plus dans un sens negatif 
							occ[index]:= OCC[index] + OCC[iindex];                     
		//on additionne les occurences afin d'avoir la fréquence de répétition du mot dans la base de donnée 
							nature[index]:= nature[iindex]
				// le mot est classé négatif 
						else 
							occ[index]:= OCC[index] + OCC[iindex];
							nature[index]:= nature[index];  
						 // le mot est classé positif 
						end;
						D[iindex]:=D[iindex] + 1;  
					// supprimer le mot répété 
						NDic := NDic - 1
					end;
				end;
			end;
		     end;
		end;
	end; 
	                                                           }
	                                                           
	                                                           
	                                                           
	function  afficher_dictionnaire(D : DICTIONNAIRE ; taille : integer) : LARGE_MOTS; 
{ concaténer entre les différents champs du tableau d'enregistrement afin d'avoir un tableau qui contient que des chaines de caractères}
	var
			M2 : LARGE_MOTS;
			i: integer;
	begin
		for i:=1 to taille do
		begin
			M2[i] := D[i].mot+' ('+IntToStr(D[i].occ)+') - ';
			if (D[i].nature) then
				M2[i] := M2[i] + 'Positive'
			else
				M2[i] := M2[i] + 'Negative';
		end;

		afficher_dictionnaire := M2;
	end;
	
	                                                         
	
	procedure echange_i(VAR a,b : integer);  { permet de permuter entre deux valeur numérique }
	var
	   m:integer;
	begin
	    m:=a;
	    a:=b;
	    b:=a;
	end;
	
	procedure echange_c(VAR a,b : string); { permet de permuter entre deux mots }
	var
	   m:string;
	begin
	    m:=a;
	    a:=b;
	    b:=a;
	end;
	
	
	procedure ordre_decroissant ( D : DICTIONNAIRE; var L : LARGE_MOTS );
	var
	    i,j : integer;

	begin
		for i:=1 to NDICT do 
		begin
			for j:=1 to NDICT do
			begin
				if ( D[i].occ < D[j].occ ) then
					echange_i(D[i].occ , D[j].occ );
			end;
		end;
		
		L := afficher_dictionnaire(D , NDICT);
	end;
	
	
	
	
	
	
	procedure ordre_alphab ( D : DICTIONNAIRE ; var L : LARGE_MOTS );
	var
		i,j : integer;
	begin
		for i:= 1 to NDICT do 
		begin
			for j:=1 to NDICT do
			begin
				if D[i].mot > D[j].mot then
					echange_c(D[i].mot , D[j].mot );
			end;
		end;
		
		L := afficher_dictionnaire(D , NDICT);
	end;
		
		
	procedure afficher_mot_voulu ( N : integer; D: LARGE_MOTS; var V : LARGE_MOTS );
	var
		i: integer;
	begin
	     for i:= 1 to N do
	     	V[i] := D[i];
	     end;
 end.
