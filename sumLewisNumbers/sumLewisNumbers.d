#!/usr/bin/rdmd
// Read in Lewis numbers and calculate an average.
// Sum up columns, with species names as first row.
// Laurence R. McGlashan

import std.stdio;
import std.conv;
import std.file;
import std.string;
import std.math;
import std.xml;
import std.exception;

void writeXML(in double[string] Le)
{
    string fileName = "LewisNumbersInput.xml";

    enforce
    (
        !exists(fileName),
        text("File ",fileName," exists! Delete it first if you want to write a new one.")
    );
    
    auto doc = new Document(new Tag("Camflow"));
    auto Lewis = new Element("Lewis");
    foreach (name, value; Le)
    {
        auto speciesEntry = new Element("species", to!string(value));
        speciesEntry.tag.attr["name"] = to!string(name);
        Lewis ~= speciesEntry;
    }
    doc ~= Lewis;
    std.file.write(fileName, join(doc.pretty(3),"\n"));
}

void main(string[] args)
{

    writeln("Read in file ",args[1]);
    // Load in the file.
    string solutionFile = cast(string)read(args[1]);
    string[] solution = splitlines(solutionFile);
        
    string header[] = split(solution[0]);
    
    double[string] meanLe;
    double[string] sdLe;
    
    foreach (line; solution[1 .. $])
    {   
        string results[] = split(line);
        foreach (i, species; header[1 .. $])
        {
            meanLe[species] += to!(double)(results[i+1]);
        }
    }
    
    foreach (species; header[1 .. $])
        meanLe[species] /= (solution[1 .. $].length);

    foreach (line; solution[1 .. $])
    {   
        string results[] = split(line);
        foreach (i, species; header[1 .. $])
        {
            sdLe[species] += pow(to!(double)(results[i+1]) - meanLe[species],2.0);
        }
    }

    foreach (species; header[1 .. $])
    {
        sdLe[species] /= (solution[1 .. $].length);
        sdLe[species] = sqrt(sdLe[species]);
    }

    writefln("%7s %9s %19s","Species","Mean Le","Standard Deviation");
    foreach (species; header[1 .. $])
        writefln("%7s %9f %19f",species,meanLe[species],sdLe[species]);
        
    writeXML(meanLe);

}
