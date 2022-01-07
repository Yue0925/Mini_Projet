/*********************************************
 * OPL 12.10.0.0 Model
 * Author: natal
 * Creation Date: 07-01-2022 at 22:42:47
 *********************************************/
include "unique solution.mod";

 main 
 { // type of research

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

   cp.setSearchPhases(phase2);  
   thisOplModel.generate();
   
   cp.param.Workers=1;
   cp.startNewSearch();
   
   // Boucle to find the 10 first solutions
   var n=1;
   var nMax = 10;
   
   while (cp.next() && n<= nMax) { 
      write("Solution " + n + " [");  
      n++;
      for (var c in thisOplModel.x){
   	      write(thisOplModel.x[c]+  ",");                
   	  }                  
   	  writeln("]");
   }
 }
 