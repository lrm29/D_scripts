#!/usr/bin/rdmd

import std.stdio;
import std.process;
import scriptTemplate;

void main(string[] args)
{

    auto script = new ScriptTemplate(args[0]);

/* Start: Add Options to Script */

    script.addOption("test","Run Make and test running");
    script.addOption("help","This help message");

/* End: Add Options to Script */
    
    if(!script.parseArguments(args[1 .. $])) {return;}

/* Start: Script */

    bool test = false;
    
    writeln("Configuring local git settings.");
    shell("cp -f .gitconfig .git/config");
    
    if (test)
    {
        writeln("Make all libraries in release mode.");
        shell("./etc/makeAllLibs.sh");
        shell("./etc/makeDocs.sh");
        writeln("Run camflow in release mode.");
        string runTest = shell("./etc/runCamflow.sh");
        if (runTest)
        {
            writeln("Running CamFlow failed.");
            return;
        }
        writeln("Install Successful.");
    }

/* End: Script */
    
}
