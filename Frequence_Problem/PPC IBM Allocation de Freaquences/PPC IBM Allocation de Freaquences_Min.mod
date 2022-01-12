/*********************************************
 * OPL 12.10.0.0 Model
 * Author: natal
 * Creation Date: 07-01-2022 at 21:56:18
 *********************************************/

 using CP;
 
 int T = ...;
 int ch= ...;
 
 range emet = 1..T;
 range chan = 1..ch;

 int offset [i in emet][j in emet]=...;
 
 // variables
 dvar int x[t in emet] in chan; // the frequency allocated to each transmetter
 dvar int z;
 
 // objective is to minimize the maximum frequency used
 minimize max(t in emet) x[t];
 
// constraints
 subject to{
	// transmetter odd/even allocated with frequency odd/even
    forall (t in emet)
      x[t]%2 == t%2;

	// constraint proximity
 	forall (i, j in emet : offset[i][j]!=0)  	
 		abs(x[i]-x[j]) >= offset[i][j];
 }