# ============================================================
# TECH INFO BELEM - CLEANER PRO v0.5
# Assistencia Tecnica
# ============================================================

$Host.UI.RawUI.WindowTitle = "TECH INFO BELEM - CLEANER PRO v0.5"

# ============================================================
# CORES
# ============================================================

$Azul = "`e[94m"
$Vermelho = "`e[91m"
$Verde = "`e[92m"
$Amarelo = "`e[93m"
$Ciano = "`e[96m"
$Branco = "`e[97m"
$Reset = "`e[0m"

# ============================================================
# PASTAS
# ============================================================

$PastaBase = Join-Path $env:USERPROFILE "Documents\TECH INFO BELEM"
$PastaRelatorios = Join-Path $PastaBase "Relatorios"

if (!(Test-Path $PastaRelatorios)) {
    New-Item -ItemType Directory -Path $PastaRelatorios -Force | Out-Null
}

# ============================================================
# VARIAVEIS GLOBAIS
# ============================================================

$script:DadosSistema = @{}
$script:Procedimentos = New-Object System.Collections.Generic.List[string]

# ============================================================
# CABECALHO
# ============================================================

function Mostrar-Cabecalho {

    Clear-Host

    Write-Host ""
    Write-Host "============================================" -ForegroundColor DarkGray
    Write-Host "        TECH INFO BELEM" -ForegroundColor Blue
    Write-Host "        CLEANER PRO v0.5" -ForegroundColor Red
    Write-Host "============================================" -ForegroundColor DarkGray
    Write-Host ""
}

# ============================================================
# PAUSA
# ============================================================

function Pausar {

    Write-Host ""
    Write-Host "Pressione qualquer tecla para continuar..." -ForegroundColor DarkGray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# ============================================================
# COLETAR INFORMACOES DO SISTEMA
# ============================================================

function Coletar-InformacoesSistema {

    Write-Host ""
    Write-Host "Coletando informacoes do computador..." -ForegroundColor Yellow
    Write-Host ""

    try {

        $Computer = Get-CimInstance Win32_ComputerSystem
        $OS = Get-CimInstance Win32_OperatingSystem
        $CPU = Get-CimInstance Win32_Processor | Select-Object -First 1
        $BIOS = Get-CimInstance Win32_BIOS
        $BaseBoard = Get-CimInstance Win32_BaseBoard

        $RAMGB = [math]::Round($Computer.TotalPhysicalMemory / 1GB, 2)

        $Discos = Get-PhysicalDisk -ErrorAction SilentlyContinue

        $ListaDiscos = @()

        foreach ($Disco in $Discos) {

            $Saude = $Disco.HealthStatus
            $Tamanho = [math]::Round($Disco.Size / 1GB, 2)

            $ListaDiscos += [PSCustomObject]@{
                Modelo = $Disco.FriendlyName
                Tipo = $Disco.MediaType
                Tamanho = "$Tamanho GB"
                Saude = $Saude
            }
        }

        $script:DadosSistema = @{
            Fabricante = $Computer.Manufacturer
            Modelo = $Computer.Model
            Processador = $CPU.Name
            RAM = "$RAMGB GB"
            Sistema = $OS.Caption
            VersaoWindows = $OS.Version
            Build = $OS.BuildNumber
            BIOS = $BIOS.SMBIOSBIOSVersion
            PlacaMae = "$($BaseBoard.Manufacturer) $($BaseBoard.Product)"
            Discos = $ListaDiscos
        }

        Write-Host "Informacoes coletadas com sucesso!" -ForegroundColor Green

    }
    catch {

        Write-Host "Nao foi possivel coletar todas as informacoes." -ForegroundColor Red
    }

    Pausar
}

# ============================================================
# LIMPAR TEMPORARIOS
# ============================================================

function Limpar-Temporarios {

    Mostrar-Cabecalho

    Write-Host "LIMPEZA DE ARQUIVOS TEMPORARIOS" -ForegroundColor Yellow
    Write-Host ""

    Write-Host "Limpando temporarios do usuario..."
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "Limpando temporarios do Windows..."
    Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "Limpando arquivos recentes..."
    Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\*" -Force -ErrorAction SilentlyContinue

    if (!$script:Procedimentos.Contains("Limpeza de arquivos temporarios")) {
        $script:Procedimentos.Add("Limpeza de arquivos temporarios")
    }

    Write-Host ""
    Write-Host ">>> LIMPEZA CONCLUIDA!" -ForegroundColor Green

    Pausar
}

# ============================================================
# LIMPAR NAVEGADORES
# ============================================================

function Limpar-Navegadores {

    Mostrar-Cabecalho

    Write-Host "LIMPEZA DE CACHE DOS NAVEGADORES" -ForegroundColor Yellow
    Write-Host ""

    $Caminhos = @(
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache",
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache",
        "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Cache",
        "$env:APPDATA\Opera Software\Opera Stable\Cache",
        "$env:APPDATA\Opera Software\Opera GX Stable\Cache"
    )

    foreach ($Caminho in $Caminhos) {

        if (Test-Path $Caminho) {

            Write-Host "Limpando: $Caminho"

            Remove-Item "$Caminho\*" -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    if ($script:Procedimentos -notcontains "Limpeza de cache dos navegadores") {
        $script:Procedimentos.Add("Limpeza de cache dos navegadores")
    }

    Write-Host ""
    Write-Host ">>> CACHE DOS NAVEGADORES LIMPO!" -ForegroundColor Green

    Pausar
}

# ============================================================
# LIXEIRA
# ============================================================

function Limpar-Lixeira {

    Mostrar-Cabecalho

    Write-Host "ESVAZIANDO LIXEIRA" -ForegroundColor Yellow
    Write-Host ""

    Clear-RecycleBin -Force -ErrorAction SilentlyContinue

    if ($script:Procedimentos -notcontains "Esvaziamento da lixeira") {
        $script:Procedimentos.Add("Esvaziamento da lixeira")
    }

    Write-Host ">>> LIXEIRA ESVAZIADA!" -ForegroundColor Green

    Pausar
}

# ============================================================
# SFC
# ============================================================

function Executar-SFC {

    Mostrar-Cabecalho

    Write-Host "VERIFICACAO SFC" -ForegroundColor Yellow
    Write-Host ""

    sfc /scannow

    if ($script:Procedimentos -notcontains "Verificacao e reparo do Windows com SFC") {
        $script:Procedimentos.Add("Verificacao e reparo do Windows com SFC")
    }

    Write-Host ""
    Write-Host ">>> SFC FINALIZADO!" -ForegroundColor Green

    Pausar
}

# ============================================================
# DISM
# ============================================================

function Executar-DISM {

    Mostrar-Cabecalho

    Write-Host "REPARO DA IMAGEM DO WINDOWS - DISM" -ForegroundColor Yellow
    Write-Host ""

    DISM /Online /Cleanup-Image /RestoreHealth

    if ($script:Procedimentos -notcontains "Reparo da imagem do Windows com DISM") {
        $script:Procedimentos.Add("Reparo da imagem do Windows com DISM")
    }

    Write-Host ""
    Write-Host ">>> DISM FINALIZADO!" -ForegroundColor Green

    Pausar
}

# ============================================================
# SAUDE SSD / HD
# ============================================================

function Verificar-SaudeDisco {

    Mostrar-Cabecalho

    Write-Host "SAUDE DO SSD / HD" -ForegroundColor Yellow
    Write-Host ""

    Get-PhysicalDisk |
    Select-Object FriendlyName, MediaType, Size, HealthStatus |
    Format-Table -AutoSize

    if ($script:Procedimentos -notcontains "Verificacao de saude do SSD / HD") {
        $script:Procedimentos.Add("Verificacao de saude do SSD / HD")
    }

    Pausar
}

# ============================================================
# INFORMACOES DE REDE
# ============================================================

function Mostrar-InformacoesRede {

    Mostrar-Cabecalho

    Write-Host "INFORMACOES DE REDE" -ForegroundColor Yellow
    Write-Host ""

    $Config = Get-NetIPConfiguration |
        Where-Object {$_.IPv4DefaultGateway -ne $null} |
        Select-Object -First 1

    if ($Config) {

        Write-Host "Interface : $($Config.InterfaceAlias)"
        Write-Host "IP        : $($Config.IPv4Address.IPAddress)"
        Write-Host "Gateway   : $($Config.IPv4DefaultGateway.NextHop)"
        Write-Host "DNS       : $($Config.DnsServer.ServerAddresses -join ', ')"
    }

    Pausar
}

# ============================================================
# SENHA WIFI
# ============================================================

function Mostrar-SenhaWiFi {

    Mostrar-Cabecalho

    Write-Host "SENHA DA REDE WI-FI" -ForegroundColor Yellow
    Write-Host ""

    $Perfil = (netsh wlan show interfaces |
        Select-String "SSID" |
        Select-Object -First 1).ToString()

    if (!$Perfil) {

        Write-Host "Nenhuma rede Wi-Fi identificada." -ForegroundColor Red
        Pausar
        return
    }

    $SSID = ($Perfil -split ":",2)[1].Trim()

    Write-Host "Rede atual: $SSID" -ForegroundColor Cyan
    Write-Host ""

    $Resultado = netsh wlan show profile name="$SSID" key=clear

    $LinhaSenha = $Resultado |
        Select-String "Key Content"

    if ($LinhaSenha) {

        $Senha = ($LinhaSenha.ToString() -split ":",2)[1].Trim()

        Write-Host "Senha: $Senha" -ForegroundColor Green

    }
    else {

        Write-Host "Nao foi possivel obter a senha." -ForegroundColor Red
    }

    Pausar
}

# ============================================================
# REMOVER XBOX
# ============================================================

function Remover-Xbox {

    Mostrar-Cabecalho

    Write-Host "REMOCAO DE COMPONENTES XBOX" -ForegroundColor Yellow
    Write-Host ""

    Write-Host "ATENCAO!" -ForegroundColor Red
    Write-Host "Esta operacao remove aplicativos e componentes Xbox."
    Write-Host ""

    $Confirmacao = Read-Host "Digite SIM para continuar"

    if ($Confirmacao -ne "SIM") {

        Write-Host ""
        Write-Host "Operacao cancelada." -ForegroundColor Yellow

        Pausar
        return
    }

    $Pacotes = @(
        "Microsoft.XboxApp",
        "Microsoft.XboxGamingOverlay",
        "Microsoft.XboxIdentityProvider",
        "Microsoft.Xbox.TCUI",
        "Microsoft.GamingApp"
    )

    foreach ($Pacote in $Pacotes) {

        Get-AppxPackage -AllUsers -Name $Pacote |
            Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
    }

    Write-Host ""
    Write-Host ">>> COMPONENTES XBOX REMOVIDOS!" -ForegroundColor Green

    if ($script:Procedimentos -notcontains "Remocao de aplicativos Xbox") {
        $script:Procedimentos.Add("Remocao de aplicativos Xbox")
    }

    Pausar
}

# ============================================================
# CHRIS TITUS
# ============================================================

function Abrir-ChrisTitus {

    Mostrar-Cabecalho

    Write-Host "ABRINDO WINDOWS UTILITY - CHRIS TITUS" -ForegroundColor Yellow
    Write-Host ""

    Write-Host "Iniciando ferramenta..." -ForegroundColor Green

    irm "https://christitus.com/win" | iex

    Pausar
}

# ============================================================
# MENU DE SERVICOS
# ============================================================

function Selecionar-Servicos {

    Mostrar-Cabecalho

    Write-Host "RELATORIO POS-SERVICO" -ForegroundColor Red
    Write-Host ""

    $script:Cliente = Read-Host "Nome do cliente"
    $script:Telefone = Read-Host "Telefone do cliente"

    Write-Host ""
    Write-Host "EQUIPAMENTO"
    Write-Host ""

    Write-Host "[1] Desktop Gamer"
    Write-Host "[2] Desktop Office"
    Write-Host "[3] Notebook"

    $EquipEscolha = Read-Host "Escolha"

    switch ($EquipEscolha) {

        "1" { $script:Equipamento = "Desktop Gamer" }
        "2" { $script:Equipamento = "Desktop Office" }
        "3" {
            $Modelo = Read-Host "Marca / Modelo do Notebook"
            $script:Equipamento = "Notebook - $Modelo"
        }
        default {
            $script:Equipamento = "Nao informado"
        }
    }

    Write-Host ""
    Write-Host "SERVICOS REALIZADOS" -ForegroundColor Yellow
    Write-Host ""

    Write-Host "[1] Formatacao com backup"
    Write-Host "[2] Instalacao do sistema"
    Write-Host "[3] Drivers e softwares uteis"
    Write-Host "[4] Instalacao de Office"
    Write-Host "[5] Ativacao do sistema"
    Write-Host "[6] Ativacao de sistema e Office"
    Write-Host "[7] Instalacao de antivirus"
    Write-Host "[8] Otimizacao do sistema"
    Write-Host "[9] Limpeza preventiva"
    Write-Host "[10] Limpeza corretiva"
    Write-Host "[11] Instalacao de hardware"
    Write-Host "[12] Instalacao de software"
    Write-Host "[13] Ponto de restauracao"
    Write-Host "[14] Atualizacoes via Winget"
    Write-Host "[15] Troca de tela"
    Write-Host "[16] Outro"

    $Escolhas = Read-Host "Digite os numeros separados por espaco"

    $MapaServicos = @{
        "1" = "Formatacao com backup"
        "2" = "Instalacao do sistema"
        "3" = "Instalacao de drivers e softwares uteis"
        "4" = "Instalacao de Office"
        "5" = "Ativacao do sistema"
        "6" = "Ativacao de sistema e Office"
        "7" = "Instalacao de antivirus"
        "8" = "Otimizacao do sistema"
        "9" = "Limpeza preventiva"
        "10" = "Limpeza corretiva"
        "11" = "Instalacao de hardware"
        "12" = "Instalacao de software"
        "13" = "Criacao de ponto de restauracao"
        "14" = "Atualizacoes via Winget"
        "15" = "Troca de tela"
    }

    $script:Servicos = New-Object System.Collections.Generic.List[string]

    foreach ($Escolha in $Escolhas -split " ") {

        if ($MapaServicos.ContainsKey($Escolha)) {

            $script:Servicos.Add($MapaServicos[$Escolha])
        }

        if ($Escolha -eq "16") {

            $Outro = Read-Host "Descreva o servico"
            $script:Servicos.Add($Outro)
        }
    }

    Write-Host ""
    Write-Host "LOCAL DO SERVICO" -ForegroundColor Yellow
    Write-Host ""

    Write-Host "[1] Assistencia tecnica"
    Write-Host "[2] No local do cliente"
    Write-Host "[3] Busca e entrega"

    $LocalEscolha = Read-Host "Escolha"

    switch ($LocalEscolha) {

        "1" { $script:LocalServico = "Assistencia tecnica" }
        "2" { $script:LocalServico = "No local do cliente" }
        "3" { $script:LocalServico = "Busca e entrega no local" }
        default { $script:LocalServico = "Nao informado" }
    }

    $script:Valor = Read-Host "Valor do servico (ex: 150,00)"

    Write-Host ""
    Write-Host "FORMA DE PAGAMENTO" -ForegroundColor Yellow
    Write-Host ""

    Write-Host "[1] PIX"
    Write-Host "[2] Dinheiro"
    Write-Host "[3] Cartao"
    Write-Host "[4] Transferencia"

    $PagamentoEscolha = Read-Host "Escolha"

    switch ($PagamentoEscolha) {

        "1" { $script:Pagamento = "PIX" }
        "2" { $script:Pagamento = "Dinheiro" }
        "3" { $script:Pagamento = "Cartao" }
        "4" { $script:Pagamento = "Transferencia" }
        default { $script:Pagamento = "Nao informado" }
    }

    $script:Observacoes = Read-Host "Observacoes do tecnico"

    Pausar
}

# ============================================================
# GERAR RELATORIO
# ============================================================

function Gerar-Relatorio {

    Mostrar-Cabecalho

    Write-Host "GERANDO RELATORIO DE SERVICO..." -ForegroundColor Yellow
    Write-Host ""

    $Data = Get-Date -Format "dd/MM/yyyy"
    $DataArquivo = Get-Date -Format "dd-MM-yyyy"

    $NomeSeguro = $script:Cliente -replace '[\\/:*?"<>|]', '-'

    $PastaAno = Join-Path $PastaRelatorios (Get-Date -Format "yyyy")
    $PastaMes = Join-Path $PastaAno (Get-Date -Format "MM - MMMM")

    if (!(Test-Path $PastaMes)) {

        New-Item -ItemType Directory -Path $PastaMes -Force | Out-Null
    }

    $NomeArquivo = "Relatorio_${NomeSeguro}_${DataArquivo}"

    $ArquivoTXT = Join-Path $PastaMes "$NomeArquivo.txt"
    $ArquivoHTML = Join-Path $PastaMes "$NomeArquivo.html"

    $ListaServicos = ($script:Servicos -join "<br>")

    $ListaProcedimentos = ($script:Procedimentos -join "<br>")

    $ListaDiscosHTML = ""

    foreach ($Disco in $script:DadosSistema.Discos) {

        $ListaDiscosHTML += @"
<tr>
<td>$($Disco.Modelo)</td>
<td>$($Disco.Tipo)</td>
<td>$($Disco.Tamanho)</td>
<td>$($Disco.Saude)</td>
</tr>
"@
    }

    $HTML = @"
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">

<title>Relatório TECH INFO BELÉM</title>

<style>

body {
    font-family: Arial, sans-serif;
    margin: 40px;
    color: #222;
}

.container {
    max-width: 850px;
    margin: auto;
}

.header {
    text-align: center;
    border-bottom: 3px solid #222;
    padding-bottom: 15px;
}

.header h1 {
    margin: 0;
    color: #1e4f9a;
}

.header h2 {
    color: #c62828;
}

.section {
    margin-top: 25px;
}

.section h3 {
    background: #eee;
    padding: 10px;
    border-left: 5px solid #1e4f9a;
}

table {
    width: 100%;
    border-collapse: collapse;
}

td, th {
    border: 1px solid #ccc;
    padding: 8px;
    text-align: left;
}

.footer {
    margin-top: 50px;
    text-align: center;
}

.assinatura {
    margin-top: 50px;
    text-align: center;
}

@media print {

    body {
        margin: 20px;
    }

}

</style>

</head>

<body>

<div class="container">

<div class="header">

<h1>TECH INFO BELÉM</h1>

<h2>RELATÓRIO PÓS-SERVIÇO</h2>

<p>Assistência Técnica em Computadores, Notebooks e Celulares</p>

</div>

<div class="section">

<h3>DADOS DO SERVIÇO</h3>

<p><strong>Data:</strong> $Data</p>

<p><strong>Cliente:</strong> $script:Cliente</p>

<p><strong>Telefone:</strong> $script:Telefone</p>

<p><strong>Local do serviço:</strong> $script:LocalServico</p>

<p><strong>Técnico responsável:</strong> Jaime Junior</p>

</div>

<div class="section">

<h3>EQUIPAMENTO</h3>

<p><strong>Tipo:</strong> $script:Equipamento</p>

<p><strong>Fabricante:</strong> $($script:DadosSistema.Fabricante)</p>

<p><strong>Modelo:</strong> $($script:DadosSistema.Modelo)</p>

<p><strong>Sistema operacional:</strong> $($script:DadosSistema.Sistema)</p>

<p><strong>Versão:</strong> $($script:DadosSistema.VersaoWindows)</p>

<p><strong>Build:</strong> $($script:DadosSistema.Build)</p>

<p><strong>Processador:</strong> $($script:DadosSistema.Processador)</p>

<p><strong>Memória RAM:</strong> $($script:DadosSistema.RAM)</p>

<p><strong>BIOS:</strong> $($script:DadosSistema.BIOS)</p>

<p><strong>Placa-mãe:</strong> $($script:DadosSistema.PlacaMae)</p>

</div>

<div class="section">

<h3>ARMAZENAMENTO</h3>

<table>

<tr>
<th>Modelo</th>
<th>Tipo</th>
<th>Capacidade</th>
<th>Saúde</th>
</tr>

$ListaDiscosHTML

</table>

</div>

<div class="section">

<h3>SERVIÇOS REALIZADOS</h3>

<p>$ListaServicos</p>

</div>

<div class="section">

<h3>PROCEDIMENTOS EXECUTADOS PELO CLEANER PRO</h3>

<p>$ListaProcedimentos</p>

</div>

<div class="section">

<h3>VALOR E PAGAMENTO</h3>

<p><strong>Valor do serviço:</strong> R$ $script:Valor</p>

<p><strong>Forma de pagamento:</strong> $script:Pagamento</p>

</div>

<div class="section">

<h3>OBSERVAÇÕES</h3>

<p>$script:Observacoes</p>

</div>

<div class="section">

<h3>TERMO DE GARANTIA</h3>

<p>
A garantia do serviço está limitada aos procedimentos realizados pela
TECH INFO BELÉM e não cobre problemas decorrentes de mau uso,
alterações posteriores, falhas de hardware ou outros fatores externos
ao serviço executado.
</p>

</div>

<div class="assinatura">

________________________________________

<p>Assinatura do cliente</p>

<br>

________________________________________

<p>Jaime Junior - Técnico responsável</p>

</div>

<div class="footer">

<p>TECH INFO BELÉM</p>

<p>Relatório gerado pelo Cleaner Pro v0.5</p>

</div>

</div>

</body>

</html>
"@

    $HTML | Out-File -FilePath $ArquivoHTML -Encoding UTF8

    $Texto = @"

========================================
        TECH INFO BELEM
    RELATORIO POS-SERVICO v0.5
========================================

Data: $Data

CLIENTE
Nome: $script:Cliente
Telefone: $script:Telefone

EQUIPAMENTO
Tipo: $script:Equipamento
Fabricante: $($script:DadosSistema.Fabricante)
Modelo: $($script:DadosSistema.Modelo)

SISTEMA
Sistema: $($script:DadosSistema.Sistema)
Versao: $($script:DadosSistema.VersaoWindows)
Build: $($script:DadosSistema.Build)

HARDWARE
Processador: $($script:DadosSistema.Processador)
Memoria RAM: $($script:DadosSistema.RAM)
BIOS: $($script:DadosSistema.BIOS)
Placa Mae: $($script:DadosSistema.PlacaMae)

SERVICOS REALIZADOS
$($script:Servicos -join "`r`n")

PROCEDIMENTOS EXECUTADOS
$($script:Procedimentos -join "`r`n")

LOCAL DO SERVICO
$script:LocalServico

VALOR
R$ $script:Valor

FORMA DE PAGAMENTO
$script:Pagamento

OBSERVACOES
$script:Observacoes

TECNICO RESPONSAVEL
Jaime Junior

========================================

TECH INFO BELEM

========================================

"@

    $Texto | Out-File -FilePath $ArquivoTXT -Encoding UTF8

    Write-Host ""
    Write-Host "RELATORIO GERADO COM SUCESSO!" -ForegroundColor Green
    Write-Host ""
    Write-Host "HTML:" -ForegroundColor Cyan
    Write-Host $ArquivoHTML
    Write-Host ""
    Write-Host "TXT:" -ForegroundColor Cyan
    Write-Host $ArquivoTXT

    Write-Host ""
    Write-Host "Abrindo relatorio..." -ForegroundColor Yellow

    Start-Process $ArquivoHTML

    Pausar
}

# ============================================================
# MENU PRINCIPAL
# ============================================================

while ($true) {

    Mostrar-Cabecalho

    Write-Host "[1] Limpar arquivos temporarios" -ForegroundColor Green
    Write-Host "[2] Limpar cache dos navegadores" -ForegroundColor Green
    Write-Host "[3] Esvaziar lixeira" -ForegroundColor Green
    Write-Host "[4] Limpeza completa" -ForegroundColor Green

    Write-Host ""
    Write-Host "[5] Executar SFC" -ForegroundColor Green
    Write-Host "[6] Executar DISM" -ForegroundColor Green

    Write-Host ""
    Write-Host "[7] Coletar informacoes do sistema" -ForegroundColor Green
    Write-Host "[8] Verificar saude SSD / HD" -ForegroundColor Green
    Write-Host "[9] Mostrar informacoes de rede" -ForegroundColor Green
    Write-Host "[10] Mostrar senha Wi-Fi" -ForegroundColor Green

    Write-Host ""
    Write-Host "[11] Remover aplicativos Xbox" -ForegroundColor Green
    Write-Host "[12] Abrir Windows Utility - Chris Titus" -ForegroundColor Green

    Write-Host ""
    Write-Host "[13] Criar relatorio de servico" -ForegroundColor Green
    Write-Host "[14] Gerar relatorio" -ForegroundColor Green

    Write-Host ""
    Write-Host "[0] Sair" -ForegroundColor Red

    Write-Host ""

    $Opcao = Read-Host "Digite a opcao desejada"

    switch ($Opcao) {

        "1" {
            Limpar-Temporarios
        }

        "2" {
            Limpar-Navegadores
        }

        "3" {
            Limpar-Lixeira
        }

        "4" {

            Limpar-Temporarios
            Limpar-Navegadores
            Limpar-Lixeira

            Mostrar-Cabecalho

            Write-Host ">>> LIMPEZA COMPLETA FINALIZADA!" -ForegroundColor Green

            Pausar
        }

        "5" {
            Executar-SFC
        }

        "6" {
            Executar-DISM
        }

        "7" {
            Coletar-InformacoesSistema
        }

        "8" {
            Verificar-SaudeDisco
        }

        "9" {
            Mostrar-InformacoesRede
        }

        "10" {
            Mostrar-SenhaWiFi
        }

        "11" {
            Remover-Xbox
        }

        "12" {
            Abrir-ChrisTitus
        }

        "13" {
            Selecionar-Servicos
        }

        "14" {
            Gerar-Relatorio
        }

        "0" {
            Clear-Host
            exit
        }

        default {

            Write-Host ""
            Write-Host "Opcao invalida!" -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
}
