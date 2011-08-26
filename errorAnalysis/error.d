#!/usr/bin/rdmd
//! Laurence R. McGlashan (lrm29@cam.ac.uk) 2011

import std.stdio;
import std.range;
import std.algorithm;
import std.string;
import std.file;
import std.conv;
import std.math;

import linear_interpolator;

int main(string[] args)
{
    // Load in the original file. Calculate the residual.
    string exactFile = cast(string)read(args[1]);
    string solutionFile = cast(string)read(args[2]);
    string[] exactSolution = splitlines(exactFile);
    string[] solution = splitlines(solutionFile);
        
    string exactHeader[] = split(exactSolution[0]);
    assert(exactHeader==split(solution[0]));
    
    auto Zindex = countUntil(exactHeader,"Z");
    auto Tindex = countUntil(exactHeader,args[3]);     
    double exactZ[];
    double Z[];
    double exactT[]; 
    double T[];
        
    foreach (line; exactSolution[2 .. $-1])
    {
        string results[] = split(line);
        exactZ ~= to!(double)(results[Zindex]);
        exactT ~= to!(double)(results[Tindex]);
    }
    foreach (line; solution[2 .. $-1])
    {
        string results[] = split(line);
        Z ~= to!(double)(results[Zindex]);
        T ~= to!(double)(results[Tindex]);
    }    
    
    // Now interpolate the exact solution onto the solution grid.
    auto liT = new LinearInterpolator!(double,double)(exactZ,exactT);
    
    double mapExactT[];
    foreach (elem; Z)
    {
        mapExactT ~= liT.interpolate(elem);
    }
    
    double sumOfSquaresT = 0;
    foreach (i, elem; mapExactT)
        sumOfSquaresT += pow((elem-T[i])/elem,2);
        
    double residualT = sqrt((1.0/Z.length)*sumOfSquaresT);
    
    writeln(Z.length," ",1.0/(Z.length)," ",residualT);
    return 0;

}
