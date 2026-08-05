Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

# ============================================================
# TECH INFO BELEM - CLEANER PRO
# VERSAO 0.7
# ============================================================
# NOTA: removemos o $ErrorActionPreference = "SilentlyContinue"
# global. Ele estava mascarando erros reais em todo o script,
# dificultando o diagnostico de problemas. Cada comando que
# realmente pode falhar de forma esperada (ex: pasta que nao
# existe) ja usa -ErrorAction SilentlyContinue individualmente.
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
        "TECH INFO BELEM - Cleaner Pro v0.7",
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
    Title="TECH INFO BELEM - Cleaner Pro v0.7"
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

                    <Button
                        Name="btnHistorico"
                        Content="HISTORICO / FATURAMENTO"
                        Height="40"
                        Margin="15,3"
                        Background="#155E75"
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
                        Name="btnLicenca"
                        Content="STATUS DA LICENCA"
                        Height="40"
                        Margin="15,3"
                        Background="#16A34A"
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

                                <ProgressBar
                                    Name="prgProgresso"
                                    IsIndeterminate="True"
                                    Height="6"
                                    Margin="0,10,0,0"
                                    Background="#111827"
                                    BorderThickness="0"
                                    Foreground="#22C55E"
                                    Visibility="Collapsed"/>

                            </StackPanel>

                        </Border>

                    </StackPanel>

                </Grid>

            </ScrollViewer>

            <TextBlock
                Name="txtRodape"
                Grid.Row="3"
                Text="TECH INFO BELEM - Cleaner Pro v0.7"
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
$btnHistorico = $Window.FindName("btnHistorico")

$btnChrisTitus = $Window.FindName("btnChrisTitus")
$btnLicenca = $Window.FindName("btnLicenca")
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
$prgProgresso = $Window.FindName("prgProgresso")

$txtTitulo = $Window.FindName("txtTitulo")
$txtSubtitulo = $Window.FindName("txtSubtitulo")

# ============================================================
# TRAVA DE TAREFA EM EXECUCAO
# ============================================================
# IMPORTANTE: nao usamos $botao.IsEnabled = $false para bloquear
# os botoes durante uma tarefa. O tema padrao do Windows ignora
# as cores customizadas (Background/Foreground) de um botao
# desabilitado e aplica um estilo cinza-claro por cima, fazendo
# os botoes escuros parecerem "brancos"/apagados.
#
# Em vez disso, usamos um sinalizador logico: se uma tarefa ja
# esta rodando, um novo clique so mostra um aviso e nao inicia
# nada. Os botoes continuam com a aparencia normal o tempo todo.
# ============================================================

$Global:TarefaEmExecucao = $false

# ============================================================
# EXECUCAO ASSINCRONA (evita travar a interface)
# ============================================================
# $Work roda em um processo powershell.exe separado (Start-Job),
# entao NAO pode acessar $txtStatus, $Window, nem funcoes/variaveis
# definidas fora dele. $Work deve ser autossuficiente e retornar
# apenas dados simples (o "return" do fim do bloco).
#
# $OnComplete roda na thread da interface (seguro atualizar
# controles WPF) e recebe o resultado de $Work como parametro.
# ============================================================

function Start-AsyncTask {

    param(
        [Parameter(Mandatory = $true)]
        [scriptblock]$Work,

        [Parameter(Mandatory = $true)]
        [scriptblock]$OnComplete,

        [string]$StatusMessage = "Processando..."
    )

    if ($Global:TarefaEmExecucao) {

        [System.Windows.MessageBox]::Show(
            "Ja existe uma tarefa em execucao.`n`nAguarde a tarefa atual terminar antes de iniciar outra.",
            "TECH INFO BELEM",
            "OK",
            "Warning"
        )

        return

    }

    $Global:TarefaEmExecucao = $true

    $txtStatus.Text = $StatusMessage

    $Window.Cursor = [System.Windows.Input.Cursors]::Wait

    $prgProgresso.Visibility = [System.Windows.Visibility]::Visible

    $job = Start-Job -ScriptBlock $Work

    $timer = New-Object System.Windows.Threading.DispatcherTimer

    $timer.Interval = [TimeSpan]::FromMilliseconds(400)

    $tick = {

        if ($job.State -in @('Completed', 'Failed', 'Stopped')) {

            $timer.Stop()

            try {

                if ($job.State -eq 'Completed') {

                    $resultado = Receive-Job -Job $job -ErrorAction Stop

                    & $OnComplete $resultado

                }
                else {

                    $erro = Receive-Job -Job $job -ErrorAction SilentlyContinue 2>&1

                    $txtStatus.Text = "Erro na tarefa em segundo plano"

                    [System.Windows.MessageBox]::Show(
                        "A tarefa nao foi concluida corretamente.`n`n$erro",
                        "TECH INFO BELEM - Erro",
                        "OK",
                        "Error"
                    )

                }

            }
            catch {

                $txtStatus.Text = "Erro: $($_.Exception.Message)"

            }
            finally {

                Remove-Job -Job $job -Force -ErrorAction SilentlyContinue

                $Global:TarefaEmExecucao = $false

                $Window.Cursor = [System.Windows.Input.Cursors]::Arrow

                $prgProgresso.Visibility = [System.Windows.Visibility]::Collapsed

            }

        }

    }.GetNewClosure()

    $timer.Add_Tick($tick)

    $timer.Start()

}

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
# TAMANHO DE PASTA (helper - usado apenas fora de jobs)
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
# DETECTAR NAVEGADORES (helper - usado apenas fora de jobs)
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
# ANALISAR SISTEMA (ASSINCRONO)
# ============================================================

function Analisar-Sistema {

    $work = {

        function Get-FolderSizeJob {
            param([string]$Path)
            $total = 0
            if (Test-Path $Path) {
                $files = Get-ChildItem -Path $Path -File -Recurse -Force -ErrorAction SilentlyContinue
                foreach ($file in $files) { $total += $file.Length }
            }
            return $total
        }

        # Temporarios
        $tempSize = 0
        $tempSize += Get-FolderSizeJob $env:TEMP
        $tempSize += Get-FolderSizeJob "$env:SystemRoot\Temp"
        $tempSize += Get-FolderSizeJob "$env:LOCALAPPDATA\Microsoft\Windows\INetCache"

        # Navegadores
        $browserSize = 0
        $browserPaths = @()

        $candidatos = @(
            @{ Name = "Chrome";   Path = "$env:LOCALAPPDATA\Google\Chrome\User Data" },
            @{ Name = "Edge";     Path = "$env:LOCALAPPDATA\Microsoft\Edge\User Data" },
            @{ Name = "Brave";    Path = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data" },
            @{ Name = "Opera";    Path = "$env:APPDATA\Opera Software\Opera Stable" },
            @{ Name = "OperaGX";  Path = "$env:APPDATA\Opera Software\Opera GX Stable" }
        )

        foreach ($c in $candidatos) {
            if (Test-Path $c.Path) {
                foreach ($folder in @("Default\Cache", "Default\Code Cache", "Default\GPUCache")) {
                    $browserSize += Get-FolderSizeJob (Join-Path $c.Path $folder)
                }
            }
        }

        $firefoxProfiles = "$env:APPDATA\Mozilla\Firefox\Profiles"
        if (Test-Path $firefoxProfiles) {
            $profiles = Get-ChildItem $firefoxProfiles -Directory -ErrorAction SilentlyContinue
            foreach ($profile in $profiles) {
                $browserSize += Get-FolderSizeJob (Join-Path $profile.FullName "cache2")
            }
        }

        # Lixeira
        $recycleSize = 0
        try {
            $items = Get-ChildItem 'C:\$Recycle.Bin' -Force -Recurse -ErrorAction SilentlyContinue
            foreach ($item in $items) {
                if (-not $item.PSIsContainer) { $recycleSize += $item.Length }
            }
        }
        catch { }

        return [PSCustomObject]@{
            TempSize    = $tempSize
            BrowserSize = $browserSize
            RecycleSize = $recycleSize
        }

    }

    $onComplete = {

        param($resultado)

        $total = $resultado.TempSize + $resultado.BrowserSize + $resultado.RecycleSize

        $totalGB = [math]::Round($total / 1GB, 2)

        $txtAnalise.Text = "$totalGB GB potencialmente recuperaveis"

        $txtStatus.Text = "Analise concluida"

        [System.Windows.MessageBox]::Show(

            "ANALISE CONCLUIDA`n`n" +
            "Arquivos temporarios: $([math]::Round($resultado.TempSize / 1MB, 2)) MB`n`n" +
            "Cache dos navegadores: $([math]::Round($resultado.BrowserSize / 1MB, 2)) MB`n`n" +
            "Lixeira: $([math]::Round($resultado.RecycleSize / 1MB, 2)) MB`n`n" +
            "Total potencialmente recuperavel: $totalGB GB",

            "TECH INFO BELEM - Analise",
            "OK",
            "Information"
        )

    }

    Start-AsyncTask -StatusMessage "Analisando sistema..." -Work $work -OnComplete $onComplete

}

# ============================================================
# LIMPAR TEMPORARIOS (ASSINCRONO)
# ============================================================

function Limpar-Temporarios {

    $work = {

        try {
            Get-ChildItem $env:TEMP -Force -ErrorAction SilentlyContinue |
                Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

            Get-ChildItem "$env:SystemRoot\Temp" -Force -ErrorAction SilentlyContinue |
                Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

            Get-ChildItem "$env:LOCALAPPDATA\Microsoft\Windows\INetCache" -Force -ErrorAction SilentlyContinue |
                Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

            return $true
        }
        catch {
            return $false
        }

    }

    $onComplete = {

        param($sucesso)

        if ($sucesso) {
            $txtStatus.Text = "Temporarios limpos"
        }
        else {
            $txtStatus.Text = "Erro ao limpar temporarios"
        }

    }

    Start-AsyncTask -StatusMessage "Limpando arquivos temporarios..." -Work $work -OnComplete $onComplete

}

# ============================================================
# LIMPAR NAVEGADORES (ASSINCRONO)
# ============================================================

function Limpar-Navegadores {

    $work = {

        $candidatos = @(
            @{ Name = "Chrome";   Path = "$env:LOCALAPPDATA\Google\Chrome\User Data" },
            @{ Name = "Edge";     Path = "$env:LOCALAPPDATA\Microsoft\Edge\User Data" },
            @{ Name = "Brave";    Path = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data" },
            @{ Name = "Opera";    Path = "$env:APPDATA\Opera Software\Opera Stable" },
            @{ Name = "OperaGX";  Path = "$env:APPDATA\Opera Software\Opera GX Stable" }
        )

        foreach ($c in $candidatos) {
            if (Test-Path $c.Path) {
                foreach ($folder in @("Default\Cache", "Default\Code Cache", "Default\GPUCache")) {
                    $cache = Join-Path $c.Path $folder
                    if (Test-Path $cache) {
                        Get-ChildItem $cache -Force -ErrorAction SilentlyContinue |
                            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
                    }
                }
            }
        }

        $firefoxProfiles = "$env:APPDATA\Mozilla\Firefox\Profiles"
        if (Test-Path $firefoxProfiles) {
            $profiles = Get-ChildItem $firefoxProfiles -Directory -ErrorAction SilentlyContinue
            foreach ($profile in $profiles) {
                $cache = Join-Path $profile.FullName "cache2"
                if (Test-Path $cache) {
                    Get-ChildItem $cache -Force -ErrorAction SilentlyContinue |
                        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
                }
            }
        }

        return $true

    }

    $onComplete = {

        param($sucesso)

        $txtStatus.Text = "Caches dos navegadores limpos"

    }

    Start-AsyncTask -StatusMessage "Limpando caches dos navegadores..." -Work $work -OnComplete $onComplete

}

# ============================================================
# LIMPAR LIXEIRA (ASSINCRONO)
# ============================================================

function Limpar-Lixeira {

    $work = {

        try {
            Clear-RecycleBin -Force -ErrorAction SilentlyContinue
            return $true
        }
        catch {
            return $false
        }

    }

    $onComplete = {

        param($sucesso)

        if ($sucesso) {
            $txtStatus.Text = "Lixeira esvaziada"
        }
        else {
            $txtStatus.Text = "Erro ao esvaziar lixeira"
        }

    }

    Start-AsyncTask -StatusMessage "Esvaziando lixeira..." -Work $work -OnComplete $onComplete

}

# ============================================================
# LIMPEZA COMPLETA (ASSINCRONO - uma unica tarefa combinada)
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

    if ($confirmacao -ne "Yes") { return }

    $diskBefore = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $Global:FreeBeforeLimpeza = $diskBefore.FreeSpace

    $work = {

        # Temporarios
        Get-ChildItem $env:TEMP -Force -ErrorAction SilentlyContinue |
            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        Get-ChildItem "$env:SystemRoot\Temp" -Force -ErrorAction SilentlyContinue |
            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        Get-ChildItem "$env:LOCALAPPDATA\Microsoft\Windows\INetCache" -Force -ErrorAction SilentlyContinue |
            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

        # Navegadores
        $candidatos = @(
            @{ Name = "Chrome";   Path = "$env:LOCALAPPDATA\Google\Chrome\User Data" },
            @{ Name = "Edge";     Path = "$env:LOCALAPPDATA\Microsoft\Edge\User Data" },
            @{ Name = "Brave";    Path = "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data" },
            @{ Name = "Opera";    Path = "$env:APPDATA\Opera Software\Opera Stable" },
            @{ Name = "OperaGX";  Path = "$env:APPDATA\Opera Software\Opera GX Stable" }
        )
        foreach ($c in $candidatos) {
            if (Test-Path $c.Path) {
                foreach ($folder in @("Default\Cache", "Default\Code Cache", "Default\GPUCache")) {
                    $cache = Join-Path $c.Path $folder
                    if (Test-Path $cache) {
                        Get-ChildItem $cache -Force -ErrorAction SilentlyContinue |
                            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
                    }
                }
            }
        }
        $firefoxProfiles = "$env:APPDATA\Mozilla\Firefox\Profiles"
        if (Test-Path $firefoxProfiles) {
            $profiles = Get-ChildItem $firefoxProfiles -Directory -ErrorAction SilentlyContinue
            foreach ($profile in $profiles) {
                $cache = Join-Path $profile.FullName "cache2"
                if (Test-Path $cache) {
                    Get-ChildItem $cache -Force -ErrorAction SilentlyContinue |
                        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
                }
            }
        }

        # Lixeira
        Clear-RecycleBin -Force -ErrorAction SilentlyContinue

        return $true

    }

    $onComplete = {

        param($sucesso)

        $diskAfter = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
        $freed = $diskAfter.FreeSpace - $Global:FreeBeforeLimpeza

        $freedMB = [math]::Round($freed / 1MB, 2)
        $freedGB = [math]::Round($freed / 1GB, 2)

        Atualizar-Informacoes

        $txtAnalise.Text = "$freedGB GB liberados"
        $txtStatus.Text = "Limpeza completa concluida"

        [System.Windows.MessageBox]::Show(

            "LIMPEZA COMPLETA FINALIZADA`n`n" +
            "Espaco liberado: $freedMB MB`n`n" +
            "O Cleaner Pro concluiu a manutencao.",

            "TECH INFO BELEM - Cleaner Pro v0.7",
            "OK",
            "Information"
        )

    }

    Start-AsyncTask -StatusMessage "Executando limpeza completa..." -Work $work -OnComplete $onComplete

}

# ============================================================
# DIAGNOSTICO WINDOWS (ASSINCRONO)
# ============================================================

function Diagnosticar-Windows {

    $work = {

        $dism = Start-Process "DISM.exe" -ArgumentList "/Online /Cleanup-Image /ScanHealth" -Wait -PassThru -WindowStyle Hidden
        $sfc = Start-Process "sfc.exe" -ArgumentList "/verifyonly" -Wait -PassThru -WindowStyle Hidden

        return [PSCustomObject]@{
            DismExitCode = $dism.ExitCode
            SfcExitCode  = $sfc.ExitCode
        }

    }

    $onComplete = {

        param($resultado)

        $txtStatus.Text = "Diagnostico do Windows concluido"

        [System.Windows.MessageBox]::Show(

            "O diagnostico do Windows foi concluido.`n`n" +
            "DISM ExitCode: $($resultado.DismExitCode)`n" +
            "SFC ExitCode: $($resultado.SfcExitCode)`n`n" +
            "Para uma analise detalhada, consulte os logs do Windows.",

            "TECH INFO BELEM - Diagnostico Windows",
            "OK",
            "Information"
        )

    }

    Start-AsyncTask -StatusMessage "Executando diagnostico do Windows (DISM + SFC)..." -Work $work -OnComplete $onComplete

}

# ============================================================
# REPARAR WINDOWS (ASSINCRONO)
# ============================================================

function Reparar-Windows {

    $confirmacao =
        [System.Windows.MessageBox]::Show(

            "O processo executara:`n`n" +
            "1. DISM /RestoreHealth`n" +
            "2. SFC /scannow`n`n" +
            "O processo pode levar varios minutos. A interface continuara" +
            " responsiva, mas evite fechar o programa.`n`n" +
            "Deseja continuar?",

            "TECH INFO BELEM - Reparar Windows",
            "YesNo",
            "Warning"
        )

    if ($confirmacao -ne "Yes") { return }

    $work = {

        $dism = Start-Process "DISM.exe" -ArgumentList "/Online /Cleanup-Image /RestoreHealth" -Wait -PassThru -WindowStyle Hidden
        $sfc = Start-Process "sfc.exe" -ArgumentList "/scannow" -Wait -PassThru -WindowStyle Hidden

        return [PSCustomObject]@{
            DismExitCode = $dism.ExitCode
            SfcExitCode  = $sfc.ExitCode
        }

    }

    $onComplete = {

        param($resultado)

        $txtStatus.Text = "Reparo do Windows concluido"

        [System.Windows.MessageBox]::Show(

            "PROCESSO DE REPARACAO FINALIZADO`n`n" +
            "DISM ExitCode: $($resultado.DismExitCode)`n" +
            "SFC ExitCode: $($resultado.SfcExitCode)`n`n" +
            "Recomendamos reiniciar o computador caso o sistema tenha apresentado problemas.",

            "TECH INFO BELEM - Reparar Windows",
            "OK",
            "Information"
        )

    }

    Start-AsyncTask -StatusMessage "Reparando o Windows (DISM + SFC) - isso pode levar varios minutos..." -Work $work -OnComplete $onComplete

}

# ============================================================
# SAUDE DOS DISCOS (ASSINCRONO)
# ============================================================

function Verificar-SaudeDiscos {

    $work = {

        try {
            $physicalDisks = Get-PhysicalDisk -ErrorAction Stop
            return [PSCustomObject]@{ Sucesso = $true; Discos = $physicalDisks }
        }
        catch {
            return [PSCustomObject]@{ Sucesso = $false; Discos = @() }
        }

    }

    $onComplete = {

        param($resultado)

        if (-not $resultado.Sucesso) {

            $txtSaudeDisco.Text = "Nao disponivel"
            $txtStatus.Text = "Nao foi possivel consultar os discos"

            [System.Windows.MessageBox]::Show(
                "Nao foi possivel obter informacoes de saude dos discos.`n`nIsso pode ocorrer devido ao driver ou ao tipo de armazenamento.",
                "TECH INFO BELEM - Diagnostico",
                "OK",
                "Warning"
            )

            return
        }

        $resultadoTexto = ""

        foreach ($disk in $resultado.Discos) {

            $tamanho = [math]::Round($disk.Size / 1GB, 1)

            $resultadoTexto +=
                "Modelo: $($disk.FriendlyName)`n" +
                "Tipo: $($disk.MediaType)`n" +
                "Capacidade: $tamanho GB`n" +
                "Saude: $($disk.HealthStatus)`n" +
                "Status: $($disk.OperationalStatus)`n`n"

        }

        if ([string]::IsNullOrWhiteSpace($resultadoTexto)) {
            $resultadoTexto = "Nenhum disco fisico foi identificado."
        }

        $txtSaudeDisco.Text = "Analise concluida"
        $txtStatus.Text = "Diagnostico de armazenamento concluido"

        [System.Windows.MessageBox]::Show(
            $resultadoTexto,
            "TECH INFO BELEM - Saude SSD / HD",
            "OK",
            "Information"
        )

    }

    Start-AsyncTask -StatusMessage "Analisando armazenamento..." -Work $work -OnComplete $onComplete

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

    if ($confirmacao -ne "Yes") { return }

    $txtStatusMemoria.Text = "Diagnostico agendado"
    $txtStatus.Text = "Abrindo Diagnostico de Memoria..."

    Start-Process "mdsched.exe"

    $txtStatusMemoria.Text = "Aguardando teste do Windows"
    $txtStatus.Text = "Diagnostico de memoria aberto"

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

    $txtStatus.Text = "Coletando informacoes de hardware..."

    try {

        $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
        $computer = Get-CimInstance Win32_ComputerSystem
        $gpu = Get-CimInstance Win32_VideoController

        $resultado =
            "PROCESSADOR`n$($cpu.Name)`n`n" +
            "NUCLEOS: $($cpu.NumberOfCores)`n" +
            "THREADS: $($cpu.NumberOfLogicalProcessors)`n`n" +
            "MEMORIA RAM`n$([math]::Round($computer.TotalPhysicalMemory / 1GB, 1)) GB`n`n" +
            "PLACA DE VIDEO`n"

        foreach ($video in $gpu) {
            $resultado += "$($video.Name)`n"
        }

        $txtStatus.Text = "Informacoes de hardware coletadas"

        [System.Windows.MessageBox]::Show(
            $resultado,
            "TECH INFO BELEM - Hardware",
            "OK",
            "Information"
        )

    }
    catch {

        $txtStatus.Text = "Erro ao coletar hardware"

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

        $txtStatus.Text = "Abrindo Chris Titus WinUtil..."

        try {

            Invoke-RestMethod "https://christitus.com/win" | Invoke-Expression

            $txtStatus.Text = "Chris Titus WinUtil iniciado"

        }
        catch {

            $txtStatus.Text = "Erro ao abrir Chris Titus WinUtil"

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
# STATUS DA LICENCA DO WINDOWS
# ============================================================
# Usa a ferramenta nativa do Windows (slmgr.vbs) apenas para
# CONSULTAR o status atual da licenca (ativado, em trial, tipo
# de licenca, dias restantes). Nao ativa, nao altera e nao
# burla nada - e so leitura de informacao, util para saber o
# que informar ao cliente no atendimento.
# ============================================================

function Verificar-StatusLicenca {

    $txtStatus.Text = "Verificando status da licenca..."

    try {

        $slmgrPath = Join-Path $env:windir "System32\slmgr.vbs"

        if (-not (Test-Path $slmgrPath)) {
            throw "slmgr.vbs nao encontrado no sistema."
        }

        $resultado =
            & cscript.exe //nologo $slmgrPath /xpr 2>&1 |
            Out-String

        $txtStatus.Text = "Status da licenca verificado"

        [System.Windows.MessageBox]::Show(
            $resultado.Trim(),
            "TECH INFO BELEM - Status da Licenca",
            "OK",
            "Information"
        )

    }
    catch {

        $txtStatus.Text = "Erro ao verificar status da licenca"

        [System.Windows.MessageBox]::Show(
            "Nao foi possivel verificar o status da licenca.`n`nErro:`n$($_.Exception.Message)",
            "TECH INFO BELEM - Erro",
            "OK",
            "Error"
        )

    }

}

# ============================================================
# BANCO DE DADOS (SQLite) - RELATORIOS DE SERVICO
# ============================================================
# O Cleaner Pro roda via "irm | iex" direto da internet, entao
# nao ha garantia de que o modulo PSSQLite ja esteja instalado
# no PC do cliente. Por isso, tentamos instalar na hora (precisa
# de internet no primeiro uso). Se nao conseguir, o relatorio
# HTML continua sendo salvo normalmente - so o registro no banco
# fica pendente, com aviso claro para o tecnico.
# ============================================================

$Global:CaminhoPastaRelatorios = "C:\Relatorio Tech Info Belem"
$Global:CaminhoBancoDados = Join-Path $Global:CaminhoPastaRelatorios "relatorios.sqlite"

function ConvertTo-ValorNumerico {

    param(
        [string]$Texto
    )

    if ([string]::IsNullOrWhiteSpace($Texto)) {
        return 0.0
    }

    $limpo = $Texto -replace '[^\d,\.]', ''

    if ($limpo -match ',\d{1,2}$') {
        # formato brasileiro: 1.500,00 -> 1500.00
        $limpo = $limpo -replace '\.', ''
        $limpo = $limpo -replace ',', '.'
    }
    else {
        $limpo = $limpo -replace ',', ''
    }

    $valor = 0.0
    [void][double]::TryParse(
        $limpo,
        [Globalization.NumberStyles]::Any,
        [Globalization.CultureInfo]::InvariantCulture,
        [ref]$valor
    )

    return $valor

}

function Ensure-SQLiteModule {

    if (Get-Module -ListAvailable -Name PSSQLite) {

        try {
            Import-Module PSSQLite -ErrorAction Stop
            return $true
        }
        catch {
            return $false
        }

    }

    try {

        [Net.ServicePointManager]::SecurityProtocol =
            [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

        $repositorio = Get-PSRepository -Name PSGallery -ErrorAction SilentlyContinue

        if ($repositorio -and $repositorio.InstallationPolicy -ne 'Trusted') {
            Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -ErrorAction SilentlyContinue
        }

        if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
            Install-PackageProvider -Name NuGet -Force -Scope CurrentUser -ErrorAction Stop | Out-Null
        }

        Install-Module -Name PSSQLite -Scope CurrentUser -Force -AllowClobber -ErrorAction Stop

        Import-Module PSSQLite -ErrorAction Stop

        return $true

    }
    catch {

        return $false

    }

}

function Initialize-BancoDeDados {

    if (-not (Test-Path $Global:CaminhoPastaRelatorios)) {
        New-Item -Path $Global:CaminhoPastaRelatorios -ItemType Directory -Force -ErrorAction Stop | Out-Null
    }

    $criarTabela = @"
CREATE TABLE IF NOT EXISTS Relatorios (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    DataHoraIso TEXT,
    DataFormatada TEXT,
    Cliente TEXT,
    Telefone TEXT,
    Servico TEXT,
    Valor REAL,
    Pagamento TEXT,
    Observacoes TEXT,
    Computador TEXT,
    ArquivoHTML TEXT
);
"@

    Invoke-SqliteQuery -DataSource $Global:CaminhoBancoDados -Query $criarTabela

}

function Salvar-RelatorioNoBanco {

    param(
        [string]$DataHoraIso,
        [string]$DataFormatada,
        [string]$Cliente,
        [string]$Telefone,
        [string]$Servico,
        [double]$Valor,
        [string]$Pagamento,
        [string]$Observacoes,
        [string]$Computador,
        [string]$ArquivoHTML
    )

    if (-not (Ensure-SQLiteModule)) {
        return $false
    }

    try {

        Initialize-BancoDeDados

        $insertQuery = @"
INSERT INTO Relatorios
    (DataHoraIso, DataFormatada, Cliente, Telefone, Servico, Valor, Pagamento, Observacoes, Computador, ArquivoHTML)
VALUES
    (@DataHoraIso, @DataFormatada, @Cliente, @Telefone, @Servico, @Valor, @Pagamento, @Observacoes, @Computador, @ArquivoHTML);
"@

        $parametros = @{
            DataHoraIso   = $DataHoraIso
            DataFormatada = $DataFormatada
            Cliente       = $Cliente
            Telefone      = $Telefone
            Servico       = $Servico
            Valor         = $Valor
            Pagamento     = $Pagamento
            Observacoes   = $Observacoes
            Computador    = $Computador
            ArquivoHTML   = $ArquivoHTML
        }

        Invoke-SqliteQuery -DataSource $Global:CaminhoBancoDados -Query $insertQuery -SqlParameters $parametros

        return $true

    }
    catch {

        return $false

    }

}

# ============================================================
# JANELA DE HISTORICO / FATURAMENTO
# ============================================================

function Abrir-HistoricoServicos {

    $txtStatus.Text = "Abrindo historico de servicos..."

    if (-not (Ensure-SQLiteModule)) {

        $txtStatus.Text = "Banco de dados indisponivel"

        [System.Windows.MessageBox]::Show(
            "Nao foi possivel carregar o banco de dados.`n`nIsso normalmente acontece por falta de conexao com a internet no primeiro uso (o modulo PSSQLite precisa ser baixado uma vez).`n`nVerifique sua internet e tente novamente.",
            "TECH INFO BELEM - Banco de Dados",
            "OK",
            "Warning"
        )

        return

    }

    try {
        Initialize-BancoDeDados
    }
    catch {

        $txtStatus.Text = "Erro ao abrir o banco de dados"

        [System.Windows.MessageBox]::Show(
            "Nao foi possivel abrir o banco de dados.`n`nErro:`n$($_.Exception.Message)",
            "TECH INFO BELEM - Erro",
            "OK",
            "Error"
        )

        return

    }

    # ------------------------------------------------------------
    # JANELA
    # ------------------------------------------------------------

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "TECH INFO BELEM - Historico e Faturamento"
    $form.Size = New-Object System.Drawing.Size(950,650)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = [System.Drawing.Color]::FromArgb(17,24,39)
    $form.ForeColor = [System.Drawing.Color]::White
    $form.FormBorderStyle = "Sizable"
    $form.MinimumSize = New-Object System.Drawing.Size(750,500)

    $lblPeriodo = New-Object System.Windows.Forms.Label
    $lblPeriodo.Text = "PERIODO"
    $lblPeriodo.Location = New-Object System.Drawing.Point(20,20)
    $lblPeriodo.Size = New-Object System.Drawing.Size(150,25)
    $form.Controls.Add($lblPeriodo)

    $cmbPeriodo = New-Object System.Windows.Forms.ComboBox
    $cmbPeriodo.Location = New-Object System.Drawing.Point(20,45)
    $cmbPeriodo.Size = New-Object System.Drawing.Size(200,30)
    $cmbPeriodo.DropDownStyle = "DropDownList"
    [void]$cmbPeriodo.Items.Add("Mes atual")
    [void]$cmbPeriodo.Items.Add("Mes anterior")
    [void]$cmbPeriodo.Items.Add("Ano atual")
    [void]$cmbPeriodo.Items.Add("Todos os periodos")
    [void]$cmbPeriodo.Items.Add("Personalizado")
    $cmbPeriodo.SelectedIndex = 0
    $form.Controls.Add($cmbPeriodo)

    $lblDe = New-Object System.Windows.Forms.Label
    $lblDe.Text = "DE"
    $lblDe.Location = New-Object System.Drawing.Point(240,20)
    $lblDe.Size = New-Object System.Drawing.Size(100,25)
    $form.Controls.Add($lblDe)

    $dtInicio = New-Object System.Windows.Forms.DateTimePicker
    $dtInicio.Location = New-Object System.Drawing.Point(240,45)
    $dtInicio.Size = New-Object System.Drawing.Size(150,30)
    $dtInicio.Format = "Short"
    $dtInicio.Enabled = $false
    $form.Controls.Add($dtInicio)

    $lblAte = New-Object System.Windows.Forms.Label
    $lblAte.Text = "ATE"
    $lblAte.Location = New-Object System.Drawing.Point(410,20)
    $lblAte.Size = New-Object System.Drawing.Size(100,25)
    $form.Controls.Add($lblAte)

    $dtFim = New-Object System.Windows.Forms.DateTimePicker
    $dtFim.Location = New-Object System.Drawing.Point(410,45)
    $dtFim.Size = New-Object System.Drawing.Size(150,30)
    $dtFim.Format = "Short"
    $dtFim.Enabled = $false
    $form.Controls.Add($dtFim)

    $cmbPeriodo.Add_SelectedIndexChanged({
        $habilitado = ($cmbPeriodo.SelectedItem -eq "Personalizado")
        $dtInicio.Enabled = $habilitado
        $dtFim.Enabled = $habilitado
    })

    $btnBuscar = New-Object System.Windows.Forms.Button
    $btnBuscar.Text = "BUSCAR"
    $btnBuscar.Location = New-Object System.Drawing.Point(580,44)
    $btnBuscar.Size = New-Object System.Drawing.Size(110,32)
    $btnBuscar.BackColor = [System.Drawing.Color]::FromArgb(21,94,117)
    $btnBuscar.ForeColor = [System.Drawing.Color]::White
    $form.Controls.Add($btnBuscar)

    $btnExportarCsv = New-Object System.Windows.Forms.Button
    $btnExportarCsv.Text = "EXPORTAR CSV"
    $btnExportarCsv.Location = New-Object System.Drawing.Point(700,44)
    $btnExportarCsv.Size = New-Object System.Drawing.Size(130,32)
    $btnExportarCsv.BackColor = [System.Drawing.Color]::FromArgb(55,65,81)
    $btnExportarCsv.ForeColor = [System.Drawing.Color]::White
    $form.Controls.Add($btnExportarCsv)

    $dgvResultados = New-Object System.Windows.Forms.DataGridView
    $dgvResultados.Location = New-Object System.Drawing.Point(20,90)
    $dgvResultados.Size = New-Object System.Drawing.Size(890,440)
    $dgvResultados.Anchor = "Top,Bottom,Left,Right"
    $dgvResultados.ReadOnly = $true
    $dgvResultados.AllowUserToAddRows = $false
    $dgvResultados.AllowUserToDeleteRows = $false
    $dgvResultados.SelectionMode = "FullRowSelect"
    $dgvResultados.AutoSizeColumnsMode = "Fill"
    $dgvResultados.BackgroundColor = [System.Drawing.Color]::FromArgb(31,41,55)
    $form.Controls.Add($dgvResultados)

    $lblTotal = New-Object System.Windows.Forms.Label
    $lblTotal.Text = "Atendimentos: 0    |    Total faturado: R$ 0,00"
    $lblTotal.Location = New-Object System.Drawing.Point(20,540)
    $lblTotal.Size = New-Object System.Drawing.Size(890,30)
    $lblTotal.Anchor = "Bottom,Left,Right"
    $lblTotal.Font = New-Object System.Drawing.Font("Arial",12,[System.Drawing.FontStyle]::Bold)
    $lblTotal.ForeColor = [System.Drawing.Color]::FromArgb(34,197,94)
    $form.Controls.Add($lblTotal)

    $script:UltimaTabelaResultados = $null

    $buscar = {

        try {

            switch ($cmbPeriodo.SelectedItem) {

                "Mes atual" {
                    $inicio = Get-Date -Day 1 -Hour 0 -Minute 0 -Second 0
                    $fim = $inicio.AddMonths(1)
                }
                "Mes anterior" {
                    $inicioAtual = Get-Date -Day 1 -Hour 0 -Minute 0 -Second 0
                    $inicio = $inicioAtual.AddMonths(-1)
                    $fim = $inicioAtual
                }
                "Ano atual" {
                    $inicio = Get-Date -Month 1 -Day 1 -Hour 0 -Minute 0 -Second 0
                    $fim = $inicio.AddYears(1)
                }
                "Personalizado" {
                    $inicio = $dtInicio.Value.Date
                    $fim = $dtFim.Value.Date.AddDays(1)
                }
                default {
                    $inicio = [DateTime]::MinValue
                    $fim = [DateTime]::MaxValue
                }

            }

            $inicioStr = $inicio.ToString("yyyy-MM-dd HH:mm:ss")
            $fimStr = $fim.ToString("yyyy-MM-dd HH:mm:ss")

            $query = "SELECT DataFormatada AS Data, Cliente, Servico, Valor, Pagamento, ArquivoHTML FROM Relatorios WHERE DataHoraIso >= @Inicio AND DataHoraIso < @Fim ORDER BY DataHoraIso DESC"

            $tabela = Invoke-SqliteQuery -DataSource $Global:CaminhoBancoDados -Query $query -SqlParameters @{ Inicio = $inicioStr; Fim = $fimStr } -As DataTable

            $dgvResultados.DataSource = $tabela

            if ($dgvResultados.Columns["ArquivoHTML"]) {
                $dgvResultados.Columns["ArquivoHTML"].Visible = $false
            }

            $script:UltimaTabelaResultados = $tabela

            $total = 0.0

            foreach ($linha in $tabela.Rows) {
                $total += [double]$linha["Valor"]
            }

            $lblTotal.Text = "Atendimentos: $($tabela.Rows.Count)    |    Total faturado: R$ $([math]::Round($total,2))"

        }
        catch {

            [System.Windows.Forms.MessageBox]::Show(
                "Erro ao consultar o banco de dados:`n`n$($_.Exception.Message)",
                "TECH INFO BELEM - Erro",
                "OK",
                "Error"
            )

        }

    }

    $btnBuscar.Add_Click($buscar)

    $btnExportarCsv.Add_Click({

        if (-not $script:UltimaTabelaResultados -or $script:UltimaTabelaResultados.Rows.Count -eq 0) {
            [System.Windows.Forms.MessageBox]::Show(
                "Nao ha resultados para exportar. Clique em BUSCAR primeiro.",
                "TECH INFO BELEM",
                "OK",
                "Warning"
            )
            return
        }

        $salvarDialog = New-Object System.Windows.Forms.SaveFileDialog
        $salvarDialog.Filter = "Arquivo CSV (*.csv)|*.csv"
        $salvarDialog.FileName = "Faturamento_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"

        if ($salvarDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {

            try {
                $script:UltimaTabelaResultados |
                    Select-Object Data, Cliente, Servico, Valor, Pagamento |
                    Export-Csv -Path $salvarDialog.FileName -NoTypeInformation -Encoding UTF8 -Delimiter ";"

                [System.Windows.Forms.MessageBox]::Show(
                    "Arquivo exportado com sucesso!",
                    "TECH INFO BELEM",
                    "OK",
                    "Information"
                )
            }
            catch {
                [System.Windows.Forms.MessageBox]::Show(
                    "Erro ao exportar:`n`n$($_.Exception.Message)",
                    "TECH INFO BELEM - Erro",
                    "OK",
                    "Error"
                )
            }

        }

    })

    $dgvResultados.Add_CellDoubleClick({

        param($sender, $e)

        if ($e.RowIndex -ge 0 -and $script:UltimaTabelaResultados) {

            $arquivo = $dgvResultados.Rows[$e.RowIndex].Cells["ArquivoHTML"].Value

            if ($arquivo -and (Test-Path $arquivo)) {
                Start-Process -FilePath $arquivo
            }
            else {
                [System.Windows.Forms.MessageBox]::Show(
                    "O arquivo do relatorio nao foi encontrado no caminho original.",
                    "TECH INFO BELEM",
                    "OK",
                    "Warning"
                )
            }

        }

    })

    # busca inicial (mes atual)
    & $buscar

    $txtStatus.Text = "Historico de servicos aberto"

    [void]$form.ShowDialog()

}

function Gerar-RelatorioServico {

    # ============================================================
    # JANELA DE PREENCHIMENTO
    # ============================================================

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "TECH INFO BELEM - Relatorio de Servico"
    $form.Size = New-Object System.Drawing.Size(650,650)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = [System.Drawing.Color]::FromArgb(17,24,39)
    $form.ForeColor = [System.Drawing.Color]::White
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false

    $lblTitulo = New-Object System.Windows.Forms.Label
    $lblTitulo.Text = "RELATORIO DE SERVICO TECH INFO BELEM"
    $lblTitulo.Location = New-Object System.Drawing.Point(25,20)
    $lblTitulo.Size = New-Object System.Drawing.Size(580,35)
    $lblTitulo.Font = New-Object System.Drawing.Font("Arial",16,[System.Drawing.FontStyle]::Bold)
    $lblTitulo.ForeColor = [System.Drawing.Color]::FromArgb(96,165,250)
    $form.Controls.Add($lblTitulo)

    $lblCliente = New-Object System.Windows.Forms.Label
    $lblCliente.Text = "CLIENTE"
    $lblCliente.Location = New-Object System.Drawing.Point(25,75)
    $lblCliente.Size = New-Object System.Drawing.Size(150,25)
    $form.Controls.Add($lblCliente)

    $txtClienteForm = New-Object System.Windows.Forms.TextBox
    $txtClienteForm.Location = New-Object System.Drawing.Point(25,100)
    $txtClienteForm.Size = New-Object System.Drawing.Size(580,30)
    $form.Controls.Add($txtClienteForm)

    $lblTelefone = New-Object System.Windows.Forms.Label
    $lblTelefone.Text = "TELEFONE / CONTATO"
    $lblTelefone.Location = New-Object System.Drawing.Point(25,140)
    $lblTelefone.Size = New-Object System.Drawing.Size(200,25)
    $form.Controls.Add($lblTelefone)

    $txtTelefoneForm = New-Object System.Windows.Forms.TextBox
    $txtTelefoneForm.Location = New-Object System.Drawing.Point(25,165)
    $txtTelefoneForm.Size = New-Object System.Drawing.Size(580,30)
    $form.Controls.Add($txtTelefoneForm)

    $lblServico = New-Object System.Windows.Forms.Label
    $lblServico.Text = "SERVICO REALIZADO"
    $lblServico.Location = New-Object System.Drawing.Point(25,205)
    $lblServico.Size = New-Object System.Drawing.Size(200,25)
    $form.Controls.Add($lblServico)

    $txtServicoForm = New-Object System.Windows.Forms.TextBox
    $txtServicoForm.Location = New-Object System.Drawing.Point(25,230)
    $txtServicoForm.Size = New-Object System.Drawing.Size(580,80)
    $txtServicoForm.Multiline = $true
    $txtServicoForm.ScrollBars = "Vertical"
    $form.Controls.Add($txtServicoForm)

    $lblValor = New-Object System.Windows.Forms.Label
    $lblValor.Text = "VALOR DO SERVICO (R$)"
    $lblValor.Location = New-Object System.Drawing.Point(25,320)
    $lblValor.Size = New-Object System.Drawing.Size(200,25)
    $form.Controls.Add($lblValor)

    $txtValorForm = New-Object System.Windows.Forms.TextBox
    $txtValorForm.Location = New-Object System.Drawing.Point(25,345)
    $txtValorForm.Size = New-Object System.Drawing.Size(200,30)
    $form.Controls.Add($txtValorForm)

    $lblPagamento = New-Object System.Windows.Forms.Label
    $lblPagamento.Text = "FORMA DE PAGAMENTO"
    $lblPagamento.Location = New-Object System.Drawing.Point(250,320)
    $lblPagamento.Size = New-Object System.Drawing.Size(200,25)
    $form.Controls.Add($lblPagamento)

    $cmbPagamentoForm = New-Object System.Windows.Forms.ComboBox
    $cmbPagamentoForm.Location = New-Object System.Drawing.Point(250,345)
    $cmbPagamentoForm.Size = New-Object System.Drawing.Size(355,30)
    $cmbPagamentoForm.DropDownStyle = "DropDownList"
    [void]$cmbPagamentoForm.Items.Add("PIX")
    [void]$cmbPagamentoForm.Items.Add("Dinheiro")
    [void]$cmbPagamentoForm.Items.Add("Cartao de Credito")
    [void]$cmbPagamentoForm.Items.Add("Cartao de Debito")
    [void]$cmbPagamentoForm.Items.Add("Transferencia")
    [void]$cmbPagamentoForm.Items.Add("Nao informado")
    $cmbPagamentoForm.SelectedIndex = 0
    $form.Controls.Add($cmbPagamentoForm)

    $lblObservacoes = New-Object System.Windows.Forms.Label
    $lblObservacoes.Text = "OBSERVACOES TECNICAS"
    $lblObservacoes.Location = New-Object System.Drawing.Point(25,390)
    $lblObservacoes.Size = New-Object System.Drawing.Size(250,25)
    $form.Controls.Add($lblObservacoes)

    $txtObservacoesForm = New-Object System.Windows.Forms.TextBox
    $txtObservacoesForm.Location = New-Object System.Drawing.Point(25,415)
    $txtObservacoesForm.Size = New-Object System.Drawing.Size(580,70)
    $txtObservacoesForm.Multiline = $true
    $txtObservacoesForm.ScrollBars = "Vertical"
    $form.Controls.Add($txtObservacoesForm)

    $btnCancelarForm = New-Object System.Windows.Forms.Button
    $btnCancelarForm.Text = "CANCELAR"
    $btnCancelarForm.Location = New-Object System.Drawing.Point(350,520)
    $btnCancelarForm.Size = New-Object System.Drawing.Size(120,40)
    $btnCancelarForm.BackColor = [System.Drawing.Color]::FromArgb(55,65,81)
    $btnCancelarForm.ForeColor = [System.Drawing.Color]::White
    $btnCancelarForm.Add_Click({
        $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        $form.Close()
    })
    $form.Controls.Add($btnCancelarForm)

    $btnGerarForm = New-Object System.Windows.Forms.Button
    $btnGerarForm.Text = "GERAR RELATORIO"
    $btnGerarForm.Location = New-Object System.Drawing.Point(480,520)
    $btnGerarForm.Size = New-Object System.Drawing.Size(125,40)
    $btnGerarForm.BackColor = [System.Drawing.Color]::FromArgb(3,105,161)
    $btnGerarForm.ForeColor = [System.Drawing.Color]::White
    $btnGerarForm.Add_Click({
        if ([string]::IsNullOrWhiteSpace($txtServicoForm.Text)) {
            [System.Windows.Forms.MessageBox]::Show(
                "Digite o servico realizado.",
                "TECH INFO BELEM",
                "OK",
                "Warning"
            )
            return
        }
        $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
        $form.Close()
    })
    $form.Controls.Add($btnGerarForm)

    $resultado = $form.ShowDialog()

    if ($resultado -ne [System.Windows.Forms.DialogResult]::OK) {
        $txtStatus.Text = "Geracao do relatorio cancelada"
        return
    }

    try {

        $txtStatus.Text = "Coletando informacoes para o relatorio..."

        $computer = Get-CimInstance Win32_ComputerSystem
        $os = Get-CimInstance Win32_OperatingSystem
        $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
        $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"

        $ramGB = [math]::Round($computer.TotalPhysicalMemory / 1GB, 1)
        $freeGB = [math]::Round($disk.FreeSpace / 1GB, 1)
        $totalGB = [math]::Round($disk.Size / 1GB, 1)

        $gpu = @(Get-CimInstance Win32_VideoController)
        $physicalDisks = @(Get-PhysicalDisk -ErrorAction SilentlyContinue)

        $data = Get-Date -Format "dd/MM/yyyy HH:mm"

        $clienteRaw = $txtClienteForm.Text.Trim()

        if ([string]::IsNullOrWhiteSpace($clienteRaw)) {
            $clienteRaw = "Cliente nao informado"
        }

        $telefoneRaw = $txtTelefoneForm.Text
        $servicoRaw = $txtServicoForm.Text
        $valorRaw = $txtValorForm.Text
        $pagamentoRaw = $cmbPagamentoForm.SelectedItem.ToString()
        $observacoesRaw = $txtObservacoesForm.Text

        $cliente = [System.Net.WebUtility]::HtmlEncode($clienteRaw)
        $telefone = [System.Net.WebUtility]::HtmlEncode($telefoneRaw)
        $servico = [System.Net.WebUtility]::HtmlEncode($servicoRaw)
        $valor = [System.Net.WebUtility]::HtmlEncode($valorRaw)
        $pagamento = [System.Net.WebUtility]::HtmlEncode($pagamentoRaw)
        $observacoes = [System.Net.WebUtility]::HtmlEncode($observacoesRaw)

        $servico = $servico -replace "`r`n","<br>"
        $servico = $servico -replace "`n","<br>"
        $observacoes = $observacoes -replace "`r`n","<br>"
        $observacoes = $observacoes -replace "`n","<br>"

        $reportFolder = "C:\Relatorio Tech Info Belem"

        if (!(Test-Path -LiteralPath $reportFolder)) {
            New-Item -Path $reportFolder -ItemType Directory -Force -ErrorAction Stop | Out-Null
        }

        $clienteArquivo = $clienteRaw -replace '[\\/:*?"<>|]', '_'
        $dataArquivo = Get-Date -Format "dd-MM-yyyy"

        $reportFile = Join-Path $reportFolder "$clienteArquivo - $dataArquivo.html"

        # Se ja existe um relatorio do mesmo cliente no mesmo dia
        # (ex: segunda visita), evita sobrescrever adicionando (2), (3)...
        $contador = 2
        while (Test-Path -LiteralPath $reportFile) {
            $reportFile = Join-Path $reportFolder "$clienteArquivo - $dataArquivo ($contador).html"
            $contador++
        }

        $gpuHtml = ""
        foreach ($video in $gpu) {
            $gpuName = [System.Net.WebUtility]::HtmlEncode($video.Name)
            $gpuHtml += "<li>$gpuName</li>"
        }
        if (!$gpuHtml) { $gpuHtml = "<li>Informacao nao disponivel</li>" }

        $diskHealthHtml = ""
        foreach ($pd in $physicalDisks) {
            $modelo = [System.Net.WebUtility]::HtmlEncode([string]$pd.FriendlyName)
            $tipo = [System.Net.WebUtility]::HtmlEncode([string]$pd.MediaType)
            $capacidade = [math]::Round($pd.Size / 1GB, 1)
            $saude = [System.Net.WebUtility]::HtmlEncode([string]$pd.HealthStatus)
            $status = [System.Net.WebUtility]::HtmlEncode([string]$pd.OperationalStatus)

            $diskHealthHtml += "<tr><td>$modelo</td><td>$tipo</td><td>$capacidade GB</td><td>$saude</td><td>$status</td></tr>`n"
        }
        if (!$diskHealthHtml) {
            $diskHealthHtml = '<tr><td colspan="5">Informacoes de saude dos discos nao disponiveis.</td></tr>'
        }

        $computadorEnc = [System.Net.WebUtility]::HtmlEncode("$($computer.Manufacturer) $($computer.Model)")
        $osEnc = [System.Net.WebUtility]::HtmlEncode($os.Caption)
        $cpuEnc = [System.Net.WebUtility]::HtmlEncode($cpu.Name)

        $html = @"
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<title>Relatorio de Servico - TECH INFO BELEM</title>
<style>
body { font-family: Arial; background:#f3f4f6; padding:30px; color:#1f2937; }
.container { max-width:1000px; margin:auto; background:white; padding:35px; }
.header { border-bottom:3px solid #2563eb; padding-bottom:20px; }
.header h1 { color:#1d4ed8; }
h2 { background:#1f2937; color:white; padding:10px; }
.info { display:grid; grid-template-columns:1fr 1fr; gap:10px; }
.card { background:#f9fafb; border:1px solid #ddd; padding:15px; }
.label { font-weight:bold; }
.valor { font-size:24px; font-weight:bold; color:#166534; }
table { width:100%; border-collapse:collapse; }
th { background:#2563eb; color:white; padding:10px; }
td { border:1px solid #ddd; padding:10px; }
.servico { background:#f9fafb; border:1px solid #ddd; padding:20px; min-height:80px; }
.footer { margin-top:40px; border-top:1px solid #ddd; padding-top:15px; font-size:12px; color:#666; }
</style>
</head>
<body>
<div class="container">
<div class="header">
<h1>TECH INFO BELEM</h1>
<p>RELATORIO DE SERVICO TECNICO</p>
<p>Cleaner Pro v0.7</p>
</div>
<h2>ATENDIMENTO</h2>
<div class="info">
<div class="card"><span class="label">Cliente:</span><br>$cliente</div>
<div class="card"><span class="label">Telefone:</span><br>$telefone</div>
<div class="card"><span class="label">Data:</span><br>$data</div>
<div class="card"><span class="label">Computador:</span><br>$computadorEnc</div>
</div>
<h2>SERVICO REALIZADO</h2>
<div class="servico">$servico</div>
<h2>VALOR E PAGAMENTO</h2>
<div class="info">
<div class="card"><span class="label">Valor:</span><div class="valor">R$ $valor</div></div>
<div class="card"><span class="label">Pagamento:</span><br><br>$pagamento</div>
</div>
<h2>INFORMACOES DO COMPUTADOR</h2>
<div class="info">
<div class="card"><span class="label">Sistema:</span><br>$osEnc</div>
<div class="card"><span class="label">Processador:</span><br>$cpuEnc</div>
<div class="card"><span class="label">Memoria RAM:</span><br>$ramGB GB</div>
<div class="card"><span class="label">Armazenamento:</span><br>$freeGB GB livres de $totalGB GB</div>
</div>
<h2>PLACA DE VIDEO</h2>
<ul>$gpuHtml</ul>
<h2>SAUDE DOS DISCOS</h2>
<table>
<tr><th>Modelo</th><th>Tipo</th><th>Capacidade</th><th>Saude</th><th>Status</th></tr>
$diskHealthHtml
</table>
<h2>OBSERVACOES</h2>
<div class="servico">$observacoes</div>
<div class="footer">
TECH INFO BELEM - Assistencia Tecnica em Computadores, Notebooks e Celulares<br>
Relatorio gerado automaticamente pelo Cleaner Pro v0.7.
</div>
</div>
</body>
</html>
"@

        Set-Content -LiteralPath $reportFile -Value $html -Encoding UTF8 -Force -ErrorAction Stop

        if (!(Test-Path -LiteralPath $reportFile)) {
            throw "O arquivo nao foi criado."
        }

        $fileInfo = Get-Item -LiteralPath $reportFile -ErrorAction Stop

        if ($fileInfo.Length -lt 100) {
            throw "O arquivo foi criado, mas esta vazio."
        }

        $txtStatus.Text = "Relatorio criado com sucesso"

        $dataHoraIso = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $valorNumerico = ConvertTo-ValorNumerico -Texto $valorRaw

        $salvouBanco = Salvar-RelatorioNoBanco `
            -DataHoraIso $dataHoraIso `
            -DataFormatada $data `
            -Cliente $clienteRaw `
            -Telefone $telefoneRaw `
            -Servico $servicoRaw `
            -Valor $valorNumerico `
            -Pagamento $pagamentoRaw `
            -Observacoes $observacoesRaw `
            -Computador "$($computer.Manufacturer) $($computer.Model)" `
            -ArquivoHTML $reportFile

        Start-Process -FilePath $reportFile

        if ($salvouBanco) {

            [System.Windows.MessageBox]::Show(
                "Relatorio criado com sucesso!`n`nArquivo:`n$reportFile`n`nRegistrado no banco de dados (Historico / Faturamento).",
                "TECH INFO BELEM",
                "OK",
                "Information"
            )

        }
        else {

            [System.Windows.MessageBox]::Show(
                "Relatorio HTML criado com sucesso!`n`nArquivo:`n$reportFile`n`nATENCAO: nao foi possivel registrar no banco de dados (verifique sua conexao com a internet). O arquivo HTML foi salvo normalmente.",
                "TECH INFO BELEM",
                "OK",
                "Warning"
            )

        }

    }
    catch {

        $txtStatus.Text = "Erro ao gerar relatorio"

        [System.Windows.MessageBox]::Show(
            "ERRO AO GERAR RELATORIO:`n`n$($_.Exception.Message)",
            "TECH INFO BELEM - Erro",
            "OK",
            "Error"
        )

    }

}

# ============================================================
# EVENTO - INICIO
# ============================================================

$btnInicio.Add_Click({
    $txtTitulo.Text = "Painel de Controle"
    $txtSubtitulo.Text = "Ferramenta profissional de limpeza, diagnostico e manutencao"
    $txtStatus.Text = "Sistema pronto"
    Atualizar-Informacoes
})

# ============================================================
# EVENTO - ANALISAR
# ============================================================

$btnAnalisar.Add_Click({
    $txtTitulo.Text = "Analise do Sistema"
    $txtSubtitulo.Text = "Verificando arquivos temporarios, caches e lixeira"
    Analisar-Sistema
})

# ============================================================
# EVENTO - TEMPORARIOS
# ============================================================

$btnTemporarios.Add_Click({
    $confirmacao = [System.Windows.MessageBox]::Show(
        "Deseja limpar os arquivos temporarios do sistema?",
        "TECH INFO BELEM",
        "YesNo",
        "Question"
    )
    if ($confirmacao -eq "Yes") { Limpar-Temporarios }
})

# ============================================================
# EVENTO - NAVEGADORES
# ============================================================

$btnNavegadores.Add_Click({
    $confirmacao = [System.Windows.MessageBox]::Show(
        "Deseja limpar os caches dos navegadores instalados?`n`nCookies, senhas, favoritos e historico nao serao removidos.",
        "TECH INFO BELEM - Navegadores",
        "YesNo",
        "Question"
    )
    if ($confirmacao -eq "Yes") { Limpar-Navegadores }
})

# ============================================================
# EVENTO - LIXEIRA
# ============================================================

$btnLixeira.Add_Click({
    $confirmacao = [System.Windows.MessageBox]::Show(
        "Deseja esvaziar a Lixeira do Windows?",
        "TECH INFO BELEM - Lixeira",
        "YesNo",
        "Warning"
    )
    if ($confirmacao -eq "Yes") { Limpar-Lixeira }
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
    $txtTitulo.Text = "Diagnostico do Windows"
    $txtSubtitulo.Text = "Verificando integridade da imagem e arquivos do sistema"
    Diagnosticar-Windows
})

# ============================================================
# EVENTO - REPARAR WINDOWS
# ============================================================

$btnRepararWindows.Add_Click({
    $txtTitulo.Text = "Reparacao do Windows"
    $txtSubtitulo.Text = "DISM RestoreHealth seguido de SFC Scannow"
    Reparar-Windows
})

# ============================================================
# EVENTO - SAUDE SSD HD
# ============================================================

$btnDiscos.Add_Click({
    $txtTitulo.Text = "Saude do Armazenamento"
    $txtSubtitulo.Text = "Consultando status dos discos fisicos"
    Verificar-SaudeDiscos
})

# ============================================================
# EVENTO - MEMORIA RAM
# ============================================================

$btnMemoria.Add_Click({
    $txtTitulo.Text = "Diagnostico de Memoria RAM"
    $txtSubtitulo.Text = "Teste utilizando o Diagnostico de Memoria do Windows"
    Testar-Memoria
})

# ============================================================
# EVENTO - HARDWARE
# ============================================================

$btnHardware.Add_Click({
    $txtTitulo.Text = "Informacoes do Hardware"
    $txtSubtitulo.Text = "Informacoes basicas do hardware instalado"
    Mostrar-Hardware
})

# ============================================================
# EVENTO - RELATORIO
# ============================================================

$btnRelatorio.Add_Click({
    $txtTitulo.Text = "Relatorio de Servico"
    $txtSubtitulo.Text = "Preencha os dados do atendimento e gere o relatorio tecnico"
    Gerar-RelatorioServico
})

# ============================================================
# EVENTO - HISTORICO / FATURAMENTO
# ============================================================

$btnHistorico.Add_Click({
    $txtTitulo.Text = "Historico e Faturamento"
    $txtSubtitulo.Text = "Consulte os relatorios ja gerados e o total faturado por periodo"
    Abrir-HistoricoServicos
})

# ============================================================
# EVENTO - CHRIS TITUS
# ============================================================

$btnChrisTitus.Add_Click({
    Abrir-ChrisTitus
})

# ============================================================
# EVENTO - STATUS DA LICENCA
# ============================================================

$btnLicenca.Add_Click({
    $txtTitulo.Text = "Status da Licenca"
    $txtSubtitulo.Text = "Consulta o status de ativacao do Windows (somente leitura)"
    Verificar-StatusLicenca
})

# ============================================================
# EVENTO - SAIR
# ============================================================

$btnSair.Add_Click({
    $confirmacao = [System.Windows.MessageBox]::Show(
        "Deseja fechar o TECH INFO BELEM Cleaner Pro?",
        "TECH INFO BELEM",
        "YesNo",
        "Question"
    )
    if ($confirmacao -eq "Yes") { $Window.Close() }
})

# ============================================================
# INICIALIZAR
# ============================================================

Atualizar-Informacoes

$Window.ShowDialog() | Out-Null
