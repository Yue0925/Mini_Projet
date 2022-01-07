/*********************************************
 * OPL 12.10.0.0 Model
 * Author: natal
 * Creation Date: 07-01-2022 at 22:09:59
 *********************************************/
using CP;
 
 int T = ...;
 int ch= ...;
 
 range emet = 1..T;
 range chan = 1..ch;

 int offset [i in emet][j in emet]=...;
 dvar int x[t in emet] in chan;
 
  
 subject to{
 	forall (t in emet : t%2 == 0, c in chan : c%2 != 0)   	x[t]!= c ;
 	forall (t in emet : t%2 != 0, c in chan : c%2 == 0)   	x[t]!= c ;
 	forall (i, j in emet : offset[i][j]!=0)  	abs(x[i]-x[j])>= offset[i][j];
 }