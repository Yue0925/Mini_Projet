/*********************************************
 * OPL 12.10.0.0 Model
 * Author: yue
 * Creation Date: Jan 12, 2022 at 1:37:15 PM
 *********************************************/
/*********************************************
 * OPL 12.10.0.0 Model
 * Author: natal
 * Creation Date: 07-01-2022 at 22:42:47
 *********************************************/
int frequencies[1..10];

 include "GenAFeasibleSolution.mod";
 

 main { 
	// set different possible research types
	var f = cp.factory;
	var phase1 = f.searchPhase(thisOplModel.x,
   							  f.selectSmallest(f.domainSize()),
   							  f.selectSmallest(f.value()));
	var phase2 = f.searchPhase(	thisOplModel.x,
    							f.selectLargest(f.domainSize()),
    							f.selectSmallest(f.value()));
    var phase3 = f.searchPhase( thisOplModel.x,
    							f.selectSmallest(f.varindex(thisOplModel.x)),
    							f.selectSmallest(f.value()));
    var phase4 = f.searchPhase( thisOplModel.x,
								f.selectSmallest(f.varIndex(thisOplModel.x)),
								f.selectRandomValue());
								
	cp.setSearchPhases(phase3);  
	thisOplModel.generate();
	cp.param.Workers=1;
	cp.startNewSearch();
   
 	/*  
 	* A loop to find the 10 first feasible solutions
 	*/
	var N = 1;
    while (cp.next() && N <= 10) { 
		write("Solution " + N + " [");  
      	for (var c in thisOplModel.x){
      	  write(thisOplModel.x[c]+  ",");                
      	  }                  
		writeln("]  with maximal frequency used : ", thisOplModel.maxF);
		thisOplModel.frequencies[N] = thisOplModel.maxF;
		N++;
   	}
   	var minMaxF = 10000;
   	
   	
   	for(var i=1; i<=10; i++){
   	  if(thisOplModel.frequencies[i] < minMaxF){
   	    minMaxF = thisOplModel.frequencies[i];
   	  }
   	}

   writeln("After 10 first solutions, the minimum maximal frequency used is ", minMaxF);
   
   /*
   * Branch & Bound approach, decrease the maximal frequency used !
   */
    minMaxF--;
 	var initialModel=thisOplModel;
 	initialModel.generate();
	var data=initialModel.dataElements;
	data.ch = minMaxF;
	
 	while(true){//cp.solve()
		writeln("true");
		//break;
		
		var def=initialModel.modelDefinition;
		var updateModel= new IloOplModel(def,cp);
		
		updateModel.addDataSource(data);
		updateModel.generate();
	 	
	 	if(cp.solve()){
		 	writeln("Maximal frequence: ", updateModel.maxF);
		 	write("Solution: [");
			for (var t=1; t<=data.T; t++) write(" ", updateModel.x[t]);
				write(" ]"); writeln("");


		}else{
		  writeln("no sol found with ", data.ch);
		  //writeln("There is no other solution with a maximal frequence lower than: ", (updateModel.maxF+1));
		  break;
		}
			initialModel=updateModel;
			data=initialModel.dataElements;
			data.ch = initialModel.maxF-1;
	} 
	
	
}  
