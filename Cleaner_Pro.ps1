Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ============================================================
# TECH INFO BELEM - CLEANER PRO
# Versao 0.3
# ============================================================

$ErrorActionPreference = "SilentlyContinue"

# ============================================================
# VERIFICAR ADMINISTRADOR
# ============================================================

function Test-Administrator {

    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()

    $principal = New-Object Security.Principal.WindowsPrincipal($identity)

    return $principal.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
}


# ============================================================
# AVISO ADMINISTRADOR
# ============================================================

if (-not (Test-Administrator)) {

    [System.Windows.MessageBox]::Show(
        "O Cleaner Pro nao esta sendo executado como Administrador.`n`nAlgumas funcoes de manutencao podem nao funcionar corretamente.`n`nRecomendamos abrir o PowerShell como Administrador.",
        "TECH INFO BELEM - Cleaner Pro v0.3",
        "OK",
        "Warning"
    )
}


# ============================================================
# INTERFACE
# ============================================================

[xml]$XAML = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="TECH INFO BELEM - Cleaner Pro v0.3"
    Height="700"
    Width="1150"
    WindowStartupLocation="CenterScreen"
    Background="#111827">

    <Grid>

        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="245"/>
            <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>


        <!-- ================================================= -->
        <!-- MENU LATERAL -->
        <!-- ================================================= -->

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
                        Margin="25,30,10,0"/>

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
                        Margin="25,0,10,30"/>


                    <Button
                        Name="btnInicio"
                        Content="INICIO"
                        Height="42"
                        Margin="15,4"
                        Background="#1D4ED8"
                        Foreground="White"/>


                    <Button
                        Name="btnAnalisar"
                        Content="ANALISAR SISTEMA"
                        Height="42"
                        Margin="15,4"
                        Background="#047857"
                        Foreground="White"/>


                    <Button
                        Name="btnTemporarios"
                        Content="LIMPAR TEMPORARIOS"
                        Height="42"
                        Margin="15,4"
                        Background="#1F2937"
                        Foreground="White"/>


                    <Button
                        Name="btnNavegadores"
                        Content="LIMPAR NAVEGADORES"
                        Height="42"
                        Margin="15,4"
                        Background="#1F2937"
                        Foreground="White"/>


                    <Button
                        Name="btnLixeira"
                        Content="ESVAZIAR LIXEIRA"
                        Height="42"
                        Margin="15,4"
                        Background="#1F2937"
                        Foreground="White"/>


                    <Button
                        Name="btnCompleta"
                        Content="LIMPEZA COMPLETA"
                        Height="42"
                        Margin="15,4"
                        Background="#991B1B"
                        Foreground="White"/>


                    <Button
                        Name="btnSFC"
                        Content="VERIFICAR WINDOWS - SFC"
                        Height="42"
                        Margin="15,4"
                        Background="#1F2937"
                        Foreground="White"/>


                    <Button
                        Name="btnDISM"
                        Content="VERIFICAR WINDOWS - DISM"
                        Height="42"
                        Margin="15,4"
                        Background="#1F2937"
                        Foreground="White"/>


                    <Button
                        Name="btnChrisTitus"
                        Content="WINUTIL - CHRIS TITUS"
                        Height="42"
                        Margin="15,4"
                        Background="#7C3AED"
                        Foreground="White"/>


                    <Button
                        Name="btnSair"
                        Content="SAIR"
                        Height="42"
                        Margin="15,25,15,20"
                        Background="#374151"
                        Foreground="White"/>

                </StackPanel>

            </ScrollViewer>

        </Border>


        <!-- ================================================= -->
        <!-- AREA PRINCIPAL -->
        <!-- ================================================= -->

        <Grid
            Grid.Column="1"
            Margin="35">

            <Grid.RowDefinitions>

                <RowDefinition Height="Auto"/>

                <RowDefinition Height="Auto"/>

                <RowDefinition Height="*"/>

                <RowDefinition Height="Auto"/>

            </Grid.RowDefinitions>


            <!-- TITULO -->

            <TextBlock
                Name="txtTitulo"
                Text="Painel de Controle"
                Foreground="White"
                FontSize="30"
                FontWeight="Bold"/>


            <!-- SUBTITULO -->

            <TextBlock
                Name="txtSubtitulo"
                Grid.Row="1"
                Text="Ferramenta profissional de limpeza, diagnostico e manutencao"
                Foreground="#9CA3AF"
                FontSize="15"
                Margin="0,5,0,20"/>


            <!-- ================================================= -->
            <!-- AREA DE INFORMACOES -->
            <!-- ================================================= -->

            <Grid
                Grid.Row="2">

                <Grid.ColumnDefinitions>

                    <ColumnDefinition Width="*"/>

                    <ColumnDefinition Width="*"/>

                </Grid.ColumnDefinitions>


                <!-- COLUNA ESQUERDA -->

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
                        Padding="20">

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

                </StackPanel>


                <!-- COLUNA DIREITA -->

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


            <!-- RODAPE -->

            <TextBlock
                Name="txtRodape"
                Grid.Row="3"
                Text="TECH INFO BELEM - Cleaner Pro v0.3"
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

$btnSFC = $Window.FindName("btnSFC")

$btnDISM = $Window.FindName("btnDISM")

$btnChrisTitus = $Window.FindName("btnChrisTitus")

$btnSair = $Window.FindName("btnSair")


$txtComputador = $Window.FindName("txtComputador")

$txtWindows = $Window.FindName("txtWindows")

$txtCPU = $Window.FindName("txtCPU")

$txtRAM = $Window.FindName("txtRAM")

$txtDisco = $Window.FindName("txtDisco")

$txtEspaco = $Window.FindName("txtEspaco")

$txtAnalise = $Window.FindName("txtAnalise")

$txtStatus = $Window.FindName("txtStatus")

$txtTitulo = $Window.FindName("txtTitulo")

$txtSubtitulo = $Window.FindName("txtSubtitulo")


# ============================================================
# FUNCAO ATUALIZAR INFORMACOES
# ============================================================

function Atualizar-Informacoes {

    try {

        $computer = Get-CimInstance Win32_ComputerSystem

        $os = Get-CimInstance Win32_OperatingSystem

        $cpu = Get-CimInstance Win32_Processor |
            Select-Object -First 1

        $disk = Get-CimInstance Win32_LogicalDisk `
            -Filter "DeviceID='C:'"


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
# FUNCAO TAMANHO DE PASTA
# ============================================================

function Get-FolderSize {

    param(
        [string]$Path
    )


    $total = 0


    if (Test-Path $Path) {

        try {

            $files = Get-ChildItem `
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


    # Chrome

    $chrome = "$env:LOCALAPPDATA\Google\Chrome\User Data"

    if (Test-Path $chrome) {

        $paths += [PSCustomObject]@{

            Name = "Google Chrome"

            Path = $chrome

        }

    }


    # Edge

    $edge = "$env:LOCALAPPDATA\Microsoft\Edge\User Data"

    if (Test-Path $edge) {

        $paths += [PSCustomObject]@{

            Name = "Microsoft Edge"

            Path = $edge

        }

    }


    # Brave

    $brave = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data"

    if (Test-Path $brave) {

        $paths += [PSCustomObject]@{

            Name = "Brave"

            Path = $brave

        }

    }


    # Opera

    $opera = "$env:APPDATA\Opera Software\Opera Stable"

    if (Test-Path $opera) {

        $paths += [PSCustomObject]@{

            Name = "Opera"

            Path = $opera

        }

    }


    # Opera GX

    $operaGX = "$env:APPDATA\Opera Software\Opera GX Stable"

    if (Test-Path $operaGX) {

        $paths += [PSCustomObject]@{

            Name = "Opera GX"

            Path = $operaGX

        }

    }


    # Firefox

    $firefox = "$env:APPDATA\Mozilla\Firefox\Profiles"

    if (Test-Path $firefox) {

        $profiles = Get-ChildItem `
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
# ANALISAR CACHE DOS NAVEGADORES
# ============================================================

function Get-BrowserCacheSize {

    $total = 0


    $browsers = Get-BrowserCachePaths


    foreach ($browser in $browsers) {

        if ($browser.Name -eq "Firefox") {

            $cache = Join-Path `
                $browser.Path `
                "cache2"


            $total += Get-FolderSize $cache

        }
        else {

            $cache = Join-Path `
                $browser.Path `
                "Default\Cache"


            $total += Get-FolderSize $cache


            $codeCache = Join-Path `
                $browser.Path `
                "Default\Code Cache"


            $total += Get-FolderSize $codeCache


            $gpuCache = Join-Path `
                $browser.Path `
                "Default\GPUCache"


            $total += Get-FolderSize $gpuCache

        }

    }


    return $total

}


# ============================================================
# ANALISAR TEMPORARIOS
# ============================================================

function Get-TemporarySize {

    $total = 0


    $total += Get-FolderSize $env:TEMP


    $total += Get-FolderSize "$env:SystemRoot\Temp"


    $total += Get-FolderSize "$env:LOCALAPPDATA\Microsoft\Windows\INetCache"


    return $total

}


# ============================================================
# ANALISAR LIXEIRA
# ============================================================

function Get-RecycleBinSize {

    $total = 0


    try {

        $items = Get-ChildItem `
            'C:\$Recycle.Bin' `
            -Force `
            -Recurse `
            -ErrorAction SilentlyContinue


        foreach ($item in $items) {

            if (-not $item.PSIsContainer) {

                $total += $item.Length

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


    $Window.Dispatcher.Invoke(
        [Action]{},
        "Render"
    )


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

    $confirmacao = [System.Windows.MessageBox]::Show(

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


    $txtStatus.Text =
        "Iniciando limpeza completa..."


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

        "TECH INFO BELEM - Cleaner Pro v0.3",

        "OK",

        "Information"

    )

}


# ============================================================
# SFC
# ============================================================

function Executar-SFC {

    $confirmacao =
        [System.Windows.MessageBox]::Show(

            "Deseja executar o Verificador de Arquivos do Sistema (SFC)?`n`nEste processo pode levar alguns minutos.",

            "TECH INFO BELEM - SFC",

            "YesNo",

            "Question"

        )


    if ($confirmacao -ne "Yes") {

        return

    }


    $txtStatus.Text =
        "Executando SFC /SCANNOW..."


    Start-Process `
        "cmd.exe" `
        -ArgumentList "/c sfc /scannow" `
        -Wait


    $txtStatus.Text =
        "SFC finalizado"


    [System.Windows.MessageBox]::Show(

        "O processo SFC foi finalizado.`n`nConsulte a janela do sistema para obter detalhes do resultado.",

        "TECH INFO BELEM - SFC",

        "OK",

        "Information"

    )

}


# ============================================================
# DISM
# ============================================================

function Executar-DISM {

    $confirmacao =
        [System.Windows.MessageBox]::Show(

            "Deseja verificar a imagem do Windows usando DISM?`n`nEste processo pode levar alguns minutos.",

            "TECH INFO BELEM - DISM",

            "YesNo",

            "Question"

        )


    if ($confirmacao -ne "Yes") {

        return

    }


    $txtStatus.Text =
        "Executando DISM CheckHealth..."


    Start-Process `
        "cmd.exe" `
        -ArgumentList "/c DISM /Online /Cleanup-Image /CheckHealth" `
        -Wait


    $txtStatus.Text =
        "DISM finalizado"


    [System.Windows.MessageBox]::Show(

        "A verificacao DISM foi finalizada.",

        "TECH INFO BELEM - DISM",

        "OK",

        "Information"

    )

}


# ============================================================
# CHRIS TITUS WINUTIL
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
# EVENTO - INICIO
# ============================================================

$btnInicio.Add_Click({

    $txtTitulo.Text =
        "Painel de Controle"


    $txtSubtitulo.Text =
        "Ferramenta profissional de limpeza, diagnostico e manutencao"


    $txtStatus.Text =
        "Sistema pronto"


    $txtAnalise.Text =
        "Nenhuma analise realizada"


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
# EVENTO - SFC
# ============================================================

$btnSFC.Add_Click({

    Executar-SFC

})


# ============================================================
# EVENTO - DISM
# ============================================================

$btnDISM.Add_Click({

    Executar-DISM

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
# INICIAR
# ============================================================

Atualizar-Informacoes

$Window.ShowDialog() | Out-Null
