
REM -------------------------------------------------------------------------------

::ECHO DEBUGGING: Begin DefineFunctions block.

::Index of functions: 
:: 1. :DisplayHelp
:: 2. :GetTerminalWidth
:: 3. :StrLen
:: 4. :GenerateBlankSpace
:: 5. :FormatTextLine
:: 6. :SplashLogoKdiff
:: 7. :SplashLogoMergeComplete

GOTO SkipFunctions
:: Declare Functions
:DefineFunctions
:-------------------------------------------------------------------------------
:DisplayHelp
::CALL :DisplayHelp
:: Display help splash text.
@ECHO OFF
SETLOCAL
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::C:\Users\[Username]>ipconfig /?
::
::USAGE:
::    ipconfig [/allcompartments] [/? | /all |
::                                 /renew [adapter] | /release [adapter] |
::                                 /renew6 [adapter] | /release6 [adapter] |
::                                 /flushdns | /displaydns | /registerdns |
::                                 /showclassid adapter |
::                                 /setclassid adapter [classid] |
::                                 /showclassid6 adapter |
::                                 /setclassid6 adapter [classid] ]
::
::where
::    adapter             Connection name
::                       (wildcard characters * and ? allowed, see examples)
::
::    Options:
::       /?               Display this help message
::       /all             Display full configuration information.
::       /release         Release the IPv4 address for the specified adapter.
::       /release6        Release the IPv6 address for the specified adapter.
::       /renew           Renew the IPv4 address for the specified adapter.
::       /renew6          Renew the IPv6 address for the specified adapter.
::       /flushdns        Purges the DNS Resolver cache.
::       /registerdns     Refreshes all DHCP leases and re-registers DNS names
::       /displaydns      Display the contents of the DNS Resolver Cache.
::       /showclassid     Displays all the dhcp class IDs allowed for adapter.
::       /setclassid      Modifies the dhcp class id.
::       /showclassid6    Displays all the IPv6 DHCP class IDs allowed for adapter.
::       /setclassid6     Modifies the IPv6 DHCP class id.
::
::
::The default is to display only the IP address, subnet mask and
::default gateway for each adapter bound to TCP/IP.
::
::For Release and Renew, if no adapter name is specified, then the IP address
::leases for all adapters bound to TCP/IP will be released or renewed.
::
::For Setclassid and Setclassid6, if no ClassId is specified, then the ClassId is removed.
::
::Examples:
::    > ipconfig                       ... Show information
::    > ipconfig /all                  ... Show detailed information
::    > ipconfig /renew                ... renew all adapters
::    > ipconfig /renew EL*            ... renew any connection that has its
::                                         name starting with EL
::    > ipconfig /release *Con*        ... release all matching connections,
::                                         eg. "Wired Ethernet Connection 1" or
::                                             "Wired Ethernet Connection 2"
::    > ipconfig /allcompartments      ... Show information about all
::                                         compartments
::    > ipconfig /allcompartments /all ... Show detailed information about all
::                                         compartments
::
::C:\Users\[Username]>_
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::C:\Users\[Username]>tracert /?
::
::Usage: tracert [-d] [-h maximum_hops] [-j host-list] [-w timeout]
::               [-R] [-S srcaddr] [-4] [-6] target_name
::
::Options:
::    -d                 Do not resolve addresses to hostnames.
::    -h maximum_hops    Maximum number of hops to search for target.
::    -j host-list       Loose source route along host-list (IPv4-only).
::    -w timeout         Wait timeout milliseconds for each reply.
::    -R                 Trace round-trip path (IPv6-only).
::    -S srcaddr         Source address to use (IPv6-only).
::    -4                 Force using IPv4.
::    -6                 Force using IPv6.
::
::C:\Users\[Username]>_
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::ECHO:
::ECHO ===============================================================================
::ECHO %~nx0 Help.
::ECHO:
::ECHO Called from: "%~dp0"
::ECHO:
::ECHO - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ECHO:
ECHO USAGE: .\%~nx0 "path_to_file_a" "path_to_file_b" [banner]
ECHO:
ECHO where
ECHO     banner      =       QUIET - for minimal output
ECHO                         SIMPLE - for a small banner during start.
ECHO                         FANCY - for a custom banner during start ^& end.
ECHO                        (If no option is selected, the default is FANCY.)
ECHO:
::ECHO OPTIONS:
::ECHO:
ECHO Uses kdiff3 to merge changes between two different files or folders.
ECHO Paramters can be passed via command line or hard-coded into this script.
ECHO If no parameters are provided, default is to use hard-coded variables.
ECHO:
ECHO You may also drag-and-drop files on this script one at a time.
ECHO:
ECHO EXAMPLES:
ECHO     > .\%~nx0 "^%USERPROFILE^%\Documents\file_1.txt" "^%USERPROFILE^%\Dropbox\file_1.txt"
ECHO:
ECHO     > .\%~nx0 "^%USERPROFILE^%\Documents\Folder1" "^%USERPROFILE^%\Dropbox\Folder1" fancy
ECHO:
ECHO     > .\%~nx0 "^%USERPROFILE^%\Desktop\file_2.json" "^%USERPROFILE^%\Dropbox\file_2.json" quiet
ECHO:
::ECHO     > ipconfig                       ... Show information
::ECHO     > ipconfig /all                  ... Show detailed information
::ECHO     > ipconfig /renew                ... renew all adapters
::ECHO     > ipconfig /renew EL*            ... renew any connection that has its
::ECHO                                          name starting with EL
::ECHO     > ipconfig /release *Con*        ... release all matching connections,
::ECHO                                          eg. "Wired Ethernet Connection 1" or
::ECHO                                              "Wired Ethernet Connection 2"
::ECHO     > ipconfig /allcompartments      ... Show information about all
::ECHO                                          compartments
::ECHO     > ipconfig /allcompartments /all ... Show detailed information about all
::ECHO                                          compartments
::ECHO 
::ECHO EXAMPLE:
::ECHO .\%~nx0 "path_to_file_a" "path_to_file_b" [BANNER]
::ECHO:
::ECHO PARAMETERS:
::ECHO    "path_to_file_a"   - Full file path pointing to the first file.
::ECHO    "path_to_file_b"   - Full file path pointing to the second file.
::ECHO    [BANNER]           - If no option is selected, the default is FANCY.
::ECHO                           + QUIET - for minimal output
::ECHO                           + SIMPLE - for a small banner during start.
::ECHO                           + FANCY - for a custom banner during start ^& end.
::ECHO - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ECHO:
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ENDLOCAL
EXIT /B
:-------------------------------------------------------------------------------
:GetTerminalWidth
::CALL :GetTerminalWidth
:: Get width in characters the current terminal (Command Prompt) is.
:: Thanks to:
:: https://ss64.com/nt/syntax-banner.html
:: Outputs:
:: "%_MAX_WINDOW_WIDTH%" Maximum length for a string e.g. "79" (CMD.EXE) or "119" (PowerShell)
:: "%_TRUE_WINDOW_WIDTH%" Actual terminal window width e.g. "80" (CMD.EXE) or "120" (PowerShell)
@ECHO OFF
SETLOCAL
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
FOR /F "tokens=2" %%G IN ('mode ^|find "Columns"') DO SET /A _WINDOW_WIDTH=%%G
SET /A "_WINDOW_WIDTH_NO_NEWLINE=%_WINDOW_WIDTH%-1"
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ENDLOCAL & SET "_MAX_WINDOW_WIDTH=%_WINDOW_WIDTH_NO_NEWLINE%" & SET "_TRUE_WINDOW_WIDTH=%_WINDOW_WIDTH%"
EXIT /B
:-------------------------------------------------------------------------------
:StrLen  StrVar  [RtnVar]
::CALL :StrLen "%_INPUT_STRING%" _STR_LEN_RTN
::ECHO %_STR_LEN_RTN%
:: Thanks to dbenham from StackOverflow:
::https://stackoverflow.com/questions/5837418/how-do-you-get-the-string-length-in-a-batch-file#5841587
::
:: Computes the length of string in variable StrVar
:: and stores the result in variable RtnVar.
:: If RtnVar is is not specified, then prints the length to stdout.
::
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(
  SETLOCAL EnableDelayedExpansion
  SET "s=A!%~1!"
  SET "len=0"
  FOR %%P IN (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) DO (
    IF "!s:~%%P,1!" NEQ "" (
      SET /A "len+=%%P"
      SET "s=!s:~%%P!"
    )
  )
)
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(
  ENDLOCAL
  IF "%~2" EQU "" (ECHO %len%) ELSE SET "%~2=%len%"
  EXIT /B
)
:-------------------------------------------------------------------------------
:GenerateBlankSpace NumberOfBlankSpaces
::CALL :GenerateBlankSpace "%_NUM_BLANK_LEN%"
::ECHO %_BLANK_SPACE%#
::ECHO 1234567890123456789012345678901234567890123456789012345678901234567890123456789
::ECHO 0        1         2         3         4         5         6         7         
::ECHO -------------------------------------------------------------------------------
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@ECHO OFF
SETLOCAL
SET "_INPUT_INT=%~1"
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
:: Check if input parameter exists.
IF [%_INPUT_INT%]==[] ECHO Function :GenerateBlankSpace requires an integer input paramter. & ENDLOCAL & EXIT /B
:: Check if input parameter is a number.
SET "_INT_TEST="&FOR /F "delims=0123456789" %%G IN ("%_INPUT_INT%") DO SET "_INT_TEST=%%G"
IF DEFINED _INT_TEST (
	REM ECHO %_INPUT_INT% is NOT numeric
	ECHO Function :GenerateBlankSpace requires an integer input paramter. & ENDLOCAL & EXIT /B
) ELSE (
	REM sECHO %_INPUT_INT% is numeric
)
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
SET "_OUTPUT_STRING="
::https://ss64.com/nt/for_l.html
FOR /L %%G IN (1,1,%_INPUT_INT%) DO SET "_OUTPUT_STRING=%_OUTPUT_STRING% "
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ENDLOCAL & SET "_BLANK_SPACE=%_OUTPUT_STRING%"
EXIT /B
::GOTO :EOF
:-------------------------------------------------------------------------------
:FormatTextLine InputText [PrefixBlankSpaces] [PrefixBorderCharacter] [SuffixBorderCharacter]
::CALL :FormatTextLine "%_TEXT_IN_BOX%" 2 ^( ^)
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@ECHO OFF
SETLOCAL
SET "_TEXTBODY=%~1"
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
IF /I [%~2]==[] (
	REM Default to 1 blank prefix space if none defined`
	SET "_PREFIX_BLANK=1"
) ELSE (
	SET "_PREFIX_BLANK=%~2"
)
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
:: Check if border character input parameter(s) were supplied
IF /I [%~3]==[] (
	REM No parameter 3 or 4, so set | as the default border character
	SET "_PREFIX_CHAR=^|"
	SET "_SUFFIX_CHAR=^|"
) ELSE (
	IF /I [%~4]==[] (
		REM Parameter 3 is present, but parameter 4 is not.
		REM Set both characters to the same.
		SET "_PREFIX_CHAR=%~3"
		SET "_SUFFIX_CHAR=%~3"
	) ELSE ( 
		REM Both paramter 3 and 4 are present, use what is provided.
		SET "_PREFIX_CHAR=%~3"
		SET "_SUFFIX_CHAR=%~4"
	)
)
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ENDLOCAL & SET "_BLANK_SPACE=%_OUTPUT_STRING%"
EXIT /B
::GOTO :EOF
:-------------------------------------------------------------------------------
:SplashLogoKdiff
::CALL :SplashLogoKdiff
:: For source see "kdiff-ascii-text.bat"
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@ECHO OFF
::SETLOCAL
::patorjk.com
::ECHO Font Name: Big Money-nw
::ECHO -------------------------------------------------------------------------------
::ECHO $$\             $$\ $$\  $$$$$$\   $$$$$$\    
::ECHO $$ |            $$ |\__|$$  __$$\ $$  __$$\   
::ECHO $$ |  $$\  $$$$$$$ |$$\ $$ /  \__|$$ /  \__|  
::ECHO $$ | $$  |$$  __$$ |$$ |$$$$\     $$$$\       
::ECHO $$$$$$  / $$ /  $$ |$$ |$$  _|    $$  _|      
::ECHO $$  _$$<  $$ |  $$ |$$ |$$ |      $$ |        
::ECHO $$ | \$$\ \$$$$$$$ |$$ |$$ |      $$ |        
::ECHO \__|  \__| \_______|\__|\__|      \__|        
::ECHO -------------------------------------------------------------------------------
:: Replace:
:: 		|	with	^|
:: 		<	with	^<
::ECHO -------------------------------------------------------------------------------
ECHO $$\             $$\ $$\  $$$$$$\   $$$$$$\    
ECHO $$ ^|            $$ ^|\__^|$$  __$$\ $$  __$$\   
ECHO $$ ^|  $$\  $$$$$$$ ^|$$\ $$ /  \__^|$$ /  \__^|  
ECHO $$ ^| $$  ^|$$  __$$ ^|$$ ^|$$$$\     $$$$\       
ECHO $$$$$$  / $$ /  $$ ^|$$ ^|$$  _^|    $$  _^|      
ECHO $$  _$$^<  $$ ^|  $$ ^|$$ ^|$$ ^|      $$ ^|        
ECHO $$ ^| \$$\ \$$$$$$$ ^|$$ ^|$$ ^|      $$ ^|        
ECHO \__^|  \__^| \_______^|\__^|\__^|      \__^|        
::ECHO -------------------------------------------------------------------------------
::PAUSE
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::ENDLOCAL
EXIT /B
::GOTO :EOF
:-------------------------------------------------------------------------------
:SplashLogoMergeComplete
::CALL :SplashLogoMergeComplete
:: For source see "merge-ascii-test.bat" and "merge-ascii-test.txt"
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
@ECHO OFF
::SETLOCAL
::patorjk.com
::Font Name: Crazy
::ECHO      __  __   ___         __.....__                           __.....__       #
::ECHO     |  |/  `.'   `.   .-''         '.             .--./)  .-''         '.     #
::ECHO     |   .-.  .-.   ' /     .-''"'-.  `. .-,.--.  /.''\\  /     .-''"'-.  `.   #
::ECHO     |  |  |  |  |  |/     /________\   \|  .-. || |  | |/     /________\   \  #
::ECHO     |  |  |  |  |  ||                  || |  | | \`-' / |                  |  #
::ECHO     |  |  |  |  |  |\    .-------------'| |  | | /("'`  \    .-------------'  #
::ECHO     |  |  |  |  |  | \    '-.____...---.| |  '-  \ '---. \    '-.____...---.  #
::ECHO     |__|  |__|  |__|  `.             .' | |       /'""'.\ `.             .'   #
::ECHO                         `''-...... -'   | |      ||     ||  `''-...... -'     #
::ECHO                                         |_|      \'. __//                     #
::ECHO                                                   `'---'                      #
:: Original artwork:
::ECHO         *                                      ,                              #
::ECHO       (  `                                    (                          )    #
::ECHO       )\))(     (   (    (  (     (            \                        /     #
::ECHO      ((_)()\   ))\  )(   )\))(   ))\          ,' ,__,___,__,-._         )     #
::ECHO      (_()((_) /((_)(()\ ((_))\  /((_)         )-' ,    ,  , , (        /      #
::ECHO      |  \/  |(_))   ((_) (()(_)(_))           ;'"-^-.,-''"""\' \       )      #
::ECHO      | |\/| |/ -_) | '_|/ _` | / -_)         (      (        ) /  __  /       #
::ECHO      |_|  |_|\___| |_|  \__, | \___|          \o,----.  o  _,'( ,.^. \        #
::ECHO                         |___/                 ,'`.__  `---'    `\ \ \ \_      #
::ECHO                                        ,.,. ,'                   \    ' )     #
::ECHO                                        \ \ \\__  ,------------.  /     /      #
::ECHO                                       ( \ \ \( `---.-`-^--,-,--\:     :       #
::ECHO                                        \       (   (""""""`----'|     : -hrr- #
::ECHO                                         \   `.  \   `.          |      \      #
::ECHO                                          \   ;  ;     )      __ _\      \     #
::ECHO                                          /     /    ,-.,-.'"Y  Y  \      `.   #
::ECHO                                         /     :    ,`-'`-'`-'`-'`-'\       `. #
::ECHO                                        /      ;  ,'  /              \        `#
::ECHO                                       /      / ,'   /                \        #
::Font Name: Big
::ECHO              _____ ____  __  __ _____  _      ______ _______ ______           #
::ECHO             / ____/ __ \|  \/  |  __ \| |    |  ____|__   __|  ____|          #
::ECHO            | |   | |  | | \  / | |__) | |    | |__     | |  | |__             #
::ECHO            | |   | |  | | |\/| |  ___/| |    |  __|    | |  |  __|            #
::ECHO            | |___| |__| | |  | | |    | |____| |____   | |  | |____           #
::ECHO             \_____\____/|_|  |_|_|    |______|______|  |_|  |______|          #

::Font Name: Fire Font-k
::ECHO         *                             #
::ECHO       (  `                            #
::ECHO       )\))(     (   (    (  (     (   #
::ECHO      ((_)()\   ))\  )(   )\))(   ))\  #
::ECHO      (_()((_) /((_)(()\ ((_))\  /((_) #
::ECHO      |  \/  |(_))   ((_) (()(_)(_))   #
::ECHO      | |\/| |/ -_) | '_|/ _` | / -_)  #
::ECHO      |_|  |_|\___| |_|  \__, | \___|  #
::ECHO                         |___/         #
::ECHO:
::ECHO         *                             #
::ECHO       (  `                            #
::ECHO       )\))(     (   (    (  (     (   #
::ECHO      ((_)()\   ))\  )(   )\))(   ))\  #
::ECHO      (_()((_) /((_)(()\ ((_))\  /((_) #
::ECHO      ^|  \/  ^|(_))   ((_) (()(_)(_))   #
::ECHO      ^| ^|\/^| ^|/ -_) ^| '_^|/ _` ^| / -_)  #
::ECHO      ^|_^|  ^|_^|\___^| ^|_^|  \__, ^| \___^|  #
::ECHO                         ^|___/         #
::ECHO:
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::ECHO      __  __   ___         __.....__                           __.....__       #
::ECHO     ^|  ^|/  `.'   `.   .-''         '.             .--./)  .-''         '.     #
::ECHO     ^|   .-.  .-.   ' /     .-''"'-.  `. .-,.--.  /.''\\  /     .-''"'-.  `.   #
::ECHO     ^|  ^|  ^|  ^|  ^|  ^|/     /________\   \^|  .-. ^|^| ^|  ^| ^|/     /________\   \  #
::ECHO     ^|  ^|  ^|  ^|  ^|  ^|^|                  ^|^| ^|  ^| ^| \`-' / ^|                  ^|  #
::ECHO     ^|  ^|  ^|  ^|  ^|  ^|\    .-------------'^| ^|  ^| ^| /("'`  \    .-------------'  #
::ECHO     ^|  ^|  ^|  ^|  ^|  ^| \    '-.____...---.^| ^|  '-  \ '---. \    '-.____...---.  #
::ECHO     ^|__^|  ^|__^|  ^|__^|  `.             .' ^| ^|       /'""'.\ `.             .'   #
::ECHO                         `''-...... -'   ^| ^|      ^|^|     ^|^|  `''-...... -'     #
::ECHO                                         ^|_^|      \'. __//                     #
::ECHO                                                   `'---'                      #
ECHO         *                                      ,                              #
ECHO       (  `                                    (                          )    #
ECHO       )\))(     (   (    (  (     (            \                        /     #
ECHO      ((_)()\   ))\  )(   )\))(   ))\          ,' ,__,___,__,-._         )     #
ECHO      (_()((_) /((_)(()\ ((_))\  /((_)         )-' ,    ,  , , (        /      #
::ECHO      ^|  \/  ^|(_))   ((_) (()(_)(_))           ;'"-^^-.,-''"""\' \       )      #
ECHO      ^|  \/  ^|(_))   ((_) (()(_)(_))           ;'"-^-.,-''"""\' \       )      #
ECHO      ^| ^|\/^| ^|/ -_) ^| '_^|/ _` ^| / -_)         (      (        ) /  __  /       #
ECHO      ^|_^|  ^|_^|\___^| ^|_^|  \__, ^| \___^|          \o,----.  o  _,'( ,.^^. \        #
ECHO                         ^|___/                 ,'`.__  `---'    `\ \ \ \_      #
ECHO                                        ,.,. ,'                   \    ' )     #
ECHO                                        \ \ \\__  ,------------.  /     /      #
ECHO                                       ( \ \ \( `---.-`-^^--,-,--\:     :       #
ECHO                                        \       (   (""""""`----'^|     : -hrr- #
ECHO                                         \   `.  \   `.          ^|      \      #
ECHO                                          \   ;  ;     )      __ _\      \     #
ECHO                                          /     /    ,-.,-.'"Y  Y  \      `.   #
ECHO                                         /     :    ,`-'`-'`-'`-'`-'\       `. #
ECHO                                        /      ;  ,'  /              \        `#
ECHO                                       /      / ,'   /                \        #
ECHO              _____ ____  __  __ _____  _      ______ _______ ______           #
ECHO             / ____/ __ \^|  \/  ^|  __ \^| ^|    ^|  ____^|__   __^|  ____^|          #
ECHO            ^| ^|   ^| ^|  ^| ^| \  / ^| ^|__) ^| ^|    ^| ^|__     ^| ^|  ^| ^|__             #
ECHO            ^| ^|   ^| ^|  ^| ^| ^|\/^| ^|  ___/^| ^|    ^|  __^|    ^| ^|  ^|  __^|            #
ECHO            ^| ^|___^| ^|__^| ^| ^|  ^| ^| ^|    ^| ^|____^| ^|____   ^| ^|  ^| ^|____           #
ECHO             \_____\____/^|_^|  ^|_^|_^|    ^|______^|______^|  ^|_^|  ^|______^|          #
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::ECHO      __  __   ___         __.....__                           __.....__       #
::ECHO     |  |/  `.'   `.   .-''         '.             .--./)  .-''         '.     #
::ECHO     |   .-.  .-.   ' /     .-''"'-.  `. .-,.--.  /.''\\  /     .-''"'-.  `.   #
::ECHO     |  |  |  |  |  |/     /________\   \|  .-. || |  | |/     /________\   \  #
::ECHO     |  |  |  |  |  ||                  || |  | | \`-' / |                  |  #
::ECHO     |  |  |  |  |  |\    .-------------'| |  | | /("'`  \    .-------------'  #
::ECHO     |  |  |  |  |  | \    '-.____...---.| |  '-  \ '---. \    '-.____...---.  #
::ECHO     |__|  |__|  |__|  `.             .' | |       /'""'.\ `.             .'   #
::ECHO                         `''-...... -'   | |      ||     ||  `''-...... -'     #
::ECHO         *                               |_|    , \'. __//                     #
::ECHO       (  `                                    (   `'---'                 )    #
::ECHO       )\))(     (   (    (  (     (            \                        /     #
::ECHO      ((_)()\   ))\  )(   )\))(   ))\          ,' ,__,___,__,-._         )     #
::ECHO      (_()((_) /((_)(()\ ((_))\  /((_)         )-' ,    ,  , , (        /      #
::ECHO      |  \/  |(_))   ((_) (()(_)(_))           ;'"-^-.,-''"""\' \       )      #
::ECHO      | |\/| |/ -_) | '_|/ _` | / -_)         (      (        ) /  __  /       #
::ECHO      |_|  |_|\___| |_|  \__, | \___|          \o,----.  o  _,'( ,.^. \        #
::ECHO                         |___/                 ,'`.__  `---'    `\ \ \ \_      #
::ECHO                                        ,.,. ,'                   \    ' )     #
::ECHO                                        \ \ \\__  ,------------.  /     /      #
::ECHO                                       ( \ \ \( `---.-`-^--,-,--\:     :       #
::ECHO                                        \       (   (""""""`----'|     : -hrr- #
::ECHO                                         \   `.  \   `.          |      \      #
::ECHO                                          \   ;  ;     )      __ _\      \     #
::ECHO                                          /     /    ,-.,-.'"Y  Y  \      `.   #
::ECHO                                         /     :    ,`-'`-'`-'`-'`-'\       `. #
::ECHO                                        /      ;  ,'  /              \        `#
::ECHO              _____ ____  __  __ _____ /_     /__'___/_______ ______  \        #
::ECHO             / ____/ __ \|  \/  |  __ \| |    |  ____|__   __|  ____|          #
::ECHO            | |   | |  | | \  / | |__) | |    | |__     | |  | |__             #
::ECHO            | |   | |  | | |\/| |  ___/| |    |  __|    | |  |  __|            #
::ECHO            | |___| |__| | |  | | |    | |____| |____   | |  | |____           #
::ECHO             \_____\____/|_|  |_|_|    |______|______|  |_|  |______|          #
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::ECHO      __  __   ___         __.....__                           __.....__       #
::ECHO     ^|  ^|/  `.'   `.   .-''         '.             .--./)  .-''         '.     #
::ECHO     ^|   .-.  .-.   ' /     .-''"'-.  `. .-,.--.  /.''\\  /     .-''"'-.  `.   #
::ECHO     ^|  ^|  ^|  ^|  ^|  ^|/     /________\   \^|  .-. ^|^| ^|  ^| ^|/     /________\   \  #
::ECHO     ^|  ^|  ^|  ^|  ^|  ^|^|                  ^|^| ^|  ^| ^| \`-' / ^|                  ^|  #
::ECHO     ^|  ^|  ^|  ^|  ^|  ^|\    .-------------'^| ^|  ^| ^| /("'`  \    .-------------'  #
::ECHO     ^|  ^|  ^|  ^|  ^|  ^| \    '-.____...---.^| ^|  '-  \ '---. \    '-.____...---.  #
::ECHO     ^|__^|  ^|__^|  ^|__^|  `.             .' ^| ^|       /'""'.\ `.             .'   #
::ECHO                         `''-...... -'   ^| ^|      ^|^|     ^|^|  `''-...... -'     #
::ECHO         *                               ^|_^|    , \'. __//                     #
::ECHO       (  `                                    (   `'---'                 )    #
::ECHO       )\))(     (   (    (  (     (            \                        /     #
::ECHO      ((_)()\   ))\  )(   )\))(   ))\          ,' ,__,___,__,-._         )     #
::ECHO      (_()((_) /((_)(()\ ((_))\  /((_)         )-' ,    ,  , , (        /      #
::::ECHO      ^|  \/  ^|(_))   ((_) (()(_)(_))           ;'"-^^-.,-''"""\' \       )      #
::ECHO      ^|  \/  ^|(_))   ((_) (()(_)(_))           ;'"-^-.,-''"""\' \       )      #
::ECHO      ^| ^|\/^| ^|/ -_) ^| '_^|/ _` ^| / -_)         (      (        ) /  __  /       #
::ECHO      ^|_^|  ^|_^|\___^| ^|_^|  \__, ^| \___^|          \o,----.  o  _,'( ,.^^. \        #
::ECHO                         ^|___/                 ,'`.__  `---'    `\ \ \ \_      #
::ECHO                                        ,.,. ,'                   \    ' )     #
::ECHO                                        \ \ \\__  ,------------.  /     /      #
::ECHO                                       ( \ \ \( `---.-`-^^--,-,--\:     :       #
::ECHO                                        \       (   (""""""`----'^|     : -hrr- #
::ECHO                                         \   `.  \   `.          ^|      \      #
::ECHO                                          \   ;  ;     )      __ _\      \     #
::ECHO                                          /     /    ,-.,-.'"Y  Y  \      `.   #
::ECHO                                         /     :    ,`-'`-'`-'`-'`-'\       `. #
::ECHO                                        /      ;  ,'  /              \        `#
::ECHO              _____ ____  __  __ _____ /_     /__'___/_______ ______  \        #
::ECHO             / ____/ __ \^|  \/  ^|  __ \^| ^|    ^|  ____^|__   __^|  ____^|          #
::ECHO            ^| ^|   ^| ^|  ^| ^| \  / ^| ^|__) ^| ^|    ^| ^|__     ^| ^|  ^| ^|__             #
::ECHO            ^| ^|   ^| ^|  ^| ^| ^|\/^| ^|  ___/^| ^|    ^|  __^|    ^| ^|  ^|  __^|            #
::ECHO            ^| ^|___^| ^|__^| ^| ^|  ^| ^| ^|    ^| ^|____^| ^|____   ^| ^|  ^| ^|____           #
::ECHO             \_____\____/^|_^|  ^|_^|_^|    ^|______^|______^|  ^|_^|  ^|______^|          #
:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
::ENDLOCAL
EXIT /B
::GOTO :EOF
:-------------------------------------------------------------------------------
:: End functions
:SkipFunctions
