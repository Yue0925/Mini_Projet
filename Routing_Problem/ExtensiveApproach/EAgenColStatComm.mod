/*********************************************
 * OPL 12.10.0.0 Model
 * Author: yue
 * Creation Date: Jan 4, 2022 at 6:12:53 PM
 *********************************************/
 
int NumCustomers = ...;
range Customers = 1..NumCustomers;
int demand[Customers] = ...;

int MaxTrucks = ...;
int Capacity = ...;


tuple Route {
   key int id;
   int deliver[Customers];
};

{Route} Routes = ...; // set of all feasible routes

int nRoutes = card(Routes);
