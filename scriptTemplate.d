import std.stdio;

class ScriptTemplate
{
    
    string   programName;
    string[] options;
    string[] descriptions;
    
    this(string programName)
    {
        this.programName = programName;
    }
    
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

    bool parseArguments(string[] args)
    {

        foreach(arg; args[0 .. $])
        {
            if (arg=="-help")
            {
                printUsage();
                return 0;
            }
        }

        foreach(arg; args[0 .. $])
        {
            switch (arg)
            {
                case "-test","--test":
                    //test=true;
                    break;
                default:
                    writeln("Argument ",arg," not found");
                    printUsage();
                    return 0;
            }
        }
        return 1;

    }



}

