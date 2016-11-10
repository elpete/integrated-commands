/**
* Create a new Integrated Test in an existing ColdBox application.
* Make sure you are running this command in the root of your app.
*/
component {

    property name="moduleSettings" inject="commandbox:moduleSettings:integrated-commands";

    variables.types = {
        "coldbox" = "Integrated.BaseSpecs.ColdBoxBaseSpec"
    };

    /**
    * @name Name of the migration to create without the .cfc.
    * @type.hint The base spec to extend from
    * @type.optionsUDF completeTypes
    * @directory The base directory to create your migration in. Creates the directory if it does not exist.
    * @open Open the file once generated
    */
    function run(
        required string name,
        string type = "coldbox",
        string directory = moduleSettings.defaultSpecDirectory,
        boolean open = false
    ) {
        // This will make each directory canonical and absolute
        arguments.directory = fileSystemUtil.resolvePath( arguments.directory );

        // Validate directory
        if( !directoryExists( arguments.directory ) ) {
            directoryCreate( arguments.directory );
        }

        var specPath = "#arguments.directory#/#arguments.name#.cfc";

        var specContent = fileRead( fileSystemUtil.resolvePath( moduleSettings.templatePath ) );
        specContent = replaceNoCase( specContent, "{{type}}", typeToSpecPath( arguments.type ) );

        file action="write" file="#specPath#" mode="777" output="#trim( specContent )#";

        print.greenLine( "Created #specPath#" );

        // Open file?
        if ( arguments.open ) {
            openPath( specPath );
        }

        return;
    }

    function completeTypes() {
        return variables.types.keyArray();
    }

    private function typeToSpecPath( required string type ) {
        if ( ! variables.types.keyExists( type ) ) {
            error( "Type not recongnized. Available types are: #variables.types.keyList(', ')#" );
        }
        return variables.types[ type ];
    }

}