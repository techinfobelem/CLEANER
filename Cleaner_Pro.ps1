Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

$ErrorActionPreference = "SilentlyContinue"

# ============================================================
# TECH INFO BELEM - CLEANER PRO
# VERSAO 0.6
# ============================================================

function Test-Administrator {

    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()

    $principal = New-Object Security.Principal.WindowsPrincipal($identity)

    return $principal.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
}

# ============================================================
# AVISO DE ADMINISTRADOR
# ============================================================

if (-not (Test-Administrator)) {

    [System.Windows.MessageBox]::Show(
        "O Cleaner Pro nao esta sendo executado como Administrador.`n`nAlgumas funcoes podem nao funcionar corretamente.`n`nRecomendamos executar o PowerShell como Administrador.",
        "TECH INFO BELEM - Cleaner Pro v0.6",
        "OK",
        "Warning"
    )
}

# ============================================================
# INTERFACE GRAFICA
# ============================================================

[xml]$XAML = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="TECH INFO BELEM - Cleaner Pro v0.6"
    Height="760"
    Width="1200"
    WindowStartupLocation="CenterScreen"
    Background="#111827">

    <Grid>

        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="250"/>
            <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>

        <Border
            Grid.Column="0"
            Background="#0B1220">

            <ScrollViewer
                VerticalScrollBarVisibility="Auto">

                <StackPanel>

                    <TextBlock
                        Text="TECH INFO"
                        Foreground="#60A5FA"
                        FontSize="25"
                        FontWeight="Bold"
                        Margin="25,25,10,0"/>

                    <TextBlock
                        Text="BELEM"
                        Foreground="#EF4444"
                        FontSize="25"
                        FontWeight="Bold"
                        Margin="25,0,10,5"/>

                    <TextBlock
                        Text="CLEANER PRO"
                        Foreground="White"
                        FontSize="14"
                        Margin="25,0,10,25"/>

                    <TextBlock
                        Text="MANUTENCAO"
                        Foreground="#6B7280"
                        FontSize="11"
                        FontWeight="Bold"
                        Margin="20,5,10,5"/>

                    <Button
                        Name="btnInicio"
                        Content="INICIO"
                        Height="40"
                        Margin="15,3"
                        Background="#1D4ED8"
                        Foreground="White"/>

                    <Button
                        Name="btnAnalisar"
                        Content="ANALISAR SISTEMA"
                        Height="40"
                        Margin="15,3"
                        Background="#047857"
                        Foreground="White"/>

                    <Button
                        Name="btnTemporarios"
                        Content="LIMPAR TEMPORARIOS"
                        Height="40"
                        Margin="15,3"
                        Background="#1F2937"
                        Foreground="White"/>

                    <Button
                        Name="btnNavegadores"
                        Content="LIMPAR NAVEGADORES"
                        Height="40"
                        Margin="15,3"
                        Background="#1F2937"
                        Foreground="White"/>

                    <Button
                        Name="btnLixeira"
                        Content="ESVAZIAR LIXEIRA"
                        Height="40"
                        Margin="15,3"
                        Background="#1F2937"
                        Foreground="White"/>

                    <Button
                        Name="btnCompleta"
                        Content="LIMPEZA COMPLETA"
                        Height="40"
                        Margin="15,3"
                        Background="#991B1B"
                        Foreground="White"/>

                    <TextBlock
                        Text="REPARACAO DO WINDOWS"
                        Foreground="#6B7280"
                        FontSize="11"
                        FontWeight="Bold"
                        Margin="20,20,10,5"/>

                    <Button
                        Name="btnDiagnosticoWindows"
                        Content="DIAGNOSTICAR WINDOWS"
                        Height="40"
                        Margin="15,3"
                        Background="#1F2937"
                        Foreground="White"/>

                    <Button
                        Name="btnRepararWindows"
                        Content="REPARAR WINDOWS"
                        Height="40"
                        Margin="15,3"
                        Background="#92400E"
                        Foreground="White"/>

                    <TextBlock
                        Text="DIAGNOSTICO DE HARDWARE"
                        Foreground="#6B7280"
                        FontSize="11"
                        FontWeight="Bold"
                        Margin="20,20,10,5"/>

                    <Button
                        Name="btnDiscos"
                        Content="SAUDE SSD / HD"
                        Height="40"
                        Margin="15,3"
                        Background="#1F2937"
                        Foreground="White"/>

                    <Button
                        Name="btnMemoria"
                        Content="TESTE DE MEMORIA RAM"
                        Height="40"
                        Margin="15,3"
                        Background="#1F2937"
                        Foreground="White"/>

                    <Button
                        Name="btnHardware"
                        Content="INFORMACOES DO HARDWARE"
                        Height="40"
                        Margin="15,3"
                        Background="#1F2937"
                        Foreground="White"/>

                    <TextBlock
                        Text="ATENDIMENTO"
                        Foreground="#6B7280"
                        FontSize="11"
                        FontWeight="Bold"
                        Margin="20,20,10,5"/>

                    <Button
                        Name="btnRelatorio"
                        Content="RELATORIO DE SERVICO"
                        Height="40"
                        Margin="15,3"
                        Background="#0369A1"
                        Foreground="White"/>

                    <TextBlock
                        Text="FERRAMENTAS"
                        Foreground="#6B7280"
                        FontSize="11"
                        FontWeight="Bold"
                        Margin="20,20,10,5"/>

                    <Button
                        Name="btnChrisTitus"
                        Content="WINUTIL - CHRIS TITUS"
                        Height="40"
                        Margin="15,3"
                        Background="#7C3AED"
                        Foreground="White"/>

                    <Button
                        Name="btnSair"
                        Content="SAIR"
                        Height="40"
                        Margin="15,25,15,20"
                        Background="#374151"
                        Foreground="White"/>

                </StackPanel>

            </ScrollViewer>

        </Border>

        <Grid
            Grid.Column="1"
            Margin="35">

            <Grid.RowDefinitions>

                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="Auto"/>

            </Grid.RowDefinitions>

            <TextBlock
                Name="txtTitulo"
                Text="Painel de Controle"
                Foreground="White"
                FontSize="30"
                FontWeight="Bold"/>

            <TextBlock
                Name="txtSubtitulo"
                Grid.Row="1"
                Text="Ferramenta profissional de limpeza, diagnostico e manutencao"
                Foreground="#9CA3AF"
                FontSize="15"
                Margin="0,5,0,20"/>

            <ScrollViewer
                Grid.Row="2"
                VerticalScrollBarVisibility="Auto">

                <Grid>

                    <Grid.ColumnDefinitions>

                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="*"/>

                    </Grid.ColumnDefinitions>

                    <StackPanel
                        Grid.Column="0"
                        Margin="0,0,10,0">

                        <Border
                            Background="#1F2937"
                            CornerRadius="10"
                            Padding="20"
                            Margin="0,0,0,12">

                            <StackPanel>

                                <TextBlock
                                    Text="COMPUTADOR"
                                    Foreground="#60A5FA"
                                    FontSize="13"/>

                                <TextBlock
                                    Name="txtComputador"
                                    Foreground="White"
                                    FontSize="19"
                                    FontWeight="Bold"
                                    Margin="0,7,0,0"
                                    TextWrapping="Wrap"/>

                            </StackPanel>

                        </Border>

                        <Border
                            Background="#1F2937"
                            CornerRadius="10"
                            Padding="20"
                            Margin="0,0,0,12">

                            <StackPanel>

                                <TextBlock
                                    Text="SISTEMA OPERACIONAL"
                                    Foreground="#60A5FA"
                                    FontSize="13"/>

                                <TextBlock
                                    Name="txtWindows"
                                    Foreground="White"
                                    FontSize="18"
                                    FontWeight="Bold"
                                    Margin="0,7,0,0"
                                    TextWrapping="Wrap"/>

                            </StackPanel>

                        </Border>

                        <Border
                            Background="#1F2937"
                            CornerRadius="10"
                            Padding="20"
                            Margin="0,0,0,12">

                            <StackPanel>

                                <TextBlock
                                    Text="PROCESSADOR"
                                    Foreground="#60A5FA"
                                    FontSize="13"/>

                                <TextBlock
                                    Name="txtCPU"
                                    Foreground="White"
                                    FontSize="17"
                                    FontWeight="Bold"
                                    Margin="0,7,0,0"
                                    TextWrapping="Wrap"/>

                            </StackPanel>

                        </Border>

                        <Border
                            Background="#1F2937"
                            CornerRadius="10"
                            Padding="20"
                            Margin="0,0,0,12">

                            <StackPanel>

                                <TextBlock
                                    Text="MEMORIA RAM"
                                    Foreground="#60A5FA"
                                    FontSize="13"/>

                                <TextBlock
                                    Name="txtRAM"
                                    Foreground="White"
                                    FontSize="20"
                                    FontWeight="Bold"
                                    Margin="0,7,0,0"/>

                            </StackPanel>

                        </Border>

                        <Border
                            Background="#1F2937"
                            CornerRadius="10"
                            Padding="20">

                            <StackPanel>

                                <TextBlock
                                    Text="STATUS DA MEMORIA"
                                    Foreground="#60A5FA"
                                    FontSize="13"/>

                                <TextBlock
                                    Name="txtStatusMemoria"
                                    Text="Teste nao realizado"
                                    Foreground="White"
                                    FontSize="17"
                                    FontWeight="Bold"
                                    Margin="0,7,0,0"
                                    TextWrapping="Wrap"/>

                            </StackPanel>

                        </Border>

                    </StackPanel>

                    <StackPanel
                        Grid.Column="1"
                        Margin="10,0,0,0">

                        <Border
                            Background="#1F2937"
                            CornerRadius="10"
                            Padding="20"
                            Margin="0,0,0,12">

                            <StackPanel>

                                <TextBlock
                                    Text="DISCO PRINCIPAL"
                                    Foreground="#60A5FA"
                                    FontSize="13"/>

                                <TextBlock
                                    Name="txtDisco"
                                    Foreground="White"
                                    FontSize="18"
                                    FontWeight="Bold"
                                    Margin="0,7,0,0"
                                    TextWrapping="Wrap"/>

                            </StackPanel>

                        </Border>

                        <Border
                            Background="#1F2937"
                            CornerRadius="10"
                            Padding="20"
                            Margin="0,0,0,12">

                            <StackPanel>

                                <TextBlock
                                    Text="ESPACO DISPONIVEL"
                                    Foreground="#60A5FA"
                                    FontSize="13"/>

                                <TextBlock
                                    Name="txtEspaco"
                                    Foreground="White"
                                    FontSize="20"
                                    FontWeight="Bold"
                                    Margin="0,7,0,0"/>

                            </StackPanel>

                        </Border>

                        <Border
                            Background="#1F2937"
                            CornerRadius="10"
                            Padding="20"
                            Margin="0,0,0,12">

                            <StackPanel>

                                <TextBlock
                                    Text="SAUDE DO ARMAZENAMENTO"
                                    Foreground="#60A5FA"
                                    FontSize="13"/>

                                <TextBlock
                                    Name="txtSaudeDisco"
                                    Text="Nao analisado"
                                    Foreground="White"
                                    FontSize="17"
                                    FontWeight="Bold"
                                    Margin="0,7,0,0"
                                    TextWrapping="Wrap"/>

                            </StackPanel>

                        </Border>

                        <Border
                            Background="#1F2937"
                            CornerRadius="10"
                            Padding="20"
                            Margin="0,0,0,12">

                            <StackPanel>

                                <TextBlock
                                    Text="ANALISE DE LIMPEZA"
                                    Foreground="#60A5FA"
                                    FontSize="13"/>

                                <TextBlock
                                    Name="txtAnalise"
                                    Text="Nenhuma analise realizada"
                                    Foreground="White"
                                    FontSize="17"
                                    FontWeight="Bold"
                                    Margin="0,7,0,0"
                                    TextWrapping="Wrap"/>

                            </StackPanel>

                        </Border>

                        <Border
                            Background="#1F2937"
                            CornerRadius="10"
                            Padding="20">

                            <StackPanel>

                                <TextBlock
                                    Text="STATUS"
                                    Foreground="#60A5FA"
                                    FontSize="13"/>

                                <TextBlock
                                    Name="txtStatus"
                                    Text="Sistema pronto"
                                    Foreground="#22C55E"
                                    FontSize="18"
                                    FontWeight="Bold"
                                    Margin="0,7,0,0"
                                    TextWrapping="Wrap"/>

                            </StackPanel>

                        </Border>

                    </StackPanel>

                </Grid>

            </ScrollViewer>

            <TextBlock
                Name="txtRodape"
                Grid.Row="3"
                Text="TECH INFO BELEM - Cleaner Pro v0.6"
                Foreground="#6B7280"
                HorizontalAlignment="Right"
                Margin="0,20,0,0"/>

        </Grid>

    </Grid>

</Window>
"@

# ============================================================
# CARREGAR INTERFACE
# ============================================================

$reader = New-Object System.Xml.XmlNodeReader $XAML

$Window = [Windows.Markup.XamlReader]::Load($reader)

# ============================================================
# CONTROLES
# ============================================================

$btnInicio = $Window.FindName("btnInicio")
$btnAnalisar = $Window.FindName("btnAnalisar")
$btnTemporarios = $Window.FindName("btnTemporarios")
$btnNavegadores = $Window.FindName("btnNavegadores")
$btnLixeira = $Window.FindName("btnLixeira")
$btnCompleta = $Window.FindName("btnCompleta")

$btnDiagnosticoWindows = $Window.FindName("btnDiagnosticoWindows")
$btnRepararWindows = $Window.FindName("btnRepararWindows")

$btnDiscos = $Window.FindName("btnDiscos")
$btnMemoria = $Window.FindName("btnMemoria")
$btnHardware = $Window.FindName("btnHardware")

$btnRelatorio = $Window.FindName("btnRelatorio")

$btnChrisTitus = $Window.FindName("btnChrisTitus")
$btnSair = $Window.FindName("btnSair")

$txtComputador = $Window.FindName("txtComputador")
$txtWindows = $Window.FindName("txtWindows")
$txtCPU = $Window.FindName("txtCPU")
$txtRAM = $Window.FindName("txtRAM")
$txtDisco = $Window.FindName("txtDisco")
$txtEspaco = $Window.FindName("txtEspaco")

$txtSaudeDisco = $Window.FindName("txtSaudeDisco")
$txtStatusMemoria = $Window.FindName("txtStatusMemoria")

$txtAnalise = $Window.FindName("txtAnalise")
$txtStatus = $Window.FindName("txtStatus")

$txtTitulo = $Window.FindName("txtTitulo")
$txtSubtitulo = $Window.FindName("txtSubtitulo")

# ============================================================
# ATUALIZAR INFORMACOES
# ============================================================

function Atualizar-Informacoes {

    try {

        $computer =
            Get-CimInstance Win32_ComputerSystem

        $os =
            Get-CimInstance Win32_OperatingSystem

        $cpu =
            Get-CimInstance Win32_Processor |
            Select-Object -First 1

        $disk =
            Get-CimInstance Win32_LogicalDisk `
            -Filter "DeviceID='C:'"

        $ramGB =
            [math]::Round(
                $computer.TotalPhysicalMemory / 1GB,
                1
            )

        $freeGB =
            [math]::Round(
                $disk.FreeSpace / 1GB,
                1
            )

        $totalGB =
            [math]::Round(
                $disk.Size / 1GB,
                1
            )

        $txtComputador.Text =
            "$($computer.Manufacturer) $($computer.Model)"

        $txtWindows.Text =
            $os.Caption

        $txtCPU.Text =
            $cpu.Name

        $txtRAM.Text =
            "$ramGB GB"

        $txtDisco.Text =
            "$freeGB GB livres de $totalGB GB"

        $txtEspaco.Text =
            "$freeGB GB livres"

    }
    catch {

        $txtStatus.Text =
            "Erro ao obter informacoes do sistema"

    }

}

# ============================================================
# TAMANHO DE PASTA
# ============================================================

function Get-FolderSize {

    param(
        [string]$Path
    )

    $total = 0

    if (Test-Path $Path) {

        try {

            $files =
                Get-ChildItem `
                -Path $Path `
                -File `
                -Recurse `
                -Force `
                -ErrorAction SilentlyContinue

            foreach ($file in $files) {

                $total += $file.Length

            }

        }
        catch {

        }

    }

    return $total

}

# ============================================================
# DETECTAR NAVEGADORES
# ============================================================

function Get-BrowserCachePaths {

    $paths = @()

    $chrome =
        "$env:LOCALAPPDATA\Google\Chrome\User Data"

    if (Test-Path $chrome) {

        $paths += [PSCustomObject]@{
            Name = "Google Chrome"
            Path = $chrome
        }

    }

    $edge =
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data"

    if (Test-Path $edge) {

        $paths += [PSCustomObject]@{
            Name = "Microsoft Edge"
            Path = $edge
        }

    }

    $brave =
        "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data"

    if (Test-Path $brave) {

        $paths += [PSCustomObject]@{
            Name = "Brave"
            Path = $brave
        }

    }

    $opera =
        "$env:APPDATA\Opera Software\Opera Stable"

    if (Test-Path $opera) {

        $paths += [PSCustomObject]@{
            Name = "Opera"
            Path = $opera
        }

    }

    $operaGX =
        "$env:APPDATA\Opera Software\Opera GX Stable"

    if (Test-Path $operaGX) {

        $paths += [PSCustomObject]@{
            Name = "Opera GX"
            Path = $operaGX
        }

    }

    $firefox =
        "$env:APPDATA\Mozilla\Firefox\Profiles"

    if (Test-Path $firefox) {

        $profiles =
            Get-ChildItem `
            $firefox `
            -Directory `
            -ErrorAction SilentlyContinue

        foreach ($profile in $profiles) {

            $paths += [PSCustomObject]@{
                Name = "Firefox"
                Path = $profile.FullName
            }

        }

    }

    return $paths

}

# ============================================================
# TAMANHO CACHE
# ============================================================

function Get-BrowserCacheSize {

    $total = 0

    $browsers =
        Get-BrowserCachePaths

    foreach ($browser in $browsers) {

        if ($browser.Name -eq "Firefox") {

            $cache =
                Join-Path `
                $browser.Path `
                "cache2"

            $total +=
                Get-FolderSize $cache

        }
        else {

            $folders = @(
                "Default\Cache",
                "Default\Code Cache",
                "Default\GPUCache"
            )

            foreach ($folder in $folders) {

                $cache =
                    Join-Path `
                    $browser.Path `
                    $folder

                $total +=
                    Get-FolderSize $cache

            }

        }

    }

    return $total

}

# ============================================================
# TEMPORARIOS
# ============================================================

function Get-TemporarySize {

    $total = 0

    $total +=
        Get-FolderSize $env:TEMP

    $total +=
        Get-FolderSize "$env:SystemRoot\Temp"

    $total +=
        Get-FolderSize "$env:LOCALAPPDATA\Microsoft\Windows\INetCache"

    return $total

}

# ============================================================
# LIXEIRA
# ============================================================

function Get-RecycleBinSize {

    $total = 0

    try {

        $items =
            Get-ChildItem `
            'C:\$Recycle.Bin' `
            -Force `
            -Recurse `
            -ErrorAction SilentlyContinue

        foreach ($item in $items) {

            if (-not $item.PSIsContainer) {

                $total +=
                    $item.Length

            }

        }

    }
    catch {

    }

    return $total

}

# ============================================================
# ANALISAR SISTEMA
# ============================================================

function Analisar-Sistema {

    $txtStatus.Text =
        "Analisando arquivos temporarios..."

    $tempSize =
        Get-TemporarySize

    $txtStatus.Text =
        "Analisando caches dos navegadores..."

    $browserSize =
        Get-BrowserCacheSize

    $txtStatus.Text =
        "Analisando lixeira..."

    $recycleSize =
        Get-RecycleBinSize

    $total =
        $tempSize +
        $browserSize +
        $recycleSize

    $totalGB =
        [math]::Round(
            $total / 1GB,
            2
        )

    $txtAnalise.Text =
        "$totalGB GB potencialmente recuperaveis"

    $txtStatus.Text =
        "Analise concluida"

    [System.Windows.MessageBox]::Show(

        "ANALISE CONCLUIDA`n`n" +
        "Arquivos temporarios: " +
        "$([math]::Round($tempSize / 1MB, 2)) MB`n`n" +
        "Cache dos navegadores: " +
        "$([math]::Round($browserSize / 1MB, 2)) MB`n`n" +
        "Lixeira: " +
        "$([math]::Round($recycleSize / 1MB, 2)) MB`n`n" +
        "Total potencialmente recuperavel: " +
        "$totalGB GB",

        "TECH INFO BELEM - Analise",

        "OK",

        "Information"

    )

}

# ============================================================
# LIMPAR TEMPORARIOS
# ============================================================

function Limpar-Temporarios {

    $txtStatus.Text =
        "Limpando arquivos temporarios..."

    try {

        Get-ChildItem `
            $env:TEMP `
            -Force `
            -ErrorAction SilentlyContinue |
        Remove-Item `
            -Recurse `
            -Force `
            -ErrorAction SilentlyContinue

        Get-ChildItem `
            "$env:SystemRoot\Temp" `
            -Force `
            -ErrorAction SilentlyContinue |
        Remove-Item `
            -Recurse `
            -Force `
            -ErrorAction SilentlyContinue

        Get-ChildItem `
            "$env:LOCALAPPDATA\Microsoft\Windows\INetCache" `
            -Force `
            -ErrorAction SilentlyContinue |
        Remove-Item `
            -Recurse `
            -Force `
            -ErrorAction SilentlyContinue

        $txtStatus.Text =
            "Temporarios limpos"

        return $true

    }
    catch {

        $txtStatus.Text =
            "Erro ao limpar temporarios"

        return $false

    }

}

# ============================================================
# LIMPAR NAVEGADORES
# ============================================================

function Limpar-Navegadores {

    $txtStatus.Text =
        "Limpando caches dos navegadores..."

    $browsers =
        Get-BrowserCachePaths

    foreach ($browser in $browsers) {

        $txtStatus.Text =
            "Limpando $($browser.Name)..."

        if ($browser.Name -eq "Firefox") {

            $cache =
                Join-Path `
                $browser.Path `
                "cache2"

            if (Test-Path $cache) {

                Get-ChildItem `
                    $cache `
                    -Force `
                    -ErrorAction SilentlyContinue |
                Remove-Item `
                    -Recurse `
                    -Force `
                    -ErrorAction SilentlyContinue

            }

        }
        else {

            $folders = @(
                "Default\Cache",
                "Default\Code Cache",
                "Default\GPUCache"
            )

            foreach ($folder in $folders) {

                $cache =
                    Join-Path `
                    $browser.Path `
                    $folder

                if (Test-Path $cache) {

                    Get-ChildItem `
                        $cache `
                        -Force `
                        -ErrorAction SilentlyContinue |
                    Remove-Item `
                        -Recurse `
                        -Force `
                        -ErrorAction SilentlyContinue

                }

            }

        }

    }

    $txtStatus.Text =
        "Caches dos navegadores limpos"

    return $true

}

# ============================================================
# LIMPAR LIXEIRA
# ============================================================

function Limpar-Lixeira {

    $txtStatus.Text =
        "Esvaziando lixeira..."

    try {

        Clear-RecycleBin `
            -Force `
            -ErrorAction SilentlyContinue

        $txtStatus.Text =
            "Lixeira esvaziada"

        return $true

    }
    catch {

        $txtStatus.Text =
            "Erro ao esvaziar lixeira"

        return $false

    }

}

# ============================================================
# LIMPEZA COMPLETA
# ============================================================

function Limpeza-Completa {

    $confirmacao =
        [System.Windows.MessageBox]::Show(

            "Deseja iniciar a limpeza completa?`n`n" +
            "Serão processados:`n" +
            "- Arquivos temporarios`n" +
            "- Cache seguro dos navegadores`n" +
            "- Lixeira`n`n" +
            "Cookies, senhas, favoritos e historico nao serao removidos.",

            "TECH INFO BELEM - Limpeza Completa",

            "YesNo",

            "Question"

        )

    if ($confirmacao -ne "Yes") {

        return

    }

    $diskBefore =
        Get-CimInstance Win32_LogicalDisk `
        -Filter "DeviceID='C:'"

    $freeBefore =
        $diskBefore.FreeSpace

    Limpar-Temporarios

    Limpar-Navegadores

    Limpar-Lixeira

    $diskAfter =
        Get-CimInstance Win32_LogicalDisk `
        -Filter "DeviceID='C:'"

    $freeAfter =
        $diskAfter.FreeSpace

    $freed =
        $freeAfter -
        $freeBefore

    $freedMB =
        [math]::Round(
            $freed / 1MB,
            2
        )

    $freedGB =
        [math]::Round(
            $freed / 1GB,
            2
        )

    Atualizar-Informacoes

    $txtAnalise.Text =
        "$freedGB GB liberados"

    $txtStatus.Text =
        "Limpeza completa concluida"

    [System.Windows.MessageBox]::Show(

        "LIMPEZA COMPLETA FINALIZADA`n`n" +
        "Espaco liberado: " +
        "$freedMB MB`n`n" +
        "O Cleaner Pro concluiu a manutencao.",

        "TECH INFO BELEM - Cleaner Pro v0.6",

        "OK",

        "Information"

    )

}

# ============================================================
# DIAGNOSTICO WINDOWS
# ============================================================

function Diagnosticar-Windows {

    $txtStatus.Text =
        "Executando DISM /ScanHealth..."

    $dism =
        Start-Process `
        "DISM.exe" `
        -ArgumentList "/Online /Cleanup-Image /ScanHealth" `
        -Wait `
        -PassThru `
        -WindowStyle Hidden

    $txtStatus.Text =
        "Executando SFC /VerifyOnly..."

    $sfc =
        Start-Process `
        "sfc.exe" `
        -ArgumentList "/verifyonly" `
        -Wait `
        -PassThru `
        -WindowStyle Hidden

    $txtStatus.Text =
        "Diagnostico do Windows concluido"

    [System.Windows.MessageBox]::Show(

        "O diagnostico do Windows foi concluido.`n`n" +
        "DISM ExitCode: $($dism.ExitCode)`n" +
        "SFC ExitCode: $($sfc.ExitCode)`n`n" +
        "Para uma analise detalhada, consulte os logs do Windows.",

        "TECH INFO BELEM - Diagnostico Windows",

        "OK",

        "Information"

    )

}

# ============================================================
# REPARAR WINDOWS
# ============================================================

function Reparar-Windows {

    $confirmacao =
        [System.Windows.MessageBox]::Show(

            "O processo executara:`n`n" +
            "1. DISM /RestoreHealth`n" +
            "2. SFC /scannow`n`n" +
            "O processo pode levar varios minutos.`n`n" +
            "Deseja continuar?",

            "TECH INFO BELEM - Reparar Windows",

            "YesNo",

            "Warning"

        )

    if ($confirmacao -ne "Yes") {

        return

    }

    $txtStatus.Text =
        "Reparando imagem do Windows com DISM..."

    $dism =
        Start-Process `
        "DISM.exe" `
        -ArgumentList "/Online /Cleanup-Image /RestoreHealth" `
        -Wait `
        -PassThru

    $txtStatus.Text =
        "Executando SFC /scannow..."

    $sfc =
        Start-Process `
        "sfc.exe" `
        -ArgumentList "/scannow" `
        -Wait `
        -PassThru

    $txtStatus.Text =
        "Reparo do Windows concluido"

    [System.Windows.MessageBox]::Show(

        "PROCESSO DE REPARACAO FINALIZADO`n`n" +
        "DISM ExitCode: $($dism.ExitCode)`n" +
        "SFC ExitCode: $($sfc.ExitCode)`n`n" +
        "Recomendamos reiniciar o computador caso o sistema tenha apresentado problemas.",

        "TECH INFO BELEM - Reparar Windows",

        "OK",

        "Information"

    )

}

# ============================================================
# SAUDE DOS DISCOS
# ============================================================

function Verificar-SaudeDiscos {

    $txtStatus.Text =
        "Analisando armazenamento..."

    try {

        $physicalDisks =
            Get-PhysicalDisk

        $resultado = ""

        foreach ($disk in $physicalDisks) {

            $modelo =
                $disk.FriendlyName

            $tipo =
                $disk.MediaType

            $tamanho =
                [math]::Round(
                    $disk.Size / 1GB,
                    1
                )

            $saude =
                $disk.HealthStatus

            $operacional =
                $disk.OperationalStatus

            $resultado +=
                "Modelo: $modelo`n" +
                "Tipo: $tipo`n" +
                "Capacidade: $tamanho GB`n" +
                "Saude: $saude`n" +
                "Status: $operacional`n`n"

        }

        if ([string]::IsNullOrWhiteSpace($resultado)) {

            $resultado =
                "Nenhum disco fisico foi identificado."

        }

        $txtSaudeDisco.Text =
            "Analise concluida"

        $txtStatus.Text =
            "Diagnostico de armazenamento concluido"

        [System.Windows.MessageBox]::Show(

            $resultado,

            "TECH INFO BELEM - Saude SSD / HD",

            "OK",

            "Information"

        )

    }
    catch {

        $txtSaudeDisco.Text =
            "Nao disponivel"

        $txtStatus.Text =
            "Nao foi possivel consultar os discos"

        [System.Windows.MessageBox]::Show(

            "Nao foi possivel obter informacoes de saude dos discos.`n`nIsso pode ocorrer devido ao driver ou ao tipo de armazenamento.",

            "TECH INFO BELEM - Diagnostico",

            "OK",

            "Warning"

        )

    }

}

# ============================================================
# TESTE DE MEMORIA
# ============================================================

function Testar-Memoria {

    $confirmacao =
        [System.Windows.MessageBox]::Show(

            "O Diagnostico de Memoria do Windows sera aberto.`n`n" +
            "O teste completo exige que o computador seja reiniciado.`n`n" +
            "Salve todos os trabalhos antes de continuar.`n`n" +
            "Deseja abrir o diagnostico de memoria?",

            "TECH INFO BELEM - Teste de RAM",

            "YesNo",

            "Warning"

        )

    if ($confirmacao -ne "Yes") {

        return

    }

    $txtStatusMemoria.Text =
        "Diagnostico agendado"

    $txtStatus.Text =
        "Abrindo Diagnostico de Memoria..."

    Start-Process `
        "mdsched.exe"

    $txtStatusMemoria.Text =
        "Aguardando teste do Windows"

    $txtStatus.Text =
        "Diagnostico de memoria aberto"

    [System.Windows.MessageBox]::Show(

        "O Diagnostico de Memoria do Windows foi aberto.`n`nEscolha uma das opcoes disponiveis para iniciar o teste.`n`nO resultado sera apresentado pelo Windows apos a verificacao.",

        "TECH INFO BELEM - Teste de RAM",

        "OK",

        "Information"

    )

}

# ============================================================
# INFORMACOES HARDWARE
# ============================================================

function Mostrar-Hardware {

    $txtStatus.Text =
        "Coletando informacoes de hardware..."

    try {

        $cpu =
            Get-CimInstance Win32_Processor |
            Select-Object -First 1

        $computer =
            Get-CimInstance Win32_ComputerSystem

        $gpu =
            Get-CimInstance Win32_VideoController

        $resultado =
            "PROCESSADOR`n" +
            "$($cpu.Name)`n`n" +
            "NUCLEOS: $($cpu.NumberOfCores)`n" +
            "THREADS: $($cpu.NumberOfLogicalProcessors)`n`n" +
            "MEMORIA RAM`n" +
            "$([math]::Round($computer.TotalPhysicalMemory / 1GB, 1)) GB`n`n" +
            "PLACA DE VIDEO`n"

        foreach ($video in $gpu) {

            $resultado +=
                "$($video.Name)`n"

        }

        $txtStatus.Text =
            "Informacoes de hardware coletadas"

        [System.Windows.MessageBox]::Show(

            $resultado,

            "TECH INFO BELEM - Hardware",

            "OK",

            "Information"

        )

    }
    catch {

        $txtStatus.Text =
            "Erro ao coletar hardware"

    }

}

# ============================================================
# CHRIS TITUS
# ============================================================

function Abrir-ChrisTitus {

    $confirmacao =
        [System.Windows.MessageBox]::Show(

            "Deseja abrir o Windows Utility do Chris Titus Tech?`n`nO WinUtil sera executado diretamente a partir do site oficial.",

            "TECH INFO BELEM - WinUtil",

            "YesNo",

            "Question"

        )

    if ($confirmacao -eq "Yes") {

        $txtStatus.Text =
            "Abrindo Chris Titus WinUtil..."

        try {

            Invoke-RestMethod `
                "https://christitus.com/win" |
            Invoke-Expression

            $txtStatus.Text =
                "Chris Titus WinUtil iniciado"

        }
        catch {

            $txtStatus.Text =
                "Erro ao abrir Chris Titus WinUtil"

            [System.Windows.MessageBox]::Show(

                "Nao foi possivel abrir o Chris Titus WinUtil.`n`nErro:`n$($_.Exception.Message)",

                "TECH INFO BELEM - Erro",

                "OK",

                "Error"

            )

        }

    }

}

# ============================================================
# FIM DA PARTE 1
# COLE A PARTE 2 IMEDIATAMENTE ABAIXO
# ============================================================# ============================================================
# JANELA DE PREENCHIMENTO DO RELATORIO
# ============================================================

function Abrir-FormularioRelatorio {

    [xml]$FormXAML = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="TECH INFO BELEM - Novo Relatorio de Servico"
    Height="700"
    Width="850"
    WindowStartupLocation="CenterScreen"
    ResizeMode="CanResize"
    Background="#111827">

    <Grid Margin="25">

        <Grid.RowDefinitions>

            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>

        </Grid.RowDefinitions>

        <StackPanel>

            <TextBlock
                Text="NOVO RELATORIO DE SERVICO"
                Foreground="#60A5FA"
                FontSize="26"
                FontWeight="Bold"/>

            <TextBlock
                Text="Preencha as informacoes do atendimento realizado."
                Foreground="#9CA3AF"
                FontSize="14"
                Margin="0,5,0,20"/>

        </StackPanel>

        <ScrollViewer
            Grid.Row="1"
            VerticalScrollBarVisibility="Auto">

            <StackPanel>

                <TextBlock
                    Text="CLIENTE"
                    Foreground="White"
                    FontWeight="Bold"
                    Margin="0,5,0,5"/>

                <TextBox
                    Name="txtCliente"
                    Height="35"
                    Padding="8"
                    FontSize="15"
                    Margin="0,0,0,15"/>

                <TextBlock
                    Text="TIPO DE SERVICO"
                    Foreground="White"
                    FontWeight="Bold"
                    Margin="0,5,0,5"/>

                <ComboBox
                    Name="cmbTipoServico"
                    Height="35"
                    FontSize="15"
                    Margin="0,0,0,15">

                    <ComboBoxItem Content="Montagem de PC Gamer"/>
                    <ComboBoxItem Content="Montagem de computador"/>
                    <ComboBoxItem Content="Instalacao do Windows"/>
                    <ComboBoxItem Content="Formatacao e instalacao do Windows"/>
                    <ComboBoxItem Content="Manutencao preventiva"/>
                    <ComboBoxItem Content="Manutencao corretiva"/>
                    <ComboBoxItem Content="Diagnostico tecnico"/>
                    <ComboBoxItem Content="Limpeza e otimizacao"/>
                    <ComboBoxItem Content="Reparo do Windows"/>
                    <ComboBoxItem Content="Upgrade de hardware"/>
                    <ComboBoxItem Content="Instalacao de SSD / HD"/>
                    <ComboBoxItem Content="Outro servico"/>

                </ComboBox>

                <TextBlock
                    Text="DESCRICAO DO SERVICO REALIZADO"
                    Foreground="White"
                    FontWeight="Bold"
                    Margin="0,5,0,5"/>

                <TextBox
                    Name="txtServico"
                    Height="130"
                    Padding="8"
                    FontSize="14"
                    AcceptsReturn="True"
                    TextWrapping="Wrap"
                    VerticalScrollBarVisibility="Auto"
                    Margin="0,0,0,15"/>

                <TextBlock
                    Text="OBSERVACOES TECNICAS"
                    Foreground="White"
                    FontWeight="Bold"
                    Margin="0,5,0,5"/>

                <TextBox
                    Name="txtObservacoes"
                    Height="120"
                    Padding="8"
                    FontSize="14"
                    AcceptsReturn="True"
                    TextWrapping="Wrap"
                    VerticalScrollBarVisibility="Auto"
                    Margin="0,0,0,15"/>

                <TextBlock
                    Text="TECNICO RESPONSAVEL"
                    Foreground="White"
                    FontWeight="Bold"
                    Margin="0,5,0,5"/>

                <TextBox
                    Name="txtTecnico"
                    Height="35"
                    Padding="8"
                    FontSize="15"
                    Text="TECH INFO BELEM"
                    Margin="0,0,0,15"/>

            </StackPanel>

        </ScrollViewer>

        <StackPanel
            Grid.Row="2"
            Orientation="Horizontal"
            HorizontalAlignment="Right"
            Margin="0,20,0,0">

            <Button
                Name="btnCancelarRelatorio"
                Content="CANCELAR"
                Width="130"
                Height="40"
                Margin="0,0,10,0"
                Background="#374151"
                Foreground="White"/>

            <Button
                Name="btnGerarRelatorio"
                Content="GERAR RELATORIO"
                Width="170"
                Height="40"
                Background="#0369A1"
                Foreground="White"/>

        </StackPanel>

    </Grid>

</Window>
"@

    $readerForm =
        New-Object System.Xml.XmlNodeReader $FormXAML

    $FormWindow =
        [Windows.Markup.XamlReader]::Load($readerForm)

    $txtCliente =
        $FormWindow.FindName("txtCliente")

    $cmbTipoServico =
        $FormWindow.FindName("cmbTipoServico")

    $txtServico =
        $FormWindow.FindName("txtServico")

    $txtObservacoes =
        $FormWindow.FindName("txtObservacoes")

    $txtTecnico =
        $FormWindow.FindName("txtTecnico")

    $btnCancelarRelatorio =
        $FormWindow.FindName("btnCancelarRelatorio")

    $btnGerarRelatorio =
        $FormWindow.FindName("btnGerarRelatorio")


    $btnCancelarRelatorio.Add_Click({

        $FormWindow.Close()

    })


    $btnGerarRelatorio.Add_Click({

        if (
            [string]::IsNullOrWhiteSpace(
                $txtServico.Text
            )
        ) {

            [System.Windows.MessageBox]::Show(

                "Informe a descricao do servico realizado antes de gerar o relatorio.",

                "TECH INFO BELEM",

                "OK",

                "Warning"

            )

            return

        }


        $tipoServico = ""

        if ($cmbTipoServico.SelectedItem) {

            $tipoServico =
                $cmbTipoServico.SelectedItem.Content

        }


        if (
            [string]::IsNullOrWhiteSpace(
                $tipoServico
            )
        ) {

            $tipoServico =
                "Servico tecnico"

        }


        $cliente =
            $txtCliente.Text

        if (
            [string]::IsNullOrWhiteSpace(
                $cliente
            )
        ) {

            $cliente =
                "Nao informado"

        }


        $servico =
            $txtServico.Text

        $observacoes =
            $txtObservacoes.Text

        $tecnico =
            $txtTecnico.Text

        if (
            [string]::IsNullOrWhiteSpace(
                $tecnico
            )
        ) {

            $tecnico =
                "TECH INFO BELEM"

        }


        $FormWindow.Tag = [PSCustomObject]@{

            Cliente =
                $cliente

            TipoServico =
                $tipoServico

            Servico =
                $servico

            Observacoes =
                $observacoes

            Tecnico =
                $tecnico

        }


        $FormWindow.DialogResult =
            $true

        $FormWindow.Close()

    })


    $FormWindow.ShowDialog() | Out-Null


    return $FormWindow.Tag

}

# ============================================================
# RELATORIO DE SERVICO - TECH INFO BELEM
# ============================================================

```powershell
function Gerar-RelatorioServico {

    try {

        # ============================================================
        # COLETAR DADOS AUTOMATICOS DO COMPUTADOR
        # ============================================================

        $txtStatus.Text = "Coletando informacoes para o relatorio..."

        $computer = Get-CimInstance Win32_ComputerSystem
        $os = Get-CimInstance Win32_OperatingSystem
        $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
        $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"

        $ramGB = [math]::Round(
            $computer.TotalPhysicalMemory / 1GB,
            1
        )

        $freeGB = [math]::Round(
            $disk.FreeSpace / 1GB,
            1
        )

        $totalGB = [math]::Round(
            $disk.Size / 1GB,
            1
        )

        $dataAtual = Get-Date -Format "dd/MM/yyyy"
        $horaAtual = Get-Date -Format "HH:mm"

        $nomeComputador = $env:COMPUTERNAME

        $modeloComputador =
            "$($computer.Manufacturer) $($computer.Model)"

        $sistemaOperacional =
            $os.Caption

        $processador =
            $cpu.Name


        # ============================================================
        # COLETAR DISCOS FISICOS
        # ============================================================

        $physicalDisks = @()

        try {

            $physicalDisks = @(Get-PhysicalDisk)

        }
        catch {

            $physicalDisks = @()

        }


        # ============================================================
        # COLETAR PLACA DE VIDEO
        # ============================================================

        $gpu = @()

        try {

            $gpu =
                @(Get-CimInstance Win32_VideoController)

        }
        catch {

            $gpu = @()

        }


        # ============================================================
        # JANELA PARA PREENCHIMENTO MANUAL
        # ============================================================

        [xml]$ReportXAML = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="TECH INFO BELEM - Preencher Relatorio"
    Height="700"
    Width="900"
    WindowStartupLocation="CenterScreen"
    Background="#111827"
    ResizeMode="CanResize">

    <Grid Margin="25">

        <Grid.RowDefinitions>

            <RowDefinition Height="Auto"/>

            <RowDefinition Height="*"/>

            <RowDefinition Height="Auto"/>

        </Grid.RowDefinitions>


        <StackPanel Grid.Row="0">

            <TextBlock
                Text="RELATORIO DE SERVICO"
                Foreground="#60A5FA"
                FontSize="28"
                FontWeight="Bold"/>

            <TextBlock
                Text="TECH INFO BELEM"
                Foreground="White"
                FontSize="18"
                FontWeight="Bold"
                Margin="0,5,0,20"/>

        </StackPanel>


        <ScrollViewer
            Grid.Row="1"
            VerticalScrollBarVisibility="Auto">

            <StackPanel>


                <TextBlock
                    Text="DADOS DO CLIENTE"
                    Foreground="#60A5FA"
                    FontSize="15"
                    FontWeight="Bold"
                    Margin="0,5,0,8"/>


                <TextBlock
                    Text="Nome do cliente:"
                    Foreground="White"/>

                <TextBox
                    Name="txtCliente"
                    Height="35"
                    Margin="0,5,0,12"
                    Padding="8"/>


                <TextBlock
                    Text="Telefone / WhatsApp:"
                    Foreground="White"/>

                <TextBox
                    Name="txtTelefone"
                    Height="35"
                    Margin="0,5,0,20"
                    Padding="8"/>


                <TextBlock
                    Text="SERVICO REALIZADO"
                    Foreground="#60A5FA"
                    FontSize="15"
                    FontWeight="Bold"
                    Margin="0,5,0,8"/>


                <TextBlock
                    Text="Descreva detalhadamente o servico realizado:"
                    Foreground="White"/>

                <TextBox
                    Name="txtServico"
                    Height="120"
                    Margin="0,5,0,20"
                    Padding="8"
                    AcceptsReturn="True"
                    TextWrapping="Wrap"
                    VerticalScrollBarVisibility="Auto"/>


                <TextBlock
                    Text="OBSERVACOES TECNICAS"
                    Foreground="#60A5FA"
                    FontSize="15"
                    FontWeight="Bold"
                    Margin="0,5,0,8"/>


                <TextBox
                    Name="txtObservacoes"
                    Height="100"
                    Margin="0,5,0,20"
                    Padding="8"
                    AcceptsReturn="True"
                    TextWrapping="Wrap"
                    VerticalScrollBarVisibility="Auto"/>


                <TextBlock
                    Text="VALOR DO SERVICO"
                    Foreground="#60A5FA"
                    FontSize="15"
                    FontWeight="Bold"
                    Margin="0,5,0,8"/>


                <TextBlock
                    Text="Digite o valor cobrado:"
                    Foreground="White"/>


                <TextBox
                    Name="txtValor"
                    Height="40"
                    Margin="0,5,0,20"
                    Padding="8"
                    FontSize="18"/>


                <TextBlock
                    Text="FORMA DE PAGAMENTO"
                    Foreground="#60A5FA"
                    FontSize="15"
                    FontWeight="Bold"
                    Margin="0,5,0,8"/>


                <ComboBox
                    Name="cmbPagamento"
                    Height="40"
                    Margin="0,5,0,25">

                    <ComboBoxItem Content="PIX"/>

                    <ComboBoxItem Content="Cartao"/>

                    <ComboBoxItem Content="Dinheiro"/>

                    <ComboBoxItem Content="Transferencia"/>

                    <ComboBoxItem Content="Outro"/>

                </ComboBox>


            </StackPanel>

        </ScrollViewer>


        <StackPanel
            Grid.Row="2"
            Orientation="Horizontal"
            HorizontalAlignment="Right"
            Margin="0,20,0,0">


            <Button
                Name="btnCancelarRelatorio"
                Content="CANCELAR"
                Width="130"
                Height="45"
                Margin="0,0,10,0"
                Background="#374151"
                Foreground="White"/>


            <Button
                Name="btnSalvarRelatorio"
                Content="SALVAR RELATORIO"
                Width="180"
                Height="45"
                Background="#047857"
                Foreground="White"
                FontWeight="Bold"/>

        </StackPanel>

    </Grid>

</Window>
"@


        # ============================================================
        # CARREGAR JANELA
        # ============================================================

        $readerReport =
            New-Object System.Xml.XmlNodeReader $ReportXAML

        $ReportWindow =
            [Windows.Markup.XamlReader]::Load($readerReport)


        # ============================================================
        # CONTROLES DA JANELA
        # ============================================================

        $txtCliente =
            $ReportWindow.FindName("txtCliente")

        $txtTelefone =
            $ReportWindow.FindName("txtTelefone")

        $txtServico =
            $ReportWindow.FindName("txtServico")

        $txtObservacoes =
            $ReportWindow.FindName("txtObservacoes")

        $txtValor =
            $ReportWindow.FindName("txtValor")

        $cmbPagamento =
            $ReportWindow.FindName("cmbPagamento")

        $btnCancelarRelatorio =
            $ReportWindow.FindName("btnCancelarRelatorio")

        $btnSalvarRelatorio =
            $ReportWindow.FindName("btnSalvarRelatorio")


        # ============================================================
        # VARIAVEL DE CONFIRMACAO
        # ============================================================

        $script:RelatorioSalvo = $false


        # ============================================================
        # BOTAO CANCELAR
        # ============================================================

        $btnCancelarRelatorio.Add_Click({

            $ReportWindow.DialogResult = $false

            $ReportWindow.Close()

        })


        # ============================================================
        # BOTAO SALVAR
        # ============================================================

        $btnSalvarRelatorio.Add_Click({

            # --------------------------------------------------------
            # VALIDAR SERVICO
            # --------------------------------------------------------

            if ([string]::IsNullOrWhiteSpace($txtServico.Text)) {

                [System.Windows.MessageBox]::Show(

                    "Informe o servico realizado antes de salvar o relatorio.",

                    "TECH INFO BELEM - Relatorio",

                    "OK",

                    "Warning"

                )

                return

            }


            # --------------------------------------------------------
            # VALIDAR VALOR
            # --------------------------------------------------------

            if ([string]::IsNullOrWhiteSpace($txtValor.Text)) {

                [System.Windows.MessageBox]::Show(

                    "Informe o valor do servico antes de salvar o relatorio.",

                    "TECH INFO BELEM - Relatorio",

                    "OK",

                    "Warning"

                )

                return

            }


            # --------------------------------------------------------
            # DADOS DIGITADOS
            # --------------------------------------------------------

            $cliente =
                $txtCliente.Text.Trim()

            $telefone =
                $txtTelefone.Text.Trim()

            $servico =
                $txtServico.Text.Trim()

            $observacoes =
                $txtObservacoes.Text.Trim()

            $valor =
                $txtValor.Text.Trim()


            $pagamentoItem =
                $cmbPagamento.SelectedItem


            if ($null -ne $pagamentoItem) {

                $pagamento =
                    $pagamentoItem.Content.ToString()

            }
            else {

                $pagamento =
                    "Nao informado"

            }


            # --------------------------------------------------------
            # ESCAPAR HTML
            # --------------------------------------------------------

            $clienteHtml =
                [System.Net.WebUtility]::HtmlEncode($cliente)

            $telefoneHtml =
                [System.Net.WebUtility]::HtmlEncode($telefone)

            $servicoHtml =
                [System.Net.WebUtility]::HtmlEncode($servico) `
                -replace "`r?`n", "<br>"

            $observacoesHtml =
                [System.Net.WebUtility]::HtmlEncode($observacoes) `
                -replace "`r?`n", "<br>"

            $valorHtml =
                [System.Net.WebUtility]::HtmlEncode($valor)

            $pagamentoHtml =
                [System.Net.WebUtility]::HtmlEncode($pagamento)

            $modeloHtml =
                [System.Net.WebUtility]::HtmlEncode($modeloComputador)

            $nomeComputadorHtml =
                [System.Net.WebUtility]::HtmlEncode($nomeComputador)

            $sistemaHtml =
                [System.Net.WebUtility]::HtmlEncode($sistemaOperacional)

            $cpuHtml =
                [System.Net.WebUtility]::HtmlEncode($processador)


            # --------------------------------------------------------
            # GPU
            # --------------------------------------------------------

            $gpuHtml = ""

            foreach ($video in $gpu) {

                $gpuName =
                    [System.Net.WebUtility]::HtmlEncode(
                        [string]$video.Name
                    )

                $gpuHtml +=
                    "<li>$gpuName</li>"

            }


            if ([string]::IsNullOrWhiteSpace($gpuHtml)) {

                $gpuHtml =
                    "<li>Informacao nao disponivel</li>"

            }


            # --------------------------------------------------------
            # DISCOS
            # --------------------------------------------------------

            $diskHealthHtml = ""


            if ($physicalDisks.Count -gt 0) {

                foreach ($physicalDisk in $physicalDisks) {

                    $modelo =
                        [System.Net.WebUtility]::HtmlEncode(
                            [string]$physicalDisk.FriendlyName
                        )

                    $tipo =
                        [System.Net.WebUtility]::HtmlEncode(
                            [string]$physicalDisk.MediaType
                        )

                    $capacidade =
                        [math]::Round(
                            $physicalDisk.Size / 1GB,
                            1
                        )

                    $saude =
                        [System.Net.WebUtility]::HtmlEncode(
                            [string]$physicalDisk.HealthStatus
                        )

                    $status =
                        [System.Net.WebUtility]::HtmlEncode(
                            [string]$physicalDisk.OperationalStatus
                        )


                    $diskHealthHtml += @"

<tr>
<td>$modelo</td>
<td>$tipo</td>
<td>$capacidade GB</td>
<td>$saude</td>
<td>$status</td>
</tr>

"@

                }

            }
            else {

                $diskHealthHtml = @"

<tr>
<td colspan="5">
Informacoes de saude dos discos nao disponiveis.
</td>
</tr>

"@

            }


            # ========================================================
            # PASTA DE DOCUMENTOS
            # ========================================================

            $documentsFolder =
                [Environment]::GetFolderPath("MyDocuments")


            $reportFolder =
                Join-Path `
                $documentsFolder `
                "Relatorio Tech Info Belem"


            # Criar pasta
            if (-not (Test-Path -LiteralPath $reportFolder)) {

                New-Item `
                    -Path $reportFolder `
                    -ItemType Directory `
                    -Force |
                    Out-Null

            }


            # Verificar pasta
            if (-not (Test-Path -LiteralPath $reportFolder)) {

                [System.Windows.MessageBox]::Show(

                    "Nao foi possivel criar a pasta de relatorios.`n`nCaminho:`n$reportFolder",

                    "TECH INFO BELEM - Erro",

                    "OK",

                    "Error"

                )

                return

            }


            # ========================================================
            # NOME SEGURO DO CLIENTE
            # ========================================================

            $safeClientName =
                $cliente


            if ([string]::IsNullOrWhiteSpace($safeClientName)) {

                $safeClientName =
                    "Cliente"

            }


            $safeClientName =
                $safeClientName `
                -replace '[\\/:*?"<>|]', '_' `
                -replace '\s+', '_'


            $timestamp =
                Get-Date -Format "yyyyMMdd_HHmmss"


            $reportFile =
                Join-Path `
                $reportFolder `
                "Relatorio_${safeClientName}_${timestamp}.html"


            # ========================================================
            # HTML FINAL
            # ========================================================

            $html = @"
<!DOCTYPE html>

<html lang="pt-BR">

<head>

<meta charset="UTF-8">

<title>Relatorio de Servico - TECH INFO BELEM</title>

<style>

body {
    font-family: Arial, Helvetica, sans-serif;
    background: #f3f4f6;
    margin: 0;
    padding: 30px;
    color: #1f2937;
}

.container {
    max-width: 1000px;
    margin: auto;
    background: white;
    padding: 35px;
    box-shadow: 0 2px 12px rgba(0,0,0,0.12);
}

.header {
    border-bottom: 3px solid #2563eb;
    padding-bottom: 20px;
    margin-bottom: 25px;
}

.header h1 {
    margin: 0;
    color: #1d4ed8;
}

.header p {
    margin: 5px 0;
    color: #6b7280;
}

h2 {
    background: #1f2937;
    color: white;
    padding: 10px;
    font-size: 18px;
}

.info {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 10px;
}

.card {
    background: #f9fafb;
    border: 1px solid #e5e7eb;
    padding: 15px;
    margin-bottom: 10px;
}

.label {
    font-weight: bold;
    color: #374151;
}

.service {
    white-space: normal;
    line-height: 1.6;
}

.price {
    font-size: 24px;
    font-weight: bold;
    color: #047857;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 10px;
}

th {
    background: #2563eb;
    color: white;
    padding: 10px;
    text-align: left;
}

td {
    border: 1px solid #d1d5db;
    padding: 10px;
}

ul {
    background: #f9fafb;
    padding: 20px 40px;
}

.footer {
    margin-top: 40px;
    border-top: 1px solid #d1d5db;
    padding-top: 15px;
    color: #6b7280;
    font-size: 12px;
}

@media print {

    body {
        background: white;
        padding: 0;
    }

    .container {
        box-shadow: none;
    }

}

</style>

</head>


<body>

<div class="container">


<div class="header">

<h1>TECH INFO BELEM</h1>

<p>RELATORIO DE SERVICO TECNICO</p>

<p>Cleaner Pro v0.5</p>

</div>


<h2>INFORMACOES DO ATENDIMENTO</h2>

<div class="info">

<div class="card">

<span class="label">Data:</span><br>

$dataAtual

</div>


<div class="card">

<span class="label">Hora:</span><br>

$horaAtual

</div>


<div class="card">

<span class="label">Cliente:</span><br>

$clienteHtml

</div>


<div class="card">

<span class="label">Telefone / WhatsApp:</span><br>

$telefoneHtml

</div>

</div>


<h2>EQUIPAMENTO</h2>

<div class="info">

<div class="card">

<span class="label">Computador:</span><br>

$modeloHtml

</div>


<div class="card">

<span class="label">Nome do equipamento:</span><br>

$nomeComputadorHtml

</div>


<div class="card">

<span class="label">Sistema operacional:</span><br>

$sistemaHtml

</div>


<div class="card">

<span class="label">Processador:</span><br>

$cpuHtml

</div>


<div class="card">

<span class="label">Memoria RAM:</span><br>

$ramGB GB

</div>


<div class="card">

<span class="label">Disco principal:</span><br>

C:

</div>


<div class="card">

<span class="label">Espaco livre:</span><br>

$freeGB GB de $totalGB GB

</div>

</div>


<h2>PLACA DE VIDEO</h2>

<ul>

$gpuHtml

</ul>


<h2>SAUDE DOS DISCOS</h2>

<table>

<tr>

<th>Modelo</th>

<th>Tipo</th>

<th>Capacidade</th>

<th>Saude</th>

<th>Status</th>

</tr>

$diskHealthHtml

</table>


<h2>SERVICO REALIZADO</h2>

<div class="card service">

$servicoHtml

</div>


<h2>OBSERVACOES TECNICAS</h2>

<div class="card service">

$observacoesHtml

</div>


<h2>VALOR E PAGAMENTO</h2>

<div class="card">

<span class="label">Valor do servico:</span>

<p class="price">

R$ $valorHtml

</p>

<span class="label">Forma de pagamento:</span>

$pagamentoHtml

</div>


<div class="footer">

TECH INFO BELEM - Assistencia Tecnica em Computadores, Notebooks e Celulares<br>

Relatorio gerado pelo Cleaner Pro v0.5.<br>

Data de emissao: $dataAtual às $horaAtual

</div>


</div>

</body>

</html>
"@


            # ========================================================
            # SALVAR ARQUIVO
            # ========================================================

            try {

                Set-Content `
                    -LiteralPath $reportFile `
                    -Value $html `
                    -Encoding UTF8 `
                    -Force


                # Pequena pausa para garantir gravacao
                Start-Sleep -Milliseconds 300


            }
            catch {

                [System.Windows.MessageBox]::Show(

                    "Erro ao salvar o arquivo do relatorio.`n`n$($_.Exception.Message)",

                    "TECH INFO BELEM - Erro ao Salvar",

                    "OK",

                    "Error"

                )

                return

            }


            # ========================================================
            # VERIFICAR SE ARQUIVO FOI REALMENTE CRIADO
            # ========================================================

            if (-not (Test-Path -LiteralPath $reportFile)) {

                [System.Windows.MessageBox]::Show(

                    "O relatorio nao foi criado corretamente.`n`nCaminho esperado:`n$reportFile",

                    "TECH INFO BELEM - Erro",

                    "OK",

                    "Error"

                )

                return

            }


            # ========================================================
            # VERIFICAR TAMANHO DO ARQUIVO
            # ========================================================

            $fileInfo =
                Get-Item `
                -LiteralPath $reportFile `
                -ErrorAction SilentlyContinue


            if ($null -eq $fileInfo -or $fileInfo.Length -lt 100) {

                [System.Windows.MessageBox]::Show(

                    "O arquivo do relatorio foi criado, mas parece estar vazio ou incompleto.`n`nArquivo:`n$reportFile",

                    "TECH INFO BELEM - Erro",

                    "OK",

                    "Error"

                )

                return

            }


            # ========================================================
            # SUCESSO
            # ========================================================

            $script:RelatorioSalvo = $true


            $txtStatus.Text =
                "Relatorio salvo com sucesso"


            $ReportWindow.Close()


            $confirmacao =
                [System.Windows.MessageBox]::Show(

                    "RELATORIO SALVO COM SUCESSO!`n`n" +

                    "Cliente: $cliente`n" +

                    "Valor: R$ $valor`n`n" +

                    "Arquivo salvo em:`n$reportFile`n`n" +

                    "Deseja abrir o relatorio agora?",

                    "TECH INFO BELEM - Relatorio",

                    "YesNo",

                    "Information"

                )


            if ($confirmacao -eq "Yes") {

                Start-Process `
                    -FilePath $reportFile

            }

        })


        # ============================================================
        # ABRIR JANELA
        # ============================================================

        $ReportWindow.ShowDialog() | Out-Null


        if ($script:RelatorioSalvo) {

            $txtTitulo.Text =
                "Relatorio de Servico"

            $txtSubtitulo.Text =
                "Relatorio salvo em Documentos\\Relatorio Tech Info Belem"

        }

    }
    catch {

        $txtStatus.Text =
            "Erro ao gerar relatorio"


        [System.Windows.MessageBox]::Show(

            "Nao foi possivel abrir o formulario do relatorio.`n`nErro:`n$($_.Exception.Message)",

            "TECH INFO BELEM - Erro",

            "OK",

            "Error"

        )

    }

}
```


# ============================================================
# EVENTO - INICIO
# ============================================================

$btnInicio.Add_Click({

    $txtTitulo.Text =
        "Painel de Controle"

    $txtSubtitulo.Text =
        "Ferramenta profissional de limpeza, diagnostico e manutencao"

    $txtStatus.Text =
        "Sistema pronto"

    Atualizar-Informacoes

})

# ============================================================
# EVENTO - ANALISAR
# ============================================================

$btnAnalisar.Add_Click({

    $txtTitulo.Text =
        "Analise do Sistema"

    $txtSubtitulo.Text =
        "Verificando arquivos temporarios, caches e lixeira"

    Analisar-Sistema

})

# ============================================================
# EVENTO - TEMPORARIOS
# ============================================================

$btnTemporarios.Add_Click({

    $confirmacao =
        [System.Windows.MessageBox]::Show(

            "Deseja limpar os arquivos temporarios do sistema?",

            "TECH INFO BELEM",

            "YesNo",

            "Question"

        )

    if ($confirmacao -eq "Yes") {

        Limpar-Temporarios

    }

})

# ============================================================
# EVENTO - NAVEGADORES
# ============================================================

$btnNavegadores.Add_Click({

    $confirmacao =
        [System.Windows.MessageBox]::Show(

            "Deseja limpar os caches dos navegadores instalados?`n`nCookies, senhas, favoritos e historico nao serao removidos.",

            "TECH INFO BELEM - Navegadores",

            "YesNo",

            "Question"

        )

    if ($confirmacao -eq "Yes") {

        Limpar-Navegadores

    }

})

# ============================================================
# EVENTO - LIXEIRA
# ============================================================

$btnLixeira.Add_Click({

    $confirmacao =
        [System.Windows.MessageBox]::Show(

            "Deseja esvaziar a Lixeira do Windows?",

            "TECH INFO BELEM - Lixeira",

            "YesNo",

            "Warning"

        )

    if ($confirmacao -eq "Yes") {

        Limpar-Lixeira

    }

})

# ============================================================
# EVENTO - LIMPEZA COMPLETA
# ============================================================

$btnCompleta.Add_Click({

    Limpeza-Completa

})

# ============================================================
# EVENTO - DIAGNOSTICO WINDOWS
# ============================================================

$btnDiagnosticoWindows.Add_Click({

    $txtTitulo.Text =
        "Diagnostico do Windows"

    $txtSubtitulo.Text =
        "Verificando integridade da imagem e arquivos do sistema"

    Diagnosticar-Windows

})

# ============================================================
# EVENTO - REPARAR WINDOWS
# ============================================================

$btnRepararWindows.Add_Click({

    $txtTitulo.Text =
        "Reparacao do Windows"

    $txtSubtitulo.Text =
        "DISM RestoreHealth seguido de SFC Scannow"

    Reparar-Windows

})

# ============================================================
# EVENTO - SAUDE SSD HD
# ============================================================

$btnDiscos.Add_Click({

    $txtTitulo.Text =
        "Saude do Armazenamento"

    $txtSubtitulo.Text =
        "Consultando status dos discos fisicos"

    Verificar-SaudeDiscos

})

# ============================================================
# EVENTO - MEMORIA RAM
# ============================================================

$btnMemoria.Add_Click({

    $txtTitulo.Text =
        "Diagnostico de Memoria RAM"

    $txtSubtitulo.Text =
        "Teste utilizando o Diagnostico de Memoria do Windows"

    Testar-Memoria

})

# ============================================================
# EVENTO - HARDWARE
# ============================================================

$btnHardware.Add_Click({

    $txtTitulo.Text =
        "Informacoes do Hardware"

    $txtSubtitulo.Text =
        "Informacoes basicas do hardware instalado"

    Mostrar-Hardware

})

# ============================================================
# EVENTO - RELATORIO
# ============================================================

$btnRelatorio.Add_Click({

    $txtTitulo.Text =
        "Relatorio de Servico"

    $txtSubtitulo.Text =
        "Preencha os dados do atendimento e gere o relatorio tecnico"

    Gerar-RelatorioServico

})

# ============================================================
# EVENTO - CHRIS TITUS
# ============================================================

$btnChrisTitus.Add_Click({

    Abrir-ChrisTitus

})

# ============================================================
# EVENTO - SAIR
# ============================================================

$btnSair.Add_Click({

    $confirmacao =
        [System.Windows.MessageBox]::Show(

            "Deseja fechar o TECH INFO BELEM Cleaner Pro?",

            "TECH INFO BELEM",

            "YesNo",

            "Question"

        )

    if ($confirmacao -eq "Yes") {

        $Window.Close()

    }

})

# ============================================================
# INICIALIZAR
# ============================================================

Atualizar-Informacoes

$Window.ShowDialog() | Out-Null
