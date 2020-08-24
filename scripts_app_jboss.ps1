echo "Aguardando para iniciar script"
Start-Sleep -Seconds 40
echo "Iniciando script"

    $conf = 'C:\jboss-6.0.0.Final\server\default\conf\sql.properties'
    $lib = 'C:\jboss-6.0.0.Final\server\default\lib\Util.jar'
    $deploy = 'C:\jboss-6.0.0.Final\server\default\deploy\App.ear'
    $tmp = 'C:\jboss-6.0.0.Final\server\default\tmp\'
    $work = 'C:\jboss-6.0.0.Final\server\default\work\'

    if((get-process "java" -ea SilentlyContinue) -eq $Null){ 
            echo "Not Running process" 
    }		

    else{ 
        echo "Running process"
        Stop-service -Name JBAS60SVC
        Start-Sleep -Seconds 40
        Stop-Process -processname "java" -force
	    
	}
    
 if ((Test-Path $conf)  -or (Test-Path $lib) -or (Test-Path $deploy) -or (Test-Path $tmp) -or (Test-Path $work))
			    { 
    
 
        if ((Test-Path $conf)  )
			        { 
					        echo "exists $conf"
					        Remove-Item $conf -Force -Recurse
                            echo "removed"	
			        }

		    else
			    { 
					    echo "not exists $conf"					  								
			     }
         
 
        if ((Test-Path $lib)  )
			        { 
					        echo "exists $lib"
					        Remove-Item $lib -Force -Recurse
                            echo "removed"
	
			        }

		    else
			    { 
					    echo "not exists $lib"					  								
			     }

    

        if ((Test-Path $deploy)  )
			        { 
					        echo "exists $deploy"
					        Remove-Item $deploy -Force -Recurse
                            echo "removed"
	
			        }

		    else
			    { 
					    echo "not exists $deploy"					  								
			     }		

        
             if ((Test-Path $tmp)  )
			        { 
					        echo "exists $tmp"
					        Remove-Item $tmp -Force -Recurse
                            echo "removed"
	
			        }

		    else
			    { 
					    echo "not exists $tmp"					  								
			     }
        		  
		
        if ((Test-Path $work)  )
			        { 
					        echo "exists $work"
					        Remove-Item $work -Force -Recurse
                            echo "removed"
	
			        }

		    else
			    { 
					    echo "not exists $work"					  								
			     }						
			     
  
					
	 }

		    else
			    { 
					    echo "not exists files"					  								
			     }				    

	
	 
echo "baixa arquivos"
gsutil cp -R gs://sistemas/Atualizacao/sql.properties C:\jboss-6.0.0.Final\server\default\conf\
gsutil cp -R gs://sistemas/Atualizacao/Util.jar C:\jboss-6.0.0.Final\server\default\lib\
gsutil cp -R gs://sistemas/Atualizacao/App.ear C:\jboss-6.0.0.Final\server\default\deploy\

Start-Sleep -Seconds 30


echo "Testando se o sistema iniciou com sucesso"
do{
[string] $url = 'http://localhost/index.html'
        function Get-WebStatus($url) {
            try {
                [net.httpWebRequest] $req = [net.webRequest]::create($url)
                $req.Method = "HEAD"
                [net.httpWebResponse] $res = $req.getResponse()
                if ($res.StatusCode -eq "200") {
                    echo "Iniciado com sucesso! retorno:  Ok 200"
                    pause
                } else {
                    echo "Está down $url"
                    start-service -Name JBAS60SVC
                    Start-Sleep -Seconds 100
                }
            } catch {
                echo "Nao foi possivel acessar $url"
                start-service -Name JBAS60SVC
                Start-Sleep -Seconds 100
            }
        }
Get-WebStatus $url
 } until ($HTTP_Status -ne "200")


echo "start Jboss"

Function startapp {
    Start-Sleep -Seconds 2
    start-service -Name JBAS60SVC}

startapp "&" Get-WebStatus $url