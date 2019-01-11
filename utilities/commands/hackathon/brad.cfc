/**
* 
**/
component {
   
    function run() {
        print.boldGreenLine( GetCWD() ).toConsole();
        var gitStatus = command('!git')
        .params( '-C "#GetCWD()#"', 'status' ) //request-pull
        .run(returnOutput=true);

        print.boldBlueLine( gitStatus ).toConsole();
        return;
    }
    
    
}