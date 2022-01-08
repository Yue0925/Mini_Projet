/*********************************************
 * OPL 12.10.0.0 Model
 * Author: natal
 * Creation Date: 08-01-2022 at 11:31:35
 *********************************************/
using CP;
 
 int T = ...;
 int ch= ...;
 range emet = 1..T;
 range chan = 1..ch;

 int offset [i in emet][j in emet]=...;
 dvar int x[t in emet] in chan;
 dvar int y in chan;
 
 subject to{
	 forall (t in emet : t%2 == 0, c in chan : c%2 != 0)   	x[t]!= c ;
	 forall (t in emet : t%2 != 0, c in chan : c%2 == 0)   	x[t]!= c ;
	 forall (i, j in emet : offset[i][j]!=0)  	abs(x[i]-x[j])>= offset[i][j];
	 
	 
	 y==max(t in emet) x[t]; 
 }
 
 main {
 	
 	var initialModel=thisOplModel;
 	initialModel.generate();
 	var ub =0; 
 
 	while(cp.solve()){

		var min_ch=initialModel.y;
		min_ch=min_ch-1;
		var data=initialModel.dataElements;
		data.ch = min_ch;
		var def=initialModel.modelDefinition;
		var updateModel= new IloOplModel(def,cp);
		
		updateModel.addDataSource(data);
		updateModel.generate();
	 	
	 	if(cp.solve()){
		 	writeln("Maximal frequence: ", updateModel.y);
		 	write("Solution: [");
			for (var t=1; t<data.T; t++) write(" ", updateModel.x[t]);
				write(" ]"); writeln("");}
				
		else writeln("There is no other solution with a maximal frequence lower than: ", min_ch+1);
	 	initialModel=updateModel;
	} 	
}	 