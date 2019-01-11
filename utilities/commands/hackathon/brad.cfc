/**
* 
**/
component {
   
    function run() {
        print.boldGreenLine( GetCWD() ).toConsole();
        var gitStatus = command('!git')
        .params( '-C "#GetCWD()#"', 'status' )
        .run(returnOutput=true);

        print.boldBlueLine( gitStatus ).toConsole();
        return;
    }
    
    
}