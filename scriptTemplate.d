#!/usr/bin/rdmd

import std.stdio;
import std.process;

class ScriptTemplate
{
    
    string   programName;
    string[] options;
    string[] descriptions;
    
    this(string programName)
    {this.programName = programName;}
    
    void addOption(string name, string description)
    {
        this.options ~= name;
        this.descriptions ~= description;
    }
        
    void printUsage()
    {
        writeln("usage: ",programName," [OPTION]",'\n');
        writeln("options:\n");
        foreach(int arg; 0 .. options.length)
        {
            writeln("   -",options[arg],'\t',descriptions[arg]);
        }
    }

}

void main(string[] args)
{

    auto script = new ScriptTemplate(args[0]);

    script.addOption("test","Run Make and test running");
    script.addOption("help","This help message");
    
    bool test = false;

    foreach(arg; args[1 .. $])
    {
        if (arg=="-help")
        {
            script.printUsage();
            return;
        }
    }

    foreach(arg; args[1 .. $])
    {
        switch (arg)
        {
            case "-test","--test":
                test=true;
                break;
            default:
                writeln("Argument not found");
                script.printUsage();
                return;
        }
    }
    
    writeln("Configuring local git settings.");
    system("cp -f .gitconfig .git/config");
    
    if (test)
    {
        writeln("Make all libraries in release mode.");
        system("./etc/makeAllLibs.sh");
        system("./etc/makeDocs.sh");
        writeln("Run camflow in release mode.");
        int runTest = system("./etc/runCamflow.sh");
        if (runTest)
        {
            writeln("Running CamFlow failed.");
            return;
        }
        writeln("Install Successful.");
    }
    
}
