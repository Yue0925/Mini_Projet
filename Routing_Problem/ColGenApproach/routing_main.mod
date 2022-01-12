/*********************************************
 * OPL 12.10.0.0 Model
 * Author: yue
 * Creation Date: Jan 9, 2022 at 7:04:03 PM
 *********************************************/

/*
 * This version of the main routing script
 * uses OplDataElements for data that are 
 * passed from one model to the other
 */

float temp;

int NumCustomers = ...;

range Clients = 1..NumCustomers;

int Capacity = ...;

int demand[Clients] = ...;

// Some simple default routes are given initially in routing.dat
tuple Route {
   key int id;
   int deliver[Clients];
};

{Route} Routes = ...;

// dual values used to fill in the sub model.
float Duals[Clients] = ...;

// Variable relaxed
dvar float Truck[Routes] in 0..1; // whether send a truck run the route
     
     

/*-----------------------------
* Master problème - modelling
* 
*------------------------------*/

// Minimize the total trucks used
minimize
  sum( r in Routes ) 
    Truck[r];

subject to {
  // Unique constraint in the master model is to cover each customer.
  forall( i in Clients ) 
    ctDelivery:
      sum( r in Routes ) r.deliver[i] * Truck[r] >= 1;
}

tuple res {
   Route r;
   float truck;
};

{res} Result = {<r,Truck[r]> | r in Routes }; //: Truck[r] > 1e-6


// set dual values used in the sub model.
execute DeliveryDuals {
  for(var i in Clients) {
     Duals[i] = ctDelivery[i].dual;
  }
}

// Output the current result
execute DISPLAY_RESULT {
   writeln(Result);
}



main {
   var before = new Date();
   temp = before.getTime();
   
   var status = 0;
   thisOplModel.generate();
   // This is an epsilon value to check if reduced cost is strictly negative
   var RC_EPS = 1.0e-6;
   
   // Retrieving model definition, engine and data elements from this OPL model
   // to reuse them later
   var masterDef = thisOplModel.modelDefinition;
   var masterCplex = cplex;
   var masterData = thisOplModel.dataElements;   
   
   // Creating the master-model
   var masterOpl = new IloOplModel(masterDef, masterCplex);
   masterOpl.addDataSource(masterData);
   masterOpl.generate();
   
   // Preparing sub-model source, definition and engine
   var subSource = new IloOplModelSource("routing_sub.mod");
   var subDef = new IloOplModelDefinition(subSource);
   var subCplex = new IloCplex();

   while ( true ) {
      
      writeln("Solve master.");
      if ( masterCplex.solve() ) {
        masterOpl.postProcess();
        writeln();
        writeln("MASTER OBJECTIVE: ", masterCplex.getObjValue());
      } else {
         writeln("No solution to master problem!");
         masterOpl.end();
         break;
      }
      
      // Creating the sub model
      var subOpl = new IloOplModel(subDef,subCplex);
      
      // Using data elements from the master model.
      var subData = new IloOplDataElements();
      subData.NumCustomers = masterOpl.NumCustomers;
      subData.Capacity = masterOpl.Capacity;
      subData.demand = masterOpl.demand;
      subData.Duals = masterOpl.Duals;
      
      subOpl.addDataSource(subData); 
      subOpl.generate();
      
      // Previous master model is not needed any more.
      masterOpl.end();
      
      writeln("Solve sub.");
      if ( subCplex.solve() &&
           subCplex.getObjValue() <= -RC_EPS) {
        writeln();
        writeln("SUB OBJECTIVE: ",subCplex.getObjValue());
      } else {
        writeln("No new good route, stop.");
        subData.end();
        subOpl.end();         
        break;
      }
      
      // prepare next iteration
      masterData.Routes.add(masterData.Routes.size, subOpl.Deliver.solutionValue);
      writeln("ADD NEW ", masterData.Routes.size, " : ", subOpl.Deliver.solutionValue);
      
      masterOpl = new IloOplModel(masterDef,masterCplex);
      masterOpl.addDataSource(masterData);
      masterOpl.generate();
      // End sub model
      subData.end();
      subOpl.end();      
   }
      

   subDef.end();
   subCplex.end();
   subSource.end();
   
   var after = new Date();
   writeln("solving time ~= ", (after.getTime()-temp)/ 1000); // convert to seconds
   
   status;
}
 