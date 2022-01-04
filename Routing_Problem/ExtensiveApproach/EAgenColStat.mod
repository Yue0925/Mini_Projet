/*********************************************
 * OPL 12.10.0.0 Model
 * Author: yue
 * Creation Date: Jan 4, 2022 at 7:13:24 PM
 *********************************************/

// generate all feasible/possible routes

include "EAgenColStatComm.mod";

main{
  // create model
   var master = thisOplModel;
   master.generate();
   var data = master.dataElements;

   // start with a feasible solution (une configuration)
   var genRoute = new IloOplRunConfiguration("EAgenColStatGenRoute.mod");
   
   // param setting 
   // !!!!!! TODO: try different settings !!!!!!
   genRoute.cp.param.SearchType="DepthFirst"; // ajout ENE
   genRoute.cp.param.Workers=1;  // ajout ENE

   // start solving
   genRoute.oplModel.addDataSource(data);
   genRoute.oplModel.generate();
   genRoute.cp.startNewSearch();
   var  n = 1;

   // keep finding sols
   while (genRoute.cp.next() && n <= 1000) { // TODO : try with bigger limit !!!
   	 write ("<",n, ",");
     n++; 
     genRoute.oplModel.postProcess(); // print
     // add new sol
     data.Routes.add(genRoute.oplModel.newId, 
                   genRoute.oplModel.deliver.solutionValue);
   }

   // clôture
   genRoute.cp.endSearch();
   genRoute.end();
 }