Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

# ============================================================
# TECH INFO BELEM - CLEANER PRO
# Versao 0.1
# ============================================================

# ------------------------------------------------------------
# VERIFICAR ADMINISTRADOR
# ------------------------------------------------------------

function Test-Administrator {

    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)

    return $principal.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
}

# ------------------------------------------------------------
# AVISO CASO NAO ESTEJA COMO ADMINISTRADOR
# ------------------------------------------------------------

if (-not (Test-Administrator)) {

    $resposta = [System.Windows.MessageBox]::Show(
        "O Cleaner Pro esta sendo executado sem permissao de Administrador.`n`nAlgumas funcoes podem nao funcionar corretamente.`n`nRecomendamos abrir o PowerShell como Administrador.",
        "TECH INFO BELEM - Cleaner Pro",
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
    Title="TECH INFO BELEM - Cleaner Pro"
    Height="650"
    Width="1050"
    WindowStartupLocation="CenterScreen"
    Background="#111827">

    <Grid>

        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="230"/>
            <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>

        <!-- ================================================= -->
        <!-- MENU LATERAL -->
        <!-- ================================================= -->

        <Border
            Grid.Column="0"
            Background="#0B1220">

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
                    Margin="25,0,10,35"/>

                <Button
                    Name="btnInicio"
                    Content="INICIO"
                    Height="45"
                    Margin="15,5"
                    Background="#1D4ED8"
                    Foreground="White"/>

                <Button
                    Name="btnTemporarios"
                    Content="LIMPAR TEMPORARIOS"
                    Height="45"
                    Margin="15,5"
                    Background="#1F2937"
                    Foreground="White"/>

                <Button
                    Name="btnNavegadores"
                    Content="LIMPAR NAVEGADORES"
                    Height="45"
                    Margin="15,5"
                    Background="#1F2937"
                    Foreground="White"/>

                <Button
                    Name="btnLixeira"
                    Content="ESVAZIAR LIXEIRA"
                    Height="45"
                    Margin="15,5"
                    Background="#1F2937"
                    Foreground="White"/>

                <Button
                    Name="btnCompleta"
                    Content="LIMPEZA COMPLETA"
                    Height="45"
                    Margin="15,5"
                    Background="#991B1B"
                    Foreground="White"/>

                <Button
                    Name="btnChrisTitus"
                    Content="WINUTIL - CHRIS TITUS"
                    Height="45"
                    Margin="15,5"
                    Background="#7C3AED"
                    Foreground="White"/>

                <Button
                    Name="btnSair"
                    Content="SAIR"
                    Height="45"
                    Margin="15,30,15,5"
                    Background="#374151"
                    Foreground="White"/>

            </StackPanel>

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
                Text="Ferramenta profissional de limpeza e manutencao"
                Foreground="#9CA3AF"
                FontSize="15"
                Margin="0,5,0,25"/>


            <!-- ================================================= -->
            <!-- CARDS -->
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


                    <!-- COMPUTADOR -->

                    <Border
                        Background="#1F2937"
                        CornerRadius="10"
                        Padding="20"
                        Margin="0,0,0,15">

                        <StackPanel>

                            <TextBlock
                                Text="COMPUTADOR"
                                Foreground="#60A5FA"
                                FontSize="14"/>

                            <TextBlock
                                Name="txtComputador"
                                Foreground="White"
                                FontSize="20"
                                FontWeight="Bold"
                                Margin="0,8,0,0"/>

                        </StackPanel>

                    </Border>


                    <!-- WINDOWS -->

                    <Border
                        Background="#1F2937"
                        CornerRadius="10"
                        Padding="20"
                        Margin="0,0,0,15">

                        <StackPanel>

                            <TextBlock
                                Text="SISTEMA OPERACIONAL"
                                Foreground="#60A5FA"
                                FontSize="14"/>

                            <TextBlock
                                Name="txtWindows"
                                Foreground="White"
                                FontSize="20"
                                FontWeight="Bold"
                                Margin="0,8,0,0"
                                TextWrapping="Wrap"/>

                        </StackPanel>

                    </Border>


                    <!-- RAM -->

                    <Border
                        Background="#1F2937"
                        CornerRadius="10"
                        Padding="20">

                        <StackPanel>

                            <TextBlock
                                Text="MEMORIA RAM"
                                Foreground="#60A5FA"
                                FontSize="14"/>

                            <TextBlock
                                Name="txtRAM"
                                Foreground="White"
                                FontSize="20"
                                FontWeight="Bold"
                                Margin="0,8,0,0"/>

                        </StackPanel>

                    </Border>

                </StackPanel>


                <!-- COLUNA DIREITA -->

                <StackPanel
                    Grid.Column="1"
                    Margin="10,0,0,0">


                    <!-- PROCESSADOR -->

                    <Border
                        Background="#1F2937"
                        CornerRadius="10"
                        Padding="20"
                        Margin="0,0,0,15">

                        <StackPanel>

                            <TextBlock
                                Text="PROCESSADOR"
                                Foreground="#60A5FA"
                                FontSize="14"/>

                            <TextBlock
                                Name="txtCPU"
                                Foreground="White"
                                FontSize="20"
                                FontWeight="Bold"
                                Margin="0,8,0,0"
                                TextWrapping="Wrap"/>

                        </StackPanel>

                    </Border>


                    <!-- DISCO -->

                    <Border
                        Background="#1F2937"
                        CornerRadius="10"
                        Padding="20"
                        Margin="0,0,0,15">

                        <StackPanel>

                            <TextBlock
                                Text="DISCO PRINCIPAL"
                                Foreground="#60A5FA"
                                FontSize="14"/>

                            <TextBlock
                                Name="txtDisco"
                                Foreground="White"
                                FontSize="20"
                                FontWeight="Bold"
                                Margin="0,8,0,0"/>

                        </StackPanel>

                    </Border>


                    <!-- STATUS -->

                    <Border
                        Background="#1F2937"
                        CornerRadius="10"
                        Padding="20">

                        <StackPanel>

                            <TextBlock
                                Text="STATUS"
                                Foreground="#60A5FA"
                                FontSize="14"/>

                            <TextBlock
                                Name="txtStatus"
                                Text="Sistema pronto"
                                Foreground="#22C55E"
                                FontSize="20"
                                FontWeight="Bold"
                                Margin="0,8,0,0"
                                TextWrapping="Wrap"/>

                        </StackPanel>

                    </Border>

                </StackPanel>

            </Grid>


            <!-- ================================================= -->
            <!-- RODAPE -->
            <!-- ================================================= -->

            <TextBlock
                Name="txtRodape"
                Grid.Row="3"
                Text="TECH INFO BELEM - Cleaner Pro v0.1"
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
# PEGAR CONTROLES
# ============================================================

$btnInicio = $Window.FindName("btnInicio")

$btnTemporarios = $Window.FindName("btnTemporarios")

$btnNavegadores = $Window.FindName("btnNavegadores")

$btnLixeira = $Window.FindName("btnLixeira")

$btnCompleta = $Window.FindName("btnCompleta")

$btnChrisTitus = $Window.FindName("btnChrisTitus")

$btnSair = $Window.FindName("btnSair")


$txtComputador = $Window.FindName("txtComputador")

$txtWindows = $Window.FindName("txtWindows")

$txtRAM = $Window.FindName("txtRAM")

$txtCPU = $Window.FindName("txtCPU")

$txtDisco = $Window.FindName("txtDisco")

$txtStatus = $Window.FindName("txtStatus")

$txtTitulo = $Window.FindName("txtTitulo")

$txtSubtitulo = $Window.FindName("txtSubtitulo")


# ============================================================
# INFORMACOES DO COMPUTADOR
# ============================================================

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
        $computer.Manufacturer + " " + $computer.Model


    $txtWindows.Text =
        $os.Caption


    $txtRAM.Text =
        "$ramGB GB"


    $txtCPU.Text =
        $cpu.Name


    $txtDisco.Text =
        "$freeGB GB livres de $totalGB GB"

}
catch {

    $txtStatus.Text =
        "Nao foi possivel obter informacoes do sistema"

}


# ============================================================
# FUNCAO LIMPAR TEMPORARIOS
# ============================================================

function Limpar-Temporarios {

    $txtStatus.Text =
        "Limpando arquivos temporarios..."

    try {

        Get-ChildItem $env:TEMP `
            -Force `
            -ErrorAction SilentlyContinue |
        Remove-Item `
            -Recurse `
            -Force `
            -ErrorAction SilentlyContinue


        Get-ChildItem "$env:SystemRoot\Temp" `
            -Force `
            -ErrorAction SilentlyContinue |
        Remove-Item `
            -Recurse `
            -Force `
            -ErrorAction SilentlyContinue


        $txtStatus.Text =
            "Limpeza de temporarios concluida"


        [System.Windows.MessageBox]::Show(
            "A limpeza dos arquivos temporarios foi concluida.",
            "TECH INFO BELEM",
            "OK",
            "Information"
        )

    }
    catch {

        $txtStatus.Text =
            "Erro durante a limpeza dos temporarios"


        [System.Windows.MessageBox]::Show(
            "Ocorreu um erro durante a limpeza dos arquivos temporarios.",
            "TECH INFO BELEM",
            "OK",
            "Error"
        )

    }
}


# ============================================================
# FUNCAO LIMPAR LIXEIRA
# ============================================================

function Limpar-Lixeira {

    $txtStatus.Text =
        "Esvaziando lixeira..."


    try {

        Clear-RecycleBin `
            -Force `
            -ErrorAction SilentlyContinue


        $txtStatus.Text =
            "Lixeira processada com sucesso"


        [System.Windows.MessageBox]::Show(
            "A lixeira foi processada com sucesso.",
            "TECH INFO BELEM",
            "OK",
            "Information"
        )

    }
    catch {

        $txtStatus.Text =
            "Erro ao limpar lixeira"


        [System.Windows.MessageBox]::Show(
            "Nao foi possivel esvaziar a lixeira.",
            "TECH INFO BELEM",
            "OK",
            "Error"
        )

    }
}


# ============================================================
# FUNCAO WINUTIL - CHRIS TITUS
# ============================================================

function Abrir-ChrisTitus {

    $confirmacao = [System.Windows.MessageBox]::Show(
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
        "Ferramenta profissional de limpeza e manutencao"


    $txtStatus.Text =
        "Sistema pronto"

})


# ============================================================
# EVENTO - TEMPORARIOS
# ============================================================

$btnTemporarios.Add_Click({

    Limpar-Temporarios

})


# ============================================================
# EVENTO - LIXEIRA
# ============================================================

$btnLixeira.Add_Click({

    Limpar-Lixeira

})


# ============================================================
# EVENTO - NAVEGADORES
# ============================================================

$btnNavegadores.Add_Click({

    $txtTitulo.Text =
        "Limpeza de Navegadores"


    $txtSubtitulo.Text =
        "Limpeza de arquivos temporarios dos navegadores"


    $txtStatus.Text =
        "Funcao em desenvolvimento"


    [System.Windows.MessageBox]::Show(
        "A limpeza dos navegadores sera adicionada na proxima versao do Cleaner Pro.",
        "TECH INFO BELEM - Cleaner Pro",
        "OK",
        "Information"
    )

})


# ============================================================
# EVENTO - LIMPEZA COMPLETA
# ============================================================

$btnCompleta.Add_Click({

    $confirmacao = [System.Windows.MessageBox]::Show(
        "Deseja iniciar a limpeza completa?`n`nSerão processados:`n`n- Arquivos temporarios`n- Temporarios do Windows`n- Lixeira",
        "TECH INFO BELEM - Limpeza Completa",
        "YesNo",
        "Question"
    )


    if ($confirmacao -eq "Yes") {

        $txtStatus.Text =
            "Iniciando limpeza completa..."


        Limpar-Temporarios


        $txtStatus.Text =
            "Limpando lixeira..."


        Limpar-Lixeira


        $txtStatus.Text =
            "Limpeza completa concluida"


        [System.Windows.MessageBox]::Show(
            "A limpeza completa foi finalizada.",
            "TECH INFO BELEM - Cleaner Pro",
            "OK",
            "Information"
        )

    }

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

    $confirmacao = [System.Windows.MessageBox]::Show(
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
# ABRIR JANELA
# ============================================================

$Window.ShowDialog() | Out-Null
