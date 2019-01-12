/**
* 
**/
component extends="commandbox.system.BaseCommand" {
   
    function run( required string action ) {
  
        var _response = "";

        switch( action ){
        	case "count":
	         _response = countFileLines( ARGUMENTS[2] );
	         break;
		    case "split":

				if( ArrayLen( ARGUMENTS ) < 4 )
					splitFile( ARGUMENTS[2], ARGUMENTS[3] );
				else
					splitFile( ARGUMENTS[2], ARGUMENTS[3], ARGUMENTS[4] );

				break;
			default: 
				print.boldRedLine( "Invalid Action!" ).toConsole();
				print.boldBlueLine( "Available actions [count, split]" ).toConsole();
				return;
        }

        print.boldBlueLine( _response ).toConsole();


        return;
    }


	private void function copyFile( required string filePath, required string newFilePath, numeric timeout = 1 ) {
		
		doExecute( name = "cp", args = ( ARGUMENTS.filePath & " " & ARGUMENTS.newFilePath ), timeout = ARGUMENTS.timeout );

	}

	private numeric function countFileLines( required string filePath ) {

		var count = ListFirst( doExecute( name="wc", args = "-l " & ARGUMENTS.filePath ), " " );

		return IsNumeric( count ) ? count + 1 : 0;

	}

	private void function deleteDirectory( required string directoryPath ) {
		
		doExecute( name = "rm", args = "-rf " & ARGUMENTS.directoryPath );

	}

	private string function getHeaderLines( required string filePath, numeric maxHeaderLine = 1, numeric timeout = 1 ) {

		return doExecute( name = "head", args = ( "-n " & ARGUMENTS.maxHeaderLine & " " & ARGUMENTS.filePath ), timeout = ARGUMENTS.timeout );

	}

	private string function touch( required string filePath ) {
		return doExecute( name = "touch", args = arguments.filePath );
	}
	
	

	private void function moveFile( required string filePath, required string newFilePath, numeric timeout = 1 ) {
		
		doExecute( name = "mv", args = ( ARGUMENTS.filePath & " " & ARGUMENTS.newFilePath ), timeout = ARGUMENTS.timeout );

	}

	private void function splitFile( required string filePath, required string splitDirectory, numeric linesPerFile = 3, boolean addFileExtension = true, numeric timeout = 60 ) {

		var extension = ( ARGUMENTS.addFileExtension && ListLen( ARGUMENTS.filePath, "." ) ) ? ListLast( ARGUMENTS.filePath, "." ) : "";

		var splitDir = Right( ARGUMENTS.splitDirectory, len( ARGUMENTS.splitDirectory ) - 1 ) != "/" ? ( ARGUMENTS.splitDirectory & "/" ) : ARGUMENTS.splitDirectory;

		if( !DirectoryExists( splitDir ) )
			DirectoryCreate( splitDir );

		doExecute( name = "split", args = ( "-l " & ARGUMENTS.linesPerFile & " " & ARGUMENTS.filePath & " " & splitDir ), timeout = ARGUMENTS.timeout );

		if( Len( extension ) ){

			var dirList = DirectoryList( splitDir, false, "path", "", "asc", "file" );

			var currentFile = ListLast( ARGUMENTS.filePath, "/" );
			var _row = 1;

			for( var _file in dirList ){
				
				if( ListLen( _file, "." ) > 1 )
					continue;
				else if( ListLast( _file, "/" ) != currentFile ){
					doExecute( name = "mv", args = ( _file & " " & _file & "." & extension ), timeout = ARGUMENTS.timeout );
					if( _row MOD 2 )
						print.greenOnBlackText( "File Created: " & _file & "." & extension & chr(10) & chr(13) ).toConsole();
					else
						print.whiteOnBlackText( "File Created: " & _file & "." & extension & chr(10) & chr(13) ).toConsole();

					_row++;
				}

			}

		}

	}

	private string function doExecute( required string name, required string args, numeric timeout = 1 ) {

		var _tmp = command("!"&ARGUMENTS.name)
        .params(  ARGUMENTS.args ) //request-pull
        .run(returnOutput=true);

		//cfexecute( name = ARGUMENTS.name, arguments = ARGUMENTS.args, variable = "_tmp", timeout = ARGUMENTS.timeout );
		
		return _tmp;

	}
    
    
}