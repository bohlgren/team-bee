/**
* 
**/
component {
   
    function run() {

        var currentPath = GetCWD();

        print.magentaLine( "Working in #currentPath#" ).toConsole();
        
        var branchName = command('!git')
            .params('rev-parse --abbrev-ref HEAD')
            .run(returnOutput=true);

        print.cyanLine( "Branch is #branchName#" ).toConsole();

        var gitStatus = command('!git')
            .params( '-C "#GetCWD()#"', 'status' ) //request-pull
            .run(returnOutput=true);
        
        print.greenLine( "Branch Status:" ).toConsole();
        print.blueLine( gitStatus ).toConsole();

        var gitChanges = command('!git')
            .params( 'request-pull origin/master https://github.com/bohlgren/team-bee #branchName#')
            .run(returnOutput=true);

        print.greenLine( "Differences compared to master:" ).toConsole();
        print.blueLine( gitChanges ).toConsole();
        return;
    }
    
}