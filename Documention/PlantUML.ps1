
$WorkingDirectory = "$env:UserProfile\Documents\GitHub\Batch-Tools-SysAdmin\Documention"

$java_path = "C:\Program Files\AdoptOpenJDK\jre-13.0.1.9-hotspot\bin"
$java_filepath = "$java_path\java.exe"
#$java_filepath = "$java_path\javaw.exe"

$plantuml_gui_shortcut = '"C:\Program Files\AdoptOpenJDK\jre-13.0.1.9-hotspot\bin\javaw.exe" -Dfile.encoding=UTF-8 -jar "C:\ProgramData\chocolatey\lib\plantuml\tools\plantuml.jar"'

$plantuml_path = "C:\ProgramData\chocolatey\lib\plantuml\tools\plantuml.jar"
$plantuml_path = "$env:ChocolateyInstall\lib\plantuml\tools\plantuml.jar"

$input_image = "$env:UserProfile\Documents\GitHub\Batch-Tools-SysAdmin\Documention\networking_icons\wifi-signal-symbol_square-bars_015px.png"
$input_image = "$env:UserProfile\Documents\GitHub\Batch-Tools-SysAdmin\Documention\networking_icons\wifi-signal-symbol_square-bars_015px_white-bkgd.png"

#http://plantuml.com/guide
# 17 Defining and using sprites
# 17.1 Encoding Sprite
#java -jar plantuml.jar -encodesprite 16z foo.png

#java -jar plantuml.jar -encodesprite 16z "networking_icons\wifi-signal-symbol_square-bars_015px.png"
#$java_filepath -jar $plantuml_path -encodesprite 16z $input_image
#Invoke-Command -FilePath "$java_filepath" -ArgumentList "-jar $plantuml_path -encodesprite 16 $input_image"

#java -jar $plantuml_path -encodesprite 16 "networking_icons\wifi-signal-symbol_square-bars_015px_white-bkgd.png"

CD $WorkingDirectory

Invoke-Expression "java -jar $plantuml_path -encodesprite 16 `"networking_icons\wifi-signal-symbol_square-bars_015px_white-bkgd.png`""
