# Check if appcmd.exe exists in default path
if (Test-Path  ("c:\windows\system32\inetsrv\appcmd.exe")) {    

	# Set AppCmd.exe path in variable for further usage.
    $AppCmdPath = 'c:\windows\system32\inetsrv\appcmd.exe'
	
    # Get list of application pools
    & $AppCmdPath list apppools /text:name | 
        ForEach-Object { 
                    
        #Get application pool name
        $PoolName = $_
        
        #Exclude inbuild Application Pools
        if(
        $PoolName -eq "DefaultAppPool" -Or 
        $PoolName -eq "Classic .NET AppPool" -Or 
        $PoolName -eq ".NET v2.0 Classic"-Or
        $PoolName -eq ".NET v2.0"-Or 
        $PoolName -eq ".NET v4.5 Classic" -Or
        $PoolName -eq ".NET v4.5"
        ){
            Write-Host  "Inbuild Pool" + $PoolName
        }
        else{
            #Get username                   
            $PoolUserCmd = $AppCmdPath + ' list apppool "' + $PoolName + '" /text:processmodel.username'
            $PoolUser = invoke-expression $PoolUserCmd 
                                          
            #Get password
            $PoolPasswordCmd = $AppCmdPath + ' list apppool "' + $PoolName + '" /text:processmodel.password'
            $PoolPassword = invoke-expression $PoolPasswordCmd 

            #Check if credentials exists
            if ($PoolPassword -ne "") {
                           
                #Re-set the app pool with the same credentials             
                & $AppCmdPath set config -section:system.applicationHost/applicationPools "/[name='$($PoolName )'].processModel.identityType:SpecificUser" "/[name='$($PoolName)'].processModel.userName:$($PoolUser)" "/[name='$($PoolName)'].processModel.password:$($PoolPassword)" 
            }
        }        
    }
    # Do IISRESET after re-setting passwords
    & {iisreset}   
}
else {
    Write-Host -Object 'Could not find the appcmd.exe path at default location, please try at different place.'
}