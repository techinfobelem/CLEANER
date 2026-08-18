Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

# Libera a execucao de scripts apenas para ESTE processo do PowerShell
# (nao altera nenhuma configuracao do sistema do cliente, nao precisa
# de confirmacao, e volta ao padrao assim que o PowerShell for fechado).
# Necessario porque, em muitos PCs, a politica de execucao padrao
# (Restricted) bloqueia o carregamento de modulos como o PSSQLite.
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force -ErrorAction SilentlyContinue

# ============================================================
# SKALON - CLEANER PRO
# VERSAO 1.0
# ============================================================
# NOTA: removemos o $ErrorActionPreference = "SilentlyContinue"
# global. Ele estava mascarando erros reais em todo o script,
# dificultando o diagnostico de problemas. Cada comando que
# realmente pode falhar de forma esperada (ex: pasta que nao
# existe) ja usa -ErrorAction SilentlyContinue individualmente.
# ============================================================

# ============================================================
# CONFIGURACAO CENTRAL
# ============================================================
# Toda configuracao editavel do programa fica concentrada aqui.
# Altere os caminhos, a planilha central e o log neste unico bloco.
# ============================================================

$Global:VersaoAplicativo = "1.0"
$Global:NomeAplicativo = "SKALON - Cleaner Pro v$Global:VersaoAplicativo"

$Global:CaminhoPastaRelatorios = "C:\Relatorio Skalon Informática"
$Global:CaminhoBancoDados = Join-Path $Global:CaminhoPastaRelatorios "relatorios.sqlite"
$Global:CaminhoLog = Join-Path $Global:CaminhoPastaRelatorios "cleaner_pro.log"

$Global:UrlPlanilhaRelatorios = "https://script.google.com/macros/s/AKfycbzWP44HXJm3DuBdK8x1mIY5FwfFGFakUUtMiAp8PpDlDXDIPZ5XA2ZZWilVgSR3sacr/exec"
$Global:ChavePlanilhaRelatorios = "techinfobelem"

$Global:UltimoErroPlanilha = ""
$Global:UltimoNumeroOS = $null

# ============================================================
# LOG DO PROGRAMA
# ============================================================
# Registra todas as acoes importantes (limpeza, diagnostico,
# relatorios) em um arquivo de texto dentro da pasta de
# relatorios. Facilita auditar o que foi feito em cada maquina.
# ============================================================

function Write-LogCleaner {

    param(
        [Parameter(Mandatory = $true)]
        [string]$Mensagem
    )

    try {

        if (-not (Test-Path -LiteralPath $Global:CaminhoPastaRelatorios)) {
            New-Item -Path $Global:CaminhoPastaRelatorios -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
        }

        $linha = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Mensagem"

        Add-Content -LiteralPath $Global:CaminhoLog -Value $linha -Encoding UTF8 -ErrorAction SilentlyContinue

    }
    catch {
    }

}

# ============================================================
# TAMANHO DE PASTA (versao rapida, sem Get-ChildItem -Recurse)
# ============================================================
# Usa System.IO.Directory (stack) em vez de recursao nativa do
# PowerShell. Muito mais rapido em pastas grandes e continua
# ignorando arquivos/pastas sem permissao.
# ============================================================

function Get-FolderSize {

    param(
        [string]$Path
    )

    $total = [long]0

    if (-not (Test-Path -LiteralPath $Path)) {
        return 0
    }

    try {

        $pilha = New-Object System.Collections.Generic.Stack[string]
        $pilha.Push($Path)

        while ($pilha.Count -gt 0) {

            $dir = $pilha.Pop()

            try {

                foreach ($arquivo in [System.IO.Directory]::EnumerateFiles($dir)) {
                    try {
                        $total += [System.IO.FileInfo]::new($arquivo).Length
                    }
                    catch {
                    }
                }

                foreach ($sub in [System.IO.Directory]::EnumerateDirectories($dir)) {
                    $pilha.Push($sub)
                }

            }
            catch {
            }

        }

    }
    catch {
    }

    return $total

}

# ============================================================
# NAVEGADORES EM EXECUCAO
# ============================================================
# Caches em uso por um navegador aberto nao podem ser apagados
# (ficam travados pelo processo). Antes de limpar, verificamos
# se algum navegador esta rodando e avisamos o usuario.

function Get-NavegadoresEmExecucao {

    $nomes = @("chrome", "msedge", "brave", "opera", "firefox", "vivaldi")

    $encontrados = @()

    foreach ($nome in $nomes) {

        if (Get-Process -Name $nome -ErrorAction SilentlyContinue) {
            $encontrados += $nome
        }

    }

    return $encontrados

}

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
        "O Cleaner Pro nao esta sendo executado como Administrador.`n`nAlgumas funcoes podem nao funcionar corretamente (ex: limpeza de caches do sistema e diagnostico do Windows).`n`nRecomendamos fechar e executar o PowerShell como Administrador.",
        $Global:NomeAplicativo,
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
    Title="SKALON - Cleaner Pro v$($Global:VersaoAplicativo)"
    Height="760"
    Width="1200"
    WindowStartupLocation="CenterScreen"
    Background="#111111">

    <Window.Resources>

        <!-- Acabamento fosco com detalhe metalico sutil (sem gradientes) -->
        <Style TargetType="Button">
            <Setter Property="BorderBrush" Value="#3A3A3A"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
        </Style>

        <Style TargetType="Border">
            <Setter Property="BorderBrush" Value="#2A2A2A"/>
            <Setter Property="BorderThickness" Value="1"/>
        </Style>

    </Window.Resources>

    <Grid>

        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="250"/>
            <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>

        <Border
            Grid.Column="0"
            Background="#0A0A0A">

            <ScrollViewer
                VerticalScrollBarVisibility="Auto">

                <StackPanel>

                    <TextBlock
                        Text="SKALON"
                        Foreground="#FF6A00"
                        FontSize="28"
                        FontWeight="Bold"
                        Margin="25,25,10,0"/>

                    <TextBlock
                        Text="CLEANER PRO"
                        Foreground="White"
                        FontSize="14"
                        Margin="25,2,10,10"/>

                    <TextBlock
                        Text="Performance para quem trabalha."
                        Foreground="#8A8A8A"
                        FontSize="10"
                        FontStyle="Italic"
                        TextWrapping="Wrap"
                        Margin="25,0,15,0"/>

                    <TextBlock
                        Text="Potência para quem joga."
                        Foreground="#8A8A8A"
                        FontSize="10"
                        FontStyle="Italic"
                        TextWrapping="Wrap"
                        Margin="25,0,15,25"/>

                    <TextBlock
                        Text="MANUTENCAO"
                        Foreground="#8A8A8A"
                        FontSize="11"
                        FontWeight="Bold"
                        Margin="20,5,10,5"/>

                    <Button
                        Name="btnInicio"
                        Content="INICIO"
                        Height="40"
                        Margin="15,3"
                        Background="#FF6A00"
                        Foreground="White"/>

                    <Button
                        Name="btnAnalisar"
                        Content="ANALISAR SISTEMA"
                        Height="40"
                        Margin="15,3"
                        Background="#1A1A1A"
                        Foreground="White"/>

                    <Button
                        Name="btnTemporarios"
                        Content="LIMPAR TEMPORARIOS"
                        Height="40"
                        Margin="15,3"
                        Background="#1A1A1A"
                        Foreground="White"/>

                    <Button
                        Name="btnNavegadores"
                        Content="LIMPAR NAVEGADORES"
                        Height="40"
                        Margin="15,3"
                        Background="#1A1A1A"
                        Foreground="White"/>

                    <Button
                        Name="btnLixeira"
                        Content="ESVAZIAR LIXEIRA"
                        Height="40"
                        Margin="15,3"
                        Background="#1A1A1A"
                        Foreground="White"/>

                    <Button
                        Name="btnCompleta"
                        Content="LIMPEZA COMPLETA"
                        Height="40"
                        Margin="15,3"
                        Background="#FF6A00"
                        Foreground="White"/>

                    <TextBlock
                        Text="REPARACAO DO WINDOWS"
                        Foreground="#8A8A8A"
                        FontSize="11"
                        FontWeight="Bold"
                        Margin="20,20,10,5"/>

                    <Button
                        Name="btnDiagnosticoWindows"
                        Content="DIAGNOSTICAR WINDOWS"
                        Height="40"
                        Margin="15,3"
                        Background="#1A1A1A"
                        Foreground="White"/>

                    <Button
                        Name="btnRepararWindows"
                        Content="REPARAR WINDOWS"
                        Height="40"
                        Margin="15,3"
                        Background="#FF6A00"
                        Foreground="White"/>

                    <TextBlock
                        Text="DIAGNOSTICO DE HARDWARE"
                        Foreground="#8A8A8A"
                        FontSize="11"
                        FontWeight="Bold"
                        Margin="20,20,10,5"/>

                    <Button
                        Name="btnDiscos"
                        Content="SAUDE SSD / HD"
                        Height="40"
                        Margin="15,3"
                        Background="#1A1A1A"
                        Foreground="White"/>

                    <Button
                        Name="btnMemoria"
                        Content="TESTE DE MEMORIA RAM"
                        Height="40"
                        Margin="15,3"
                        Background="#1A1A1A"
                        Foreground="White"/>

                    <Button
                        Name="btnHardware"
                        Content="INFORMACOES DO HARDWARE"
                        Height="40"
                        Margin="15,3"
                        Background="#1A1A1A"
                        Foreground="White"/>

                    <TextBlock
                        Text="ATENDIMENTO"
                        Foreground="#8A8A8A"
                        FontSize="11"
                        FontWeight="Bold"
                        Margin="20,20,10,5"/>

                    <Button
                        Name="btnRelatorio"
                        Content="RELATORIO DE SERVICO"
                        Height="40"
                        Margin="15,3"
                        Background="#FF6A00"
                        Foreground="White"/>

                    <Button
                        Name="btnHistorico"
                        Content="HISTORICO / FATURAMENTO"
                        Height="40"
                        Margin="15,3"
                        Background="#1A1A1A"
                        Foreground="White"/>

                    <TextBlock
                        Text="FERRAMENTAS"
                        Foreground="#8A8A8A"
                        FontSize="11"
                        FontWeight="Bold"
                        Margin="20,20,10,5"/>

                    <Button
                        Name="btnChrisTitus"
                        Content="WINUTIL - CHRIS TITUS"
                        Height="40"
                        Margin="15,3"
                        Background="#1A1A1A"
                        Foreground="White"/>

                    <Button
                        Name="btnLicenca"
                        Content="STATUS DA LICENCA"
                        Height="40"
                        Margin="15,3"
                        Background="#1A1A1A"
                        Foreground="White"/>

                    <Button
                        Name="btnSair"
                        Content="SAIR"
                        Height="40"
                        Margin="15,25,15,20"
                        Background="#2A2A2A"
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
                Foreground="#8A8A8A"
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
                            Background="#1A1A1A"
                            CornerRadius="10"
                            Padding="20"
                            Margin="0,0,0,12">

                            <StackPanel>

                                <TextBlock
                                    Text="COMPUTADOR"
                                    Foreground="#FF6A00"
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
                            Background="#1A1A1A"
                            CornerRadius="10"
                            Padding="20"
                            Margin="0,0,0,12">

                            <StackPanel>

                                <TextBlock
                                    Text="SISTEMA OPERACIONAL"
                                    Foreground="#FF6A00"
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
                            Background="#1A1A1A"
                            CornerRadius="10"
                            Padding="20"
                            Margin="0,0,0,12">

                            <StackPanel>

                                <TextBlock
                                    Text="PROCESSADOR"
                                    Foreground="#FF6A00"
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
                            Background="#1A1A1A"
                            CornerRadius="10"
                            Padding="20"
                            Margin="0,0,0,12">

                            <StackPanel>

                                <TextBlock
                                    Text="MEMORIA RAM"
                                    Foreground="#FF6A00"
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
                            Background="#1A1A1A"
                            CornerRadius="10"
                            Padding="20">

                            <StackPanel>

                                <TextBlock
                                    Text="STATUS DA MEMORIA"
                                    Foreground="#FF6A00"
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
                            Background="#1A1A1A"
                            CornerRadius="10"
                            Padding="20"
                            Margin="0,0,0,12">

                            <StackPanel>

                                <TextBlock
                                    Text="DISCO PRINCIPAL"
                                    Foreground="#FF6A00"
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
                            Background="#1A1A1A"
                            CornerRadius="10"
                            Padding="20"
                            Margin="0,0,0,12">

                            <StackPanel>

                                <TextBlock
                                    Text="ESPACO DISPONIVEL"
                                    Foreground="#FF6A00"
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
                            Background="#1A1A1A"
                            CornerRadius="10"
                            Padding="20"
                            Margin="0,0,0,12">

                            <StackPanel>

                                <TextBlock
                                    Text="SAUDE DO ARMAZENAMENTO"
                                    Foreground="#FF6A00"
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
                            Background="#1A1A1A"
                            CornerRadius="10"
                            Padding="20"
                            Margin="0,0,0,12">

                            <StackPanel>

                                <TextBlock
                                    Text="ANALISE DE LIMPEZA"
                                    Foreground="#FF6A00"
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
                            Background="#1A1A1A"
                            CornerRadius="10"
                            Padding="20">

                            <StackPanel>

                                <TextBlock
                                    Text="STATUS"
                                    Foreground="#FF6A00"
                                    FontSize="13"/>

                                <TextBlock
                                    Name="txtStatus"
                                    Text="Sistema pronto"
                                    Foreground="#FF6A00"
                                    FontSize="18"
                                    FontWeight="Bold"
                                    Margin="0,7,0,0"
                                    TextWrapping="Wrap"/>

                                <ProgressBar
                                    Name="prgProgresso"
                                    IsIndeterminate="True"
                                    Height="6"
                                    Margin="0,10,0,0"
                                    Background="#111111"
                                    BorderThickness="0"
                                    Foreground="#FF6A00"
                                    Visibility="Collapsed"/>

                            </StackPanel>

                        </Border>

                    </StackPanel>

                </Grid>

            </ScrollViewer>

            <TextBlock
                Name="txtRodape"
                Grid.Row="3"
                Text="SKALON - Cleaner Pro v$($Global:VersaoAplicativo)"
                Foreground="#8A8A8A"
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
            "SKALON",
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
                        "SKALON - Erro",
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
# ANALISAR SISTEMA (ASSINCRONO)
# ============================================================

function Analisar-Sistema {

    $work = {

        function Get-FolderSizeJob {
            param([string]$Path)
            $total = [long]0
            if (-not (Test-Path -LiteralPath $Path)) { return 0 }
            try {
                $pilha = New-Object System.Collections.Generic.Stack[string]
                $pilha.Push($Path)
                while ($pilha.Count -gt 0) {
                    $dir = $pilha.Pop()
                    try {
                        foreach ($arquivo in [System.IO.Directory]::EnumerateFiles($dir)) {
                            try { $total += [System.IO.FileInfo]::new($arquivo).Length } catch { }
                        }
                        foreach ($sub in [System.IO.Directory]::EnumerateDirectories($dir)) {
                            $pilha.Push($sub)
                        }
                    }
                    catch { }
                }
            }
            catch { }
            return $total
        }

        function Get-CacheJob {
            param([string]$BasePath)
            $total = [long]0
            if (-not (Test-Path -LiteralPath $BasePath)) { return 0 }
            $perfis = Get-ChildItem -LiteralPath $BasePath -Directory -Force -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -eq "Default" -or $_.Name -like "Profile*" }
            foreach ($perfil in $perfis) {
                foreach ($sub in @("Cache", "Code Cache", "GPUCache")) {
                    $cache = Join-Path $perfil.FullName $sub
                    if (Test-Path -LiteralPath $cache) {
                        $total += Get-FolderSizeJob $cache
                    }
                }
            }
            return $total
        }

        # Temporarios (inclui caches de sistema novos: WinUpdate, etc.)
        $tempSize = 0
        $alvosTemp = @(
            $env:TEMP,
            "$env:SystemRoot\Temp",
            "$env:LOCALAPPDATA\Microsoft\Windows\INetCache",
            "$env:SystemRoot\SoftwareDistribution\Download",
            "$env:SystemRoot\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache",
            "$env:LOCALAPPDATA\Microsoft\Windows\Explorer",
            "$env:LOCALAPPDATA\D3DSCache",
            "$env:LOCALAPPDATA\Microsoft\Windows\WER",
            "$env:LOCALAPPDATA\CrashDumps"
        )
        foreach ($alvo in $alvosTemp) {
            $tempSize += Get-FolderSizeJob $alvo
        }

        # Navegadores (cobre Default + Profile 1, 2, ...)
        $browserSize = 0

        $candidatos = @(
            "$env:LOCALAPPDATA\Google\Chrome\User Data",
            "$env:LOCALAPPDATA\Microsoft\Edge\User Data",
            "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data",
            "$env:LOCALAPPDATA\Vivaldi\User Data",
            "$env:APPDATA\Opera Software\Opera Stable",
            "$env:APPDATA\Opera Software\Opera GX Stable"
        )

        foreach ($base in $candidatos) {
            $browserSize += Get-CacheJob $base
        }

        # Firefox (cache2 de todos os perfis)
        $firefoxProfiles = "$env:APPDATA\Mozilla\Firefox\Profiles"
        if (Test-Path -LiteralPath $firefoxProfiles) {
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

        Write-LogCleaner -Mensagem "Analise concluida: Temp=$([math]::Round($resultado.TempSize/1MB,2)) MB | Navegadores=$([math]::Round($resultado.BrowserSize/1MB,2)) MB | Lixeira=$([math]::Round($resultado.RecycleSize/1MB,2)) MB"

        [System.Windows.MessageBox]::Show(

            "ANALISE CONCLUIDA`n`n" +
            "Arquivos temporarios e caches de sistema: $([math]::Round($resultado.TempSize / 1MB, 2)) MB`n`n" +
            "Cache dos navegadores: $([math]::Round($resultado.BrowserSize / 1MB, 2)) MB`n`n" +
            "Lixeira: $([math]::Round($resultado.RecycleSize / 1MB, 2)) MB`n`n" +
            "Total potencialmente recuperavel: $totalGB GB",

            "SKALON - Analise",
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

        $alvos = @(
            $env:TEMP,
            "$env:SystemRoot\Temp",
            "$env:LOCALAPPDATA\Microsoft\Windows\INetCache",
            "$env:SystemRoot\SoftwareDistribution\Download",
            "$env:SystemRoot\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache",
            "$env:LOCALAPPDATA\Microsoft\Windows\Explorer",
            "$env:LOCALAPPDATA\D3DSCache",
            "$env:LOCALAPPDATA\Microsoft\Windows\WER",
            "$env:LOCALAPPDATA\CrashDumps"
        )

        foreach ($alvo in $alvos) {

            if (Test-Path -LiteralPath $alvo) {

                Get-ChildItem -LiteralPath $alvo -Force -ErrorAction SilentlyContinue |
                    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

            }

        }

        return $true

    }

    $onComplete = {

        param($sucesso)

        if ($sucesso) {
            $txtStatus.Text = "Temporarios limpos"
            Write-LogCleaner -Mensagem "Limpeza de temporarios concluida (Temp, INetCache, WinUpdate, DeliveryOpt, thumbnails, shaders, WER, dumps)."
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

    $navegadoresRodando = Get-NavegadoresEmExecucao

    if ($navegadoresRodando.Count -gt 0) {

        $lista = ($navegadoresRodando -join ", ")

        $confirmacao = [System.Windows.MessageBox]::Show(
            "Os seguintes navegadores estao em execucao:`n`n$lista`n`n" +
            "Os caches em uso por eles NAO poderao ser apagados enquanto estiverem abertos.`n`n" +
            "Deseja continuar mesmo assim? (Recomendado fechar e tentar de novo)",
            "SKALON - Navegadores",
            "YesNo",
            "Warning"
        )

        if ($confirmacao -ne "Yes") { return }

    }

    $work = {

        function Get-CachesJob {
            param([string]$BasePath)
            if (-not (Test-Path -LiteralPath $BasePath)) { return }
            $perfis = Get-ChildItem -LiteralPath $BasePath -Directory -Force -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -eq "Default" -or $_.Name -like "Profile*" }
            foreach ($perfil in $perfis) {
                foreach ($sub in @("Cache", "Code Cache", "GPUCache")) {
                    $cache = Join-Path $perfil.FullName $sub
                    if (Test-Path -LiteralPath $cache) {
                        Get-ChildItem $cache -Force -ErrorAction SilentlyContinue |
                            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
                    }
                }
            }
        }

        $candidatos = @(
            "$env:LOCALAPPDATA\Google\Chrome\User Data",
            "$env:LOCALAPPDATA\Microsoft\Edge\User Data",
            "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data",
            "$env:LOCALAPPDATA\Vivaldi\User Data",
            "$env:APPDATA\Opera Software\Opera Stable",
            "$env:APPDATA\Opera Software\Opera GX Stable"
        )

        foreach ($base in $candidatos) {
            Get-CachesJob $base
        }

        # Firefox (cache2 de todos os perfis)
        $firefoxProfiles = "$env:APPDATA\Mozilla\Firefox\Profiles"
        if (Test-Path -LiteralPath $firefoxProfiles) {
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
        Write-LogCleaner -Mensagem "Caches dos navegadores limpos (Chrome/Edge/Brave/Vivaldi/Opera/Firefox, todos os perfis)."

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
            "- Caches de sistema (Windows Update, Delivery Optimization)`n" +
            "- Thumbnails e caches de shaders`n" +
            "- Cache seguro dos navegadores`n" +
            "- Lixeira`n`n" +
            "Cookies, senhas, favoritos e historico nao serao removidos." +
            "`n`nATENCAO: feche os navegadores antes de continuar, caso contrario" +
            " parte do cache deles ficara travada.",

            "SKALON - Limpeza Completa",
            "YesNo",
            "Question"
        )

    if ($confirmacao -ne "Yes") { return }

    $diskBefore = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $Global:FreeBeforeLimpeza = $diskBefore.FreeSpace

    $work = {

        # Temporarios e caches de sistema
        $alvos = @(
            $env:TEMP,
            "$env:SystemRoot\Temp",
            "$env:LOCALAPPDATA\Microsoft\Windows\INetCache",
            "$env:SystemRoot\SoftwareDistribution\Download",
            "$env:SystemRoot\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache",
            "$env:LOCALAPPDATA\Microsoft\Windows\Explorer",
            "$env:LOCALAPPDATA\D3DSCache",
            "$env:LOCALAPPDATA\Microsoft\Windows\WER",
            "$env:LOCALAPPDATA\CrashDumps"
        )

        foreach ($alvo in $alvos) {

            if (Test-Path -LiteralPath $alvo) {

                Get-ChildItem -LiteralPath $alvo -Force -ErrorAction SilentlyContinue |
                    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

            }

        }

        # Navegadores (todos os perfis)
        $candidatos = @(
            "$env:LOCALAPPDATA\Google\Chrome\User Data",
            "$env:LOCALAPPDATA\Microsoft\Edge\User Data",
            "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data",
            "$env:LOCALAPPDATA\Vivaldi\User Data",
            "$env:APPDATA\Opera Software\Opera Stable",
            "$env:APPDATA\Opera Software\Opera GX Stable"
        )

        foreach ($base in $candidatos) {

            if (Test-Path -LiteralPath $base) {

                $perfis = Get-ChildItem -LiteralPath $base -Directory -Force -ErrorAction SilentlyContinue |
                    Where-Object { $_.Name -eq "Default" -or $_.Name -like "Profile*" }

                foreach ($perfil in $perfis) {
                    foreach ($sub in @("Cache", "Code Cache", "GPUCache")) {
                        $cache = Join-Path $perfil.FullName $sub
                        if (Test-Path -LiteralPath $cache) {
                            Get-ChildItem $cache -Force -ErrorAction SilentlyContinue |
                                Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
                        }
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

        Write-LogCleaner -Mensagem "Limpeza completa concluida: $freedMB MB liberados."

        [System.Windows.MessageBox]::Show(

            "LIMPEZA COMPLETA FINALIZADA`n`n" +
            "Espaco liberado: $freedMB MB`n`n" +
            "O Cleaner Pro concluiu a manutencao.",

            $Global:NomeAplicativo,
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

            "SKALON - Diagnostico Windows",
            "OK",
            "Information"
        )

        Write-LogCleaner -Mensagem "Diagnostico Windows concluido: DISM=$($resultado.DismExitCode) | SFC=$($resultado.SfcExitCode)."

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

            "SKALON - Reparar Windows",
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

            "SKALON - Reparar Windows",
            "OK",
            "Information"
        )

        Write-LogCleaner -Mensagem "Reparo Windows concluido: DISM=$($resultado.DismExitCode) | SFC=$($resultado.SfcExitCode)."

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
                "SKALON - Diagnostico",
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

        Write-LogCleaner -Mensagem "Diagnostico de armazenamento concluido ($($resultado.Discos.Count) disco(s) identificados)."

        [System.Windows.MessageBox]::Show(
            $resultadoTexto,
            "SKALON - Saude SSD / HD",
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

            "SKALON - Teste de RAM",
            "YesNo",
            "Warning"
        )

    if ($confirmacao -ne "Yes") { return }

    $txtStatusMemoria.Text = "Diagnostico agendado"
    $txtStatus.Text = "Abrindo Diagnostico de Memoria..."

    Start-Process "mdsched.exe"

    $txtStatusMemoria.Text = "Aguardando teste do Windows"
    $txtStatus.Text = "Diagnostico de memoria aberto"

    Write-LogCleaner -Mensagem "Teste de memoria (mdsched.exe) agendado."

    [System.Windows.MessageBox]::Show(
        "O Diagnostico de Memoria do Windows foi aberto.`n`nEscolha uma das opcoes disponiveis para iniciar o teste.`n`nO resultado sera apresentado pelo Windows apos a verificacao.",
        "SKALON - Teste de RAM",
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

        Write-LogCleaner -Mensagem "Informacoes de hardware coletadas."

        [System.Windows.MessageBox]::Show(
            $resultado,
            "SKALON - Hardware",
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

            "SKALON - WinUtil",
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
                "SKALON - Erro",
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

        Write-LogCleaner -Mensagem "Status da licenca verificado via slmgr /xpr."

        [System.Windows.MessageBox]::Show(
            $resultado.Trim(),
            "SKALON - Status da Licenca",
            "OK",
            "Information"
        )

    }
    catch {

        $txtStatus.Text = "Erro ao verificar status da licenca"

        [System.Windows.MessageBox]::Show(
            "Nao foi possivel verificar o status da licenca.`n`nErro:`n$($_.Exception.Message)",
            "SKALON - Erro",
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
# Os caminhos (pasta, banco, log) sao definidos no bloco de
# CONFIGURACAO CENTRAL no inicio do script.
# ============================================================

# ============================================================
# PLANILHA CENTRAL (Google Sheets) - historico consolidado
# ============================================================
# Cada relatorio gerado, em qualquer PC, e enviado tambem para
# esta planilha central. O botao HISTORICO / FATURAMENTO consulta
# ela (em vez do banco SQLite local), para que o tecnico veja
# todos os atendimentos de todas as maquinas, de qualquer lugar.
# O SQLite local continua existindo como copia de seguranca.
# A URL e a chave sao definidas no bloco CONFIGURACAO CENTRAL.
# ============================================================

function Get-MensagemErroHttp {

    param(
        $ErroCapturado
    )

    if ($ErroCapturado.ErrorDetails -and $ErroCapturado.ErrorDetails.Message) {
        return $ErroCapturado.ErrorDetails.Message
    }

    if ($ErroCapturado.Exception.Response) {

        try {
            $stream = $ErroCapturado.Exception.Response.GetResponseStream()
            $leitor = New-Object IO.StreamReader($stream)
            $corpo = $leitor.ReadToEnd()
            if (-not [string]::IsNullOrWhiteSpace($corpo)) {
                return $corpo
            }
        }
        catch {
        }

    }

    return $ErroCapturado.Exception.Message

}

function Enviar-RelatorioParaPlanilha {

    param(
        [string]$DataHoraIso,
        [string]$DataFormatada,
        [string]$Cliente,
        [string]$Telefone,
        [string]$Servico,
        [double]$Valor,
        [double]$Custo = 0,
        [double]$ValorPecas = 0,
        [double]$ValorServico = 0,
        [double]$Desconto = 0,
        [string]$Pagamento,
        [string]$Observacoes,
        [string]$Computador,
        [string]$ArquivoHTML
    )

    try {

        [Net.ServicePointManager]::SecurityProtocol =
            [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

        $parametros = [ordered]@{
            chave         = $Global:ChavePlanilhaRelatorios
            acao          = "gravar"
            dataHoraIso   = $DataHoraIso
            dataFormatada = $DataFormatada
            cliente       = $Cliente
            telefone      = $Telefone
            servico       = $Servico
            valor         = $Valor.ToString([Globalization.CultureInfo]::InvariantCulture)
            custo         = $Custo.ToString([Globalization.CultureInfo]::InvariantCulture)
            valorPecas    = $ValorPecas.ToString([Globalization.CultureInfo]::InvariantCulture)
            valorServico  = $ValorServico.ToString([Globalization.CultureInfo]::InvariantCulture)
            desconto      = $Desconto.ToString([Globalization.CultureInfo]::InvariantCulture)
            pagamento     = $Pagamento
            observacoes   = $Observacoes
            computador    = $Computador
            arquivoHtml   = $ArquivoHTML
        }

        $queryString = (
            $parametros.GetEnumerator() | ForEach-Object {
                "$($_.Key)=$([Uri]::EscapeDataString([string]$_.Value))"
            }
        ) -join "&"

        $url = "$($Global:UrlPlanilhaRelatorios)?$queryString"

        $resposta = Invoke-RestMethod -Uri $url -Method Get -TimeoutSec 20

        if ($resposta.sucesso) {
            $Global:UltimoErroPlanilha = ""
            $Global:UltimoNumeroOS = $resposta.numero
            return $true
        }

        $Global:UltimoErroPlanilha = "A planilha respondeu com erro: $($resposta.erro)"
        $Global:UltimoNumeroOS = $null
        return $false

    }
    catch {

        $Global:UltimoErroPlanilha = Get-MensagemErroHttp -ErroCapturado $_
        $Global:UltimoNumeroOS = $null

        return $false

    }

}

function Buscar-RelatoriosDaPlanilha {

    try {

        [Net.ServicePointManager]::SecurityProtocol =
            [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

        $url = "$($Global:UrlPlanilhaRelatorios)?chave=$([Uri]::EscapeDataString($Global:ChavePlanilhaRelatorios))"

        $resposta = Invoke-RestMethod -Uri $url -Method Get -TimeoutSec 30

        if ($resposta.sucesso) {
            $Global:UltimoErroPlanilha = ""
            return $resposta.dados
        }

        $Global:UltimoErroPlanilha = "A planilha respondeu com erro: $($resposta.erro)"
        return $null

    }
    catch {

        $Global:UltimoErroPlanilha = Get-MensagemErroHttp -ErroCapturado $_

        return $null

    }

}

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

    try {
        $valor = [double]::Parse($limpo, [Globalization.NumberStyles]::Any, [Globalization.CultureInfo]::InvariantCulture)
    }
    catch {
        $valor = 0.0
    }

    return $valor

}

function Ensure-SQLiteModule {

    param(
        [int]$TimeoutSegundos = 180
    )

    # Ja importado nesta sessao - caminho mais rapido possivel
    if (Get-Module -Name PSSQLite) {
        return $true
    }

    # Ja esta instalado no PC (de uma execucao anterior) - so importar, e rapido
    if (Get-Module -ListAvailable -Name PSSQLite) {

        try {
            Import-Module PSSQLite -ErrorAction Stop
            return $true
        }
        catch {
            $Global:UltimoErroSQLite = $_.Exception.Message
            return $false
        }

    }

    # Ainda nao esta instalado. Um job de instalacao em segundo plano
    # ja foi disparado quando o programa abriu ($Global:JobInstalacaoSQLite).
    # Em vez de instalar aqui (o que travaria a interface, como o DISM
    # travava antes), esperamos esse job terminar processando os eventos
    # da interface (DoEvents) para a janela continuar respondendo durante
    # a espera - sem congelar, mesmo que demore.

    if ($Global:JobInstalacaoSQLite) {

        $txtStatus.Text = "Preparando banco de dados (primeira vez pode demorar um pouco)..."
        $Window.Cursor = [System.Windows.Input.Cursors]::Wait
        $prgProgresso.Visibility = [System.Windows.Visibility]::Visible

        $tempoLimite = (Get-Date).AddSeconds($TimeoutSegundos)

        while (
            $Global:JobInstalacaoSQLite.State -eq 'Running' -and
            (Get-Date) -lt $tempoLimite
        ) {

            [System.Windows.Forms.Application]::DoEvents()

            Start-Sleep -Milliseconds 150

        }

        $Window.Cursor = [System.Windows.Input.Cursors]::Arrow
        $prgProgresso.Visibility = [System.Windows.Visibility]::Collapsed

        if ($Global:JobInstalacaoSQLite.State -eq 'Running') {

            # passou do tempo limite - desiste deste job especifico, mas
            # deixa ele rodando em segundo plano caso termine sozinho depois.
            $Global:UltimoErroSQLite = "A instalacao passou de 3 minutos e ainda nao terminou (provavel problema de rede/proxy)."
            $txtStatus.Text = "Banco de dados esta demorando para instalar"
            return $false

        }

        $resultadoJob = Receive-Job -Job $Global:JobInstalacaoSQLite -ErrorAction SilentlyContinue

        Remove-Job -Job $Global:JobInstalacaoSQLite -Force -ErrorAction SilentlyContinue

        $Global:JobInstalacaoSQLite = $null

        $sucessoJob = $false

        if ($resultadoJob -is [System.Management.Automation.PSCustomObject] -and $resultadoJob.PSObject.Properties.Name -contains 'Sucesso') {
            $sucessoJob = $resultadoJob.Sucesso
            if (-not $sucessoJob) {
                $Global:UltimoErroSQLite = $resultadoJob.Erro
            }
        }
        else {
            $sucessoJob = ($resultadoJob -eq $true)
        }

        if ($sucessoJob -or (Get-Module -ListAvailable -Name PSSQLite)) {

            try {
                Import-Module PSSQLite -ErrorAction Stop
                return $true
            }
            catch {
                $Global:UltimoErroSQLite = $_.Exception.Message
                return $false
            }

        }

        return $false

    }

    # Fallback: por algum motivo o job de fundo nao foi iniciado.
    # Tenta instalar agora mesmo (unica situacao em que ainda pode
    # haver uma pequena espera perceptivel).

    try {

        $ConfirmPreference = 'None'

        [Net.ServicePointManager]::SecurityProtocol =
            [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

        $repositorio = Get-PSRepository -Name PSGallery -ErrorAction SilentlyContinue

        if ($repositorio -and $repositorio.InstallationPolicy -ne 'Trusted') {
            Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -ErrorAction SilentlyContinue
        }

        # Se estiver como Administrador, instala para todos os usuarios
        # (C:\Program Files\WindowsPowerShell\Modules) - evita depender
        # da pasta Documentos do usuario, que em alguns PCs (ex: com
        # OneDrive redirecionando "Documentos") nao tem a subpasta
        # WindowsPowerShell\Modules criada, causando erro de caminho.
        $escopoInstalacao = "CurrentUser"

        if (Test-Administrator) {
            $escopoInstalacao = "AllUsers"
        }
        else {
            $pastaModulosUsuario = Join-Path ([Environment]::GetFolderPath('MyDocuments')) "WindowsPowerShell\Modules"
            if (-not (Test-Path $pastaModulosUsuario)) {
                New-Item -Path $pastaModulosUsuario -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
            }
        }

        if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
            Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ForceBootstrap -Confirm:$false -Scope $escopoInstalacao -ErrorAction Stop | Out-Null
        }

        Install-Module -Name PSSQLite -Scope $escopoInstalacao -Force -AllowClobber -Confirm:$false -ErrorAction Stop

        Import-Module PSSQLite -ErrorAction Stop

        return $true

    }
    catch {

        $Global:UltimoErroSQLite = $_.Exception.Message

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

    # Timeout curto (5s): esta funcao roda toda vez que um relatorio e
    # gerado, inclusive na casa do cliente. Nao faz sentido o tecnico
    # ficar esperando minutos pela instalacao do banco no meio de um
    # atendimento - se nao estiver pronto rapido, segue sem banco e
    # o relatorio HTML e salvo normalmente do mesmo jeito.
    if (-not (Ensure-SQLiteModule -TimeoutSegundos 5)) {
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

    # ------------------------------------------------------------
    # JANELA
    # ------------------------------------------------------------

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "SKALON - Historico e Faturamento"
    $form.Size = New-Object System.Drawing.Size(950,650)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = [System.Drawing.Color]::FromArgb(17,17,17)
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
    $btnBuscar.BackColor = [System.Drawing.Color]::FromArgb(255,106,0)
    $btnBuscar.ForeColor = [System.Drawing.Color]::White
    $form.Controls.Add($btnBuscar)

    $btnExportarCsv = New-Object System.Windows.Forms.Button
    $btnExportarCsv.Text = "EXPORTAR CSV"
    $btnExportarCsv.Location = New-Object System.Drawing.Point(700,44)
    $btnExportarCsv.Size = New-Object System.Drawing.Size(130,32)
    $btnExportarCsv.BackColor = [System.Drawing.Color]::FromArgb(42,42,42)
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
    $dgvResultados.BackgroundColor = [System.Drawing.Color]::FromArgb(26,26,26)
    $dgvResultados.GridColor = [System.Drawing.Color]::FromArgb(55,65,81)
    $dgvResultados.BorderStyle = "None"
    $dgvResultados.EnableHeadersVisualStyles = $false

    $dgvResultados.DefaultCellStyle.BackColor = [System.Drawing.Color]::FromArgb(31,41,55)
    $dgvResultados.DefaultCellStyle.ForeColor = [System.Drawing.Color]::White
    $dgvResultados.DefaultCellStyle.SelectionBackColor = [System.Drawing.Color]::FromArgb(21,94,117)
    $dgvResultados.DefaultCellStyle.SelectionForeColor = [System.Drawing.Color]::White

    $dgvResultados.ColumnHeadersDefaultCellStyle.BackColor = [System.Drawing.Color]::FromArgb(17,24,39)
    $dgvResultados.ColumnHeadersDefaultCellStyle.ForeColor = [System.Drawing.Color]::FromArgb(96,165,250)
    $dgvResultados.ColumnHeadersDefaultCellStyle.Font = New-Object System.Drawing.Font("Arial",9,[System.Drawing.FontStyle]::Bold)

    $dgvResultados.RowsDefaultCellStyle.BackColor = [System.Drawing.Color]::FromArgb(31,41,55)
    $dgvResultados.AlternatingRowsDefaultCellStyle.BackColor = [System.Drawing.Color]::FromArgb(38,50,68)
    $dgvResultados.AlternatingRowsDefaultCellStyle.ForeColor = [System.Drawing.Color]::White

    $form.Controls.Add($dgvResultados)

    $lblTotal = New-Object System.Windows.Forms.Label
    $lblTotal.Text = "Atendimentos: 0   |   Faturado: R$ 0,00   |   Custo pecas: R$ 0,00   |   Lucro: R$ 0,00"
    $lblTotal.Location = New-Object System.Drawing.Point(20,540)
    $lblTotal.Size = New-Object System.Drawing.Size(890,30)
    $lblTotal.Anchor = "Bottom,Left,Right"
    $lblTotal.Font = New-Object System.Drawing.Font("Arial",11,[System.Drawing.FontStyle]::Bold)
    $lblTotal.ForeColor = [System.Drawing.Color]::FromArgb(255,106,0)
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

            $txtStatus.Text = "Consultando a planilha central..."
            $Window.Cursor = [System.Windows.Input.Cursors]::Wait

            $dadosPlanilha = Buscar-RelatoriosDaPlanilha

            $Window.Cursor = [System.Windows.Input.Cursors]::Arrow

            if ($null -eq $dadosPlanilha) {

                [System.Windows.Forms.MessageBox]::Show(
                    "Nao foi possivel consultar a planilha central.`n`nMotivo: $Global:UltimoErroPlanilha",
                    "SKALON - Historico",
                    "OK",
                    "Warning"
                )

                $txtStatus.Text = "Falha ao consultar a planilha central"

                return

            }

            $tabela = New-Object System.Data.DataTable
            [void]$tabela.Columns.Add("Data", [string])
            [void]$tabela.Columns.Add("Cliente", [string])
            [void]$tabela.Columns.Add("Servico", [string])
            [void]$tabela.Columns.Add("Valor", [double])
            [void]$tabela.Columns.Add("Custo", [double])
            [void]$tabela.Columns.Add("Lucro", [double])
            [void]$tabela.Columns.Add("Pagamento", [string])
            [void]$tabela.Columns.Add("ArquivoHTML", [string])

            foreach ($item in $dadosPlanilha) {

                try {
                    $dataHora = [DateTime]::Parse(
                        [string]$item.dataHoraIso,
                        [Globalization.CultureInfo]::InvariantCulture,
                        [Globalization.DateTimeStyles]::None
                    )
                }
                catch {
                    continue
                }

                if ($dataHora -lt $inicio -or $dataHora -ge $fim) {
                    continue
                }

                $valorItem = [double]$item.valor
                $custoItem = if ($item.custo) { [double]$item.custo } else { 0.0 }

                $linha = $tabela.NewRow()
                $linha["Data"] = [string]$item.dataFormatada
                $linha["Cliente"] = [string]$item.cliente
                $linha["Servico"] = [string]$item.servico
                $linha["Valor"] = $valorItem
                $linha["Custo"] = $custoItem
                $linha["Lucro"] = $valorItem - $custoItem
                $linha["Pagamento"] = [string]$item.pagamento
                $linha["ArquivoHTML"] = [string]$item.arquivoHtml

                [void]$tabela.Rows.Add($linha)

            }

            $tabela.DefaultView.Sort = "Data DESC"

            $dgvResultados.DataSource = $tabela

            if ($dgvResultados.Columns["ArquivoHTML"]) {
                $dgvResultados.Columns["ArquivoHTML"].Visible = $false
            }

            $script:UltimaTabelaResultados = $tabela

            $totalValor = 0.0
            $totalCusto = 0.0

            foreach ($linha in $tabela.Rows) {
                $totalValor += [double]$linha["Valor"]
                $totalCusto += [double]$linha["Custo"]
            }

            $totalLucro = $totalValor - $totalCusto

            $lblTotal.Text = "Atendimentos: $($tabela.Rows.Count)   |   Faturado: R$ $([math]::Round($totalValor,2))   |   Custo pecas: R$ $([math]::Round($totalCusto,2))   |   Lucro: R$ $([math]::Round($totalLucro,2))"

            $txtStatus.Text = "Historico atualizado"

        }
        catch {

            $Window.Cursor = [System.Windows.Input.Cursors]::Arrow

            [System.Windows.Forms.MessageBox]::Show(
                "Erro ao consultar a planilha central:`n`n$($_.Exception.Message)",
                "SKALON - Erro",
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
                "SKALON",
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
                    Select-Object Data, Cliente, Servico, Valor, Custo, Lucro, Pagamento |
                    Export-Csv -Path $salvarDialog.FileName -NoTypeInformation -Encoding UTF8 -Delimiter ";"

                [System.Windows.Forms.MessageBox]::Show(
                    "Arquivo exportado com sucesso!",
                    "SKALON",
                    "OK",
                    "Information"
                )
            }
            catch {
                [System.Windows.Forms.MessageBox]::Show(
                    "Erro ao exportar:`n`n$($_.Exception.Message)",
                    "SKALON - Erro",
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
                    "SKALON",
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

# ============================================================
# CONVERSAO HTML -> PDF (via Edge/Chrome headless)
# ============================================================
# O Edge ja vem instalado por padrao no Windows 10/11, entao nao
# precisamos baixar/instalar nada extra. Se por algum motivo nao
# for encontrado, tentamos o Google Chrome como fallback. Se ambos
# falharem, a funcao retorna $null e o programa segue com o HTML.
# ============================================================

function Find-EdgePath {

    $caminhos = @(
        "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
        "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
        "$env:LOCALAPPDATA\Microsoft\Edge\Application\msedge.exe",
        "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
        "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
        "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
    )

    foreach ($caminho in $caminhos) {
        if ($caminho -and (Test-Path -LiteralPath $caminho)) {
            return $caminho
        }
    }

    $comando = Get-Command msedge.exe, chrome.exe -ErrorAction SilentlyContinue
    if ($comando) {
        return $comando.Source
    }

    return $null

}

function Convert-HtmlParaPdf {

    param(
        [string]$CaminhoHtml,
        [string]$CaminhoPdf
    )

    $edge = Find-EdgePath

    if (-not $edge) {
        return $false
    }

    # Remove um PDF parcial que possa ter sobrado de uma tentativa anterior
    if (Test-Path -LiteralPath $CaminhoPdf) {
        Remove-Item -LiteralPath $CaminhoPdf -Force -ErrorAction SilentlyContinue
    }

    # Perfil temporario proprio: evita conflito com o Edge aberto do usuario
    # (o modo headless reutiliza o perfil padrao se nao for especificado).
    $perfilTemp = Join-Path $env:TEMP "skalon_edge_pdf_$PID"

    try {

        $htmlUri = "file:///" + ($CaminhoHtml -replace '\\', '/')

        $argumentos = @(
            "--headless"
            "--disable-gpu"
            "--no-sandbox"
            "--disable-extensions"
            "--user-data-dir=$perfilTemp"
            "--print-to-pdf=$CaminhoPdf"
            "--no-pdf-header-footer"
            "--no-margins"
            "$htmlUri"
        )

        $processo = Start-Process -FilePath $edge -ArgumentList $argumentos -Wait -PassThru -WindowStyle Hidden -ErrorAction Stop

        if ($processo.ExitCode -eq 0 -and (Test-Path -LiteralPath $CaminhoPdf)) {
            return $true
        }

        return $false

    }
    catch {

        return $false

    }
    finally {

        if (Test-Path -LiteralPath $perfilTemp) {
            Remove-Item -LiteralPath $perfilTemp -Recurse -Force -ErrorAction SilentlyContinue
        }

    }

}

function Gerar-RelatorioServico {

    # ============================================================
    # JANELA DE PREENCHIMENTO
    # ============================================================

    $form = New-Object System.Windows.Forms.Form
    $form.Text = "SKALON - Relatorio de Servico"
    $form.Size = New-Object System.Drawing.Size(650,765)
    $form.StartPosition = "CenterScreen"
    $form.BackColor = [System.Drawing.Color]::FromArgb(17,17,17)
    $form.ForeColor = [System.Drawing.Color]::White
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false

    $lblTitulo = New-Object System.Windows.Forms.Label
    $lblTitulo.Text = "RELATORIO DE SERVICO SKALON"
    $lblTitulo.Location = New-Object System.Drawing.Point(25,20)
    $lblTitulo.Size = New-Object System.Drawing.Size(580,35)
    $lblTitulo.Font = New-Object System.Drawing.Font("Arial",16,[System.Drawing.FontStyle]::Bold)
    $lblTitulo.ForeColor = [System.Drawing.Color]::FromArgb(255,106,0)
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

    # Autocompletar com clientes ja cadastrados no banco de dados
    # (melhor esforco - se o banco nao estiver disponivel nesta
    # maquina, o campo continua funcionando normalmente como texto livre)
    try {

        if (Ensure-SQLiteModule -TimeoutSegundos 3) {

            Initialize-BancoDeDados

            $clientesExistentes = Invoke-SqliteQuery `
                -DataSource $Global:CaminhoBancoDados `
                -Query "SELECT DISTINCT Cliente FROM Relatorios WHERE Cliente IS NOT NULL AND Cliente <> '' ORDER BY Cliente"

            if ($clientesExistentes) {

                $listaAutocompletar = New-Object System.Windows.Forms.AutoCompleteStringCollection

                foreach ($linha in $clientesExistentes) {
                    [void]$listaAutocompletar.Add($linha.Cliente)
                }

                $txtClienteForm.AutoCompleteMode = "SuggestAppend"
                $txtClienteForm.AutoCompleteSource = "CustomSource"
                $txtClienteForm.AutoCompleteCustomSource = $listaAutocompletar

            }

        }

    }
    catch {
        # sem autocompletar disponivel - o campo continua normal
    }

    $lblTelefone = New-Object System.Windows.Forms.Label
    $lblTelefone.Text = "TELEFONE / CONTATO"
    $lblTelefone.Location = New-Object System.Drawing.Point(25,140)
    $lblTelefone.Size = New-Object System.Drawing.Size(200,25)
    $form.Controls.Add($lblTelefone)

    $txtTelefoneForm = New-Object System.Windows.Forms.TextBox
    $txtTelefoneForm.Location = New-Object System.Drawing.Point(25,165)
    $txtTelefoneForm.Size = New-Object System.Drawing.Size(580,30)
    $form.Controls.Add($txtTelefoneForm)

    $lblTipoServico = New-Object System.Windows.Forms.Label
    $lblTipoServico.Text = "TIPO DE SERVICO"
    $lblTipoServico.Location = New-Object System.Drawing.Point(25,205)
    $lblTipoServico.Size = New-Object System.Drawing.Size(250,25)
    $form.Controls.Add($lblTipoServico)

    $cmbTipoServico = New-Object System.Windows.Forms.ComboBox
    $cmbTipoServico.Location = New-Object System.Drawing.Point(25,230)
    $cmbTipoServico.Size = New-Object System.Drawing.Size(580,30)
    $cmbTipoServico.DropDownStyle = "DropDownList"
    [void]$cmbTipoServico.Items.Add("Formatacao e Instalacao do Windows")
    [void]$cmbTipoServico.Items.Add("Limpeza Interna (Hardware)")
    [void]$cmbTipoServico.Items.Add("Manutencao Preventiva")
    [void]$cmbTipoServico.Items.Add("Instalacao de Programas")
    [void]$cmbTipoServico.Items.Add("Remocao de Virus / Malware")
    [void]$cmbTipoServico.Items.Add("Troca de Peca / Componente")
    [void]$cmbTipoServico.Items.Add("Upgrade de Hardware (SSD/RAM)")
    [void]$cmbTipoServico.Items.Add("Backup de Dados")
    [void]$cmbTipoServico.Items.Add("Diagnostico Tecnico")
    [void]$cmbTipoServico.Items.Add("Outro (descrever abaixo)")
    $form.Controls.Add($cmbTipoServico)

    $lblServico = New-Object System.Windows.Forms.Label
    $lblServico.Text = "SERVICO REALIZADO"
    $lblServico.Location = New-Object System.Drawing.Point(25,270)
    $lblServico.Size = New-Object System.Drawing.Size(200,25)
    $form.Controls.Add($lblServico)

    $txtServicoForm = New-Object System.Windows.Forms.TextBox
    $txtServicoForm.Location = New-Object System.Drawing.Point(25,295)
    $txtServicoForm.Size = New-Object System.Drawing.Size(580,80)
    $txtServicoForm.Multiline = $true
    $txtServicoForm.ScrollBars = "Vertical"
    $form.Controls.Add($txtServicoForm)

    $cmbTipoServico.Add_SelectedIndexChanged({
        if ($cmbTipoServico.SelectedItem -eq "Outro (descrever abaixo)") {
            $txtServicoForm.Text = ""
            $txtServicoForm.Focus()
        }
        elseif ($cmbTipoServico.SelectedItem) {
            $txtServicoForm.Text = $cmbTipoServico.SelectedItem.ToString()
        }
    })

    $lblValorPecas = New-Object System.Windows.Forms.Label
    $lblValorPecas.Text = "VALOR DAS PECAS (R$)"
    $lblValorPecas.Location = New-Object System.Drawing.Point(25,385)
    $lblValorPecas.Size = New-Object System.Drawing.Size(180,25)
    $form.Controls.Add($lblValorPecas)

    $txtValorPecasForm = New-Object System.Windows.Forms.TextBox
    $txtValorPecasForm.Location = New-Object System.Drawing.Point(25,410)
    $txtValorPecasForm.Size = New-Object System.Drawing.Size(180,30)
    $txtValorPecasForm.Text = "0"
    $form.Controls.Add($txtValorPecasForm)

    $lblValorServico = New-Object System.Windows.Forms.Label
    $lblValorServico.Text = "VALOR DO SERVICO (R$)"
    $lblValorServico.Location = New-Object System.Drawing.Point(215,385)
    $lblValorServico.Size = New-Object System.Drawing.Size(180,25)
    $form.Controls.Add($lblValorServico)

    $txtValorServicoForm = New-Object System.Windows.Forms.TextBox
    $txtValorServicoForm.Location = New-Object System.Drawing.Point(215,410)
    $txtValorServicoForm.Size = New-Object System.Drawing.Size(180,30)
    $txtValorServicoForm.Text = "0"
    $form.Controls.Add($txtValorServicoForm)

    $lblDesconto = New-Object System.Windows.Forms.Label
    $lblDesconto.Text = "DESCONTO (R$)"
    $lblDesconto.Location = New-Object System.Drawing.Point(405,385)
    $lblDesconto.Size = New-Object System.Drawing.Size(180,25)
    $form.Controls.Add($lblDesconto)

    $txtDescontoForm = New-Object System.Windows.Forms.TextBox
    $txtDescontoForm.Location = New-Object System.Drawing.Point(405,410)
    $txtDescontoForm.Size = New-Object System.Drawing.Size(180,30)
    $txtDescontoForm.Text = "0"
    $form.Controls.Add($txtDescontoForm)

    $lblCusto = New-Object System.Windows.Forms.Label
    $lblCusto.Text = "CUSTO DE PECAS (R$) - uso interno"
    $lblCusto.Location = New-Object System.Drawing.Point(25,452)
    $lblCusto.Size = New-Object System.Drawing.Size(280,25)
    $form.Controls.Add($lblCusto)

    $txtCustoForm = New-Object System.Windows.Forms.TextBox
    $txtCustoForm.Location = New-Object System.Drawing.Point(25,477)
    $txtCustoForm.Size = New-Object System.Drawing.Size(280,30)
    $txtCustoForm.Text = "0"
    $form.Controls.Add($txtCustoForm)

    $lblPagamento = New-Object System.Windows.Forms.Label
    $lblPagamento.Text = "FORMA DE PAGAMENTO"
    $lblPagamento.Location = New-Object System.Drawing.Point(320,452)
    $lblPagamento.Size = New-Object System.Drawing.Size(260,25)
    $form.Controls.Add($lblPagamento)

    $cmbPagamentoForm = New-Object System.Windows.Forms.ComboBox
    $cmbPagamentoForm.Location = New-Object System.Drawing.Point(320,477)
    $cmbPagamentoForm.Size = New-Object System.Drawing.Size(260,30)
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
    $lblObservacoes.Location = New-Object System.Drawing.Point(25,522)
    $lblObservacoes.Size = New-Object System.Drawing.Size(250,25)
    $form.Controls.Add($lblObservacoes)

    $txtObservacoesForm = New-Object System.Windows.Forms.TextBox
    $txtObservacoesForm.Location = New-Object System.Drawing.Point(25,547)
    $txtObservacoesForm.Size = New-Object System.Drawing.Size(580,70)
    $txtObservacoesForm.Multiline = $true
    $txtObservacoesForm.ScrollBars = "Vertical"
    $form.Controls.Add($txtObservacoesForm)

    $btnCancelarForm = New-Object System.Windows.Forms.Button
    $btnCancelarForm.Text = "CANCELAR"
    $btnCancelarForm.Location = New-Object System.Drawing.Point(350,635)
    $btnCancelarForm.Size = New-Object System.Drawing.Size(120,40)
    $btnCancelarForm.BackColor = [System.Drawing.Color]::FromArgb(42,42,42)
    $btnCancelarForm.ForeColor = [System.Drawing.Color]::White
    $btnCancelarForm.Add_Click({
        $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        $form.Close()
    })
    $form.Controls.Add($btnCancelarForm)

    $btnGerarForm = New-Object System.Windows.Forms.Button
    $btnGerarForm.Text = "GERAR RELATORIO"
    $btnGerarForm.Location = New-Object System.Drawing.Point(480,635)
    $btnGerarForm.Size = New-Object System.Drawing.Size(125,40)
    $btnGerarForm.BackColor = [System.Drawing.Color]::FromArgb(255,106,0)
    $btnGerarForm.ForeColor = [System.Drawing.Color]::White
    $btnGerarForm.Add_Click({
        if ([string]::IsNullOrWhiteSpace($txtServicoForm.Text)) {
            [System.Windows.Forms.MessageBox]::Show(
                "Digite o servico realizado.",
                "SKALON",
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
        $valorPecasRaw = $txtValorPecasForm.Text
        $valorServicoRaw = $txtValorServicoForm.Text
        $descontoRaw = $txtDescontoForm.Text
        $custoRaw = $txtCustoForm.Text
        $pagamentoRaw = $cmbPagamentoForm.SelectedItem.ToString()
        $observacoesRaw = $txtObservacoesForm.Text

        $cliente = [System.Net.WebUtility]::HtmlEncode($clienteRaw)
        $telefone = [System.Net.WebUtility]::HtmlEncode($telefoneRaw)
        $servico = [System.Net.WebUtility]::HtmlEncode($servicoRaw)
        $pagamento = [System.Net.WebUtility]::HtmlEncode($pagamentoRaw)
        $observacoes = [System.Net.WebUtility]::HtmlEncode($observacoesRaw)

        $servico = $servico -replace "`r`n","<br>"
        $servico = $servico -replace "`n","<br>"
        $observacoes = $observacoes -replace "`r`n","<br>"
        $observacoes = $observacoes -replace "`n","<br>"

        $reportFolder = $Global:CaminhoPastaRelatorios

        if (!(Test-Path -LiteralPath $reportFolder)) {
            New-Item -Path $reportFolder -ItemType Directory -Force -ErrorAction Stop | Out-Null
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

        # ------------------------------------------------------------
        # Sincroniza com a planilha central ANTES de montar o HTML,
        # para que o numero de OS (gerado pela planilha) ja va
        # embutido no relatorio final.
        # ------------------------------------------------------------

        $dataHoraIso = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $valorPecasNumerico = ConvertTo-ValorNumerico -Texto $valorPecasRaw
        $valorServicoNumerico = ConvertTo-ValorNumerico -Texto $valorServicoRaw
        $descontoNumerico = ConvertTo-ValorNumerico -Texto $descontoRaw
        $custoNumerico = ConvertTo-ValorNumerico -Texto $custoRaw

        $valorNumerico = $valorPecasNumerico + $valorServicoNumerico - $descontoNumerico
        if ($valorNumerico -lt 0) { $valorNumerico = 0 }

        $valorPecasFormatado = $valorPecasNumerico.ToString("F2", [Globalization.CultureInfo]::InvariantCulture).Replace(".", ",")
        $valorServicoFormatado = $valorServicoNumerico.ToString("F2", [Globalization.CultureInfo]::InvariantCulture).Replace(".", ",")
        $descontoFormatado = $descontoNumerico.ToString("F2", [Globalization.CultureInfo]::InvariantCulture).Replace(".", ",")
        $totalFormatado = $valorNumerico.ToString("F2", [Globalization.CultureInfo]::InvariantCulture).Replace(".", ",")

        $descontoHtml = ""
        if ($descontoNumerico -gt 0) {
            $descontoHtml = '<div class="card"><span class="label">Desconto:</span><br>-R$ ' + $descontoFormatado + '</div>'
        }

        $salvouPlanilha = Enviar-RelatorioParaPlanilha `
            -DataHoraIso $dataHoraIso `
            -DataFormatada $data `
            -Cliente $clienteRaw `
            -Telefone $telefoneRaw `
            -Servico $servicoRaw `
            -Valor $valorNumerico `
            -Custo $custoNumerico `
            -ValorPecas $valorPecasNumerico `
            -ValorServico $valorServicoNumerico `
            -Desconto $descontoNumerico `
            -Pagamento $pagamentoRaw `
            -Observacoes $observacoesRaw `
            -Computador "$($computer.Manufacturer) $($computer.Model)" `
            -ArquivoHTML $reportFolder

        $seloNumeroOS = ""
        if ($salvouPlanilha -and $Global:UltimoNumeroOS) {
            $seloNumeroOS = '<div class="numero">OS N&ordm; ' + $Global:UltimoNumeroOS + '</div>'
        }

        # Agora que ja sabemos (ou nao) o numero da OS, montamos o nome
        # final do arquivo: "RelatorioServico 0002-26 - Cliente - dd-MM-yyyy.html"
        $clienteArquivo = $clienteRaw -replace '[\\/:*?"<>|]', '_'
        $dataArquivo = Get-Date -Format "dd-MM-yyyy"

        if ($salvouPlanilha -and $Global:UltimoNumeroOS) {
            $prefixoArquivo = "RelatorioServico $($Global:UltimoNumeroOS) - $clienteArquivo - $dataArquivo"
        }
        else {
            $prefixoArquivo = "RelatorioServico SEM-NUMERO - $clienteArquivo - $dataArquivo"
        }

        $reportFile = Join-Path $reportFolder "$prefixoArquivo.html"

        # Se ja existe um relatorio com o mesmo nome (raro, mas possivel
        # em reenvios manuais), evita sobrescrever adicionando (2), (3)...
        $contador = 2
        while (Test-Path -LiteralPath $reportFile) {
            $reportFile = Join-Path $reportFolder "$prefixoArquivo ($contador).html"
            $contador++
        }

        $garantiaHtml = @'
<p>A <strong>Skalon Inform&aacute;tica</strong> oferece <strong>90 (noventa) dias de garantia</strong>, contados a partir da data de conclus&atilde;o do servi&ccedil;o, conforme previsto no C&oacute;digo de Defesa do Consumidor, exclusivamente para os servi&ccedil;os executados e para as pe&ccedil;as fornecidas pela assist&ecirc;ncia t&eacute;cnica.</p>

<h3>A garantia cobre:</h3>
<ul>
<li>Defeitos relacionados ao servi&ccedil;o executado;</li>
<li>Falhas na instala&ccedil;&atilde;o, montagem ou aplica&ccedil;&atilde;o do reparo realizado pela assist&ecirc;ncia;</li>
<li>Defeitos de fabrica&ccedil;&atilde;o das pe&ccedil;as fornecidas pela assist&ecirc;ncia, quando aplic&aacute;vel.</li>
</ul>

<h3>Pe&ccedil;as fornecidas pelo cliente</h3>
<p>Quando o cliente fornecer pe&ccedil;as, componentes ou acess&oacute;rios adquiridos por conta pr&oacute;pria, a <strong>Skalon Inform&aacute;tica</strong> ser&aacute; respons&aacute;vel exclusivamente pela correta instala&ccedil;&atilde;o e pelo servi&ccedil;o executado.</p>
<p>A garantia das pe&ccedil;as, componentes ou acess&oacute;rios fornecidos pelo cliente &eacute; de responsabilidade do fabricante ou da loja onde foram adquiridos. Em caso de defeito de fabrica&ccedil;&atilde;o, troca em garantia ou necessidade de substitui&ccedil;&atilde;o dessas pe&ccedil;as, o cliente dever&aacute; acionar diretamente o fornecedor.</p>
<p>Caso seja necess&aacute;rio realizar nova desmontagem, testes, reinstala&ccedil;&atilde;o ou substitui&ccedil;&atilde;o de componentes em raz&atilde;o de defeitos apresentados nas pe&ccedil;as fornecidas pelo cliente, poder&aacute; ser cobrada nova m&atilde;o de obra, mediante or&ccedil;amento pr&eacute;vio.</p>

<h3>A garantia n&atilde;o cobre:</h3>
<ul>
<li>Danos causados por mau uso, quedas, impactos ou press&atilde;o excessiva;</li>
<li>Contato com l&iacute;quidos, umidade, oxida&ccedil;&atilde;o ou corros&atilde;o;</li>
<li>Surtos el&eacute;tricos, descargas atmosf&eacute;ricas, oscila&ccedil;&otilde;es de energia ou problemas na rede el&eacute;trica;</li>
<li>Defeitos decorrentes de v&iacute;rus, softwares de terceiros, atualiza&ccedil;&otilde;es de sistema operacional ou altera&ccedil;&otilde;es de configura&ccedil;&atilde;o realizadas ap&oacute;s a entrega do equipamento;</li>
<li>Perda, corrup&ccedil;&atilde;o, bloqueio ou recupera&ccedil;&atilde;o de dados. &Eacute; de responsabilidade do cliente manter c&oacute;pia de seguran&ccedil;a (backup) de seus arquivos;</li>
<li>Defeitos diferentes daqueles descritos na Ordem de Servi&ccedil;o ou surgidos posteriormente ao reparo;</li>
<li>Defeitos de fabrica&ccedil;&atilde;o em pe&ccedil;as fornecidas pelo cliente;</li>
<li>Custos relacionados &agrave; garantia, troca, envio ou devolu&ccedil;&atilde;o de pe&ccedil;as adquiridas pelo cliente em lojas f&iacute;sicas ou online;</li>
<li>Pe&ccedil;as ou componentes quebrados, riscados ou danificados ap&oacute;s a entrega do equipamento;</li>
<li>Equipamentos que tenham sido abertos, violados, modificados ou reparados por terceiros durante o per&iacute;odo de garantia;</li>
<li>Equipamentos fora do prazo de garantia.</li>
</ul>

<h3>Equipamentos usados</h3>
<p>Equipamentos eletr&ocirc;nicos est&atilde;o sujeitos ao desgaste natural de seus componentes. Em aparelhos com sinais de desgaste, oxida&ccedil;&atilde;o, adapta&ccedil;&otilde;es, manuten&ccedil;&atilde;o anterior ou reparos realizados por terceiros, poder&atilde;o surgir defeitos n&atilde;o relacionados ao servi&ccedil;o executado.</p>
<p>Nessas situa&ccedil;&otilde;es, a garantia permanece restrita exclusivamente ao reparo descrito na Ordem de Servi&ccedil;o, n&atilde;o abrangendo outros componentes do equipamento.</p>

<h3>Observa&ccedil;&otilde;es</h3>
<ul>
<li>A garantia &eacute; limitada exclusivamente ao servi&ccedil;o executado e &agrave;s pe&ccedil;as substitu&iacute;das pela assist&ecirc;ncia t&eacute;cnica, n&atilde;o abrangendo o equipamento como um todo.</li>
<li>Caso seja constatado que o defeito apresentado n&atilde;o possui rela&ccedil;&atilde;o com o servi&ccedil;o anteriormente realizado, poder&aacute; ser cobrada uma nova avalia&ccedil;&atilde;o t&eacute;cnica e, se necess&aacute;rio, um novo or&ccedil;amento.</li>
<li>Para atendimento em garantia, poder&aacute; ser solicitada a apresenta&ccedil;&atilde;o do Relat&oacute;rio de Servi&ccedil;o ou da Ordem de Servi&ccedil;o correspondente.</li>
<li>A garantia ter&aacute; in&iacute;cio na data de conclus&atilde;o do servi&ccedil;o, seja na retirada do equipamento pelo cliente ou na finaliza&ccedil;&atilde;o do atendimento em domic&iacute;lio.</li>
</ul>
'@

        $html = @"
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<title>Relatorio de Servico - SKALON</title>
<style>
body { font-family: Arial; background:#FFFFFF; padding:30px; color:#111111; }
.container { max-width:1000px; margin:auto; background:white; padding:35px; }
.header { border-bottom:3px solid #FF6A00; padding-bottom:20px; }
.header h1 { color:#FF6A00; }
.header .slogan { color:#666; font-style:italic; font-size:13px; margin-top:5px; }
.header .numero { display:inline-block; background:#111111; color:#FF6A00; font-weight:bold; padding:6px 14px; border-radius:6px; margin-top:10px; font-size:15px; }
h2 { background:#111111; color:white; padding:10px; }
.info { display:grid; grid-template-columns:1fr 1fr; gap:10px; }
.card { background:#f9fafb; border:1px solid #ddd; padding:15px; }
.label { font-weight:bold; }
.valor { font-size:24px; font-weight:bold; color:#FF6A00; }
table { width:100%; border-collapse:collapse; }
th { background:#FF6A00; color:white; padding:10px; }
td { border:1px solid #ddd; padding:10px; }
.servico { background:#f9fafb; border:1px solid #ddd; padding:20px; min-height:80px; }
.garantia { background:#f9fafb; border:1px solid #ddd; padding:20px; font-size:13px; line-height:1.6; text-align:justify; }
.garantia h3 { color:#FF6A00; margin-top:18px; margin-bottom:6px; font-size:15px; }
.garantia h3:first-child { margin-top:0; }
.garantia p { margin:8px 0; }
.garantia ul { margin:6px 0 14px 22px; }
.garantia li { margin-bottom:4px; }
.footer { margin-top:40px; border-top:1px solid #ddd; padding-top:15px; font-size:12px; color:#666; }
</style>
</head>
<body>
<div class="container">
<div class="header">
<h1>SKALON</h1>
<p class="slogan">Performance para quem trabalha. Potência para quem joga.</p>
<p>RELATORIO DE SERVICO TECNICO</p>
<p>Cleaner Pro v$Global:VersaoAplicativo</p>
$seloNumeroOS
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
<div class="card"><span class="label">Valor das Pecas:</span><br>R$ $valorPecasFormatado</div>
<div class="card"><span class="label">Valor do Servico:</span><br>R$ $valorServicoFormatado</div>
$descontoHtml
<div class="card"><span class="label">Pagamento:</span><br><br>$pagamento</div>
</div>
<div class="card" style="margin-top:12px;"><span class="label">TOTAL A PAGAR:</span><div class="valor">R$ $totalFormatado</div></div>
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
<h2>CONDICOES DE GARANTIA</h2>
<div class="garantia">$garantiaHtml</div>
<div class="footer">
SKALON - Performance para quem trabalha. Potência para quem joga.<br>
Relatorio gerado automaticamente pelo Cleaner Pro v$Global:VersaoAplicativo.
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

        $txtStatus.Text = "Convertendo para PDF..."

        $pdfFile = $reportFile -replace '\.html$', '.pdf'
        $gerouPdf = Convert-HtmlParaPdf -CaminhoHtml $reportFile -CaminhoPdf $pdfFile

        $txtStatus.Text = "Relatorio criado com sucesso"

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

        if ($gerouPdf) {
            Start-Process -FilePath $pdfFile
        }
        else {
            Start-Process -FilePath $reportFile
        }

        $avisoBanco = ""
        $tituloOS = ""

        if ($salvouPlanilha) {
            $txtStatus.Text = "Relatorio criado e sincronizado com a planilha central"
            if ($Global:UltimoNumeroOS) {
                $tituloOS = "`n`nOS N$([char]0x00BA) $Global:UltimoNumeroOS"
            }
        }
        elseif ($salvouBanco) {
            $txtStatus.Text = "Relatorio criado (salvo so localmente)"
            $avisoBanco = "`n`nATENCAO: nao foi possivel sincronizar com a planilha central. O relatorio ficou salvo apenas no banco local desta maquina (sem numero de OS).`n`nMotivo: $Global:UltimoErroPlanilha"
        }
        else {
            $txtStatus.Text = "Relatorio criado (banco de dados indisponivel)"
            $avisoBanco = "`n`nATENCAO: nao foi possivel registrar nem na planilha central nem no banco local (sem numero de OS). O arquivo HTML foi salvo normalmente.`n`nMotivo (planilha): $Global:UltimoErroPlanilha"
        }

        $linhaArquivo = if ($gerouPdf) { "Arquivo (PDF):`n$pdfFile" } else { "Arquivo (HTML):`n$reportFile`n`nObs: nao foi possivel gerar o PDF automaticamente (Microsoft Edge nao encontrado nesta maquina)." }

        $statusLog =
            if ($salvouPlanilha) { "sincronizado com planilha central (OS $Global:UltimoNumeroOS)" }
            elseif ($salvouBanco) { "salvo apenas no banco local" }
            else { "banco de dados indisponivel" }

        Write-LogCleaner -Mensagem "Relatorio de servico gerado: $reportFile (status: $statusLog)."

        [System.Windows.MessageBox]::Show(
            "Relatorio criado com sucesso!$tituloOS`n`n$linhaArquivo$avisoBanco",
            "SKALON",
            "OK",
            "Information"
        )

    }
    catch {

        $txtStatus.Text = "Erro ao gerar relatorio"

        Write-LogCleaner -Mensagem "Erro ao gerar relatorio: $($_.Exception.Message)"

        [System.Windows.MessageBox]::Show(
            "ERRO AO GERAR RELATORIO:`n`n$($_.Exception.Message)",
            "SKALON - Erro",
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
        "SKALON",
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
        "SKALON - Navegadores",
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
        "SKALON - Lixeira",
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
        "Deseja fechar o SKALON Cleaner Pro?",
        "SKALON",
        "YesNo",
        "Question"
    )
    if ($confirmacao -eq "Yes") { $Window.Close() }
})

# ============================================================
# INICIALIZAR
# ============================================================

Atualizar-Informacoes

# Dispara em segundo plano (nao bloqueia a abertura do programa)
# a instalacao do modulo PSSQLite, usado pelo Relatorio de Servico
# e pelo Historico/Faturamento. Se o PC ja tiver internet lenta ou
# nenhuma, o programa abre normalmente do mesmo jeito - o modulo
# so sera necessario quando o tecnico realmente usar essas funcoes.
$Global:JobInstalacaoSQLite = $null

try {

    $Global:JobInstalacaoSQLite = Start-Job -ScriptBlock {

        try {

            Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force -ErrorAction SilentlyContinue

            if (Get-Module -ListAvailable -Name PSSQLite) {
                return [PSCustomObject]@{ Sucesso = $true; Erro = $null }
            }

            $ConfirmPreference = 'None'

            [Net.ServicePointManager]::SecurityProtocol =
                [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

            $repositorio = Get-PSRepository -Name PSGallery -ErrorAction SilentlyContinue

            if ($repositorio -and $repositorio.InstallationPolicy -ne 'Trusted') {
                Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -ErrorAction SilentlyContinue
            }

            $identidadeJob = [Security.Principal.WindowsIdentity]::GetCurrent()
            $principalJob = New-Object Security.Principal.WindowsPrincipal($identidadeJob)
            $escopoInstalacao = "CurrentUser"

            if ($principalJob.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
                $escopoInstalacao = "AllUsers"
            }
            else {
                $pastaModulosUsuario = Join-Path ([Environment]::GetFolderPath('MyDocuments')) "WindowsPowerShell\Modules"
                if (-not (Test-Path $pastaModulosUsuario)) {
                    New-Item -Path $pastaModulosUsuario -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
                }
            }

            if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
                Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ForceBootstrap -Confirm:$false -Scope $escopoInstalacao -ErrorAction Stop | Out-Null
            }

            Install-Module -Name PSSQLite -Scope $escopoInstalacao -Force -AllowClobber -Confirm:$false -ErrorAction Stop

            return [PSCustomObject]@{ Sucesso = $true; Erro = $null }

        }
        catch {

            return [PSCustomObject]@{ Sucesso = $false; Erro = $_.Exception.Message }

        }

    }

}
catch {

    $Global:JobInstalacaoSQLite = $null

}

$Window.ShowDialog() | Out-Null
