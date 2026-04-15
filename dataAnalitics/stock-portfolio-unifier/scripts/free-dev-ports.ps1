# Libera puertos de desarrollo (LISTEN) y cierra ventanas cmd dejadas por start.bat.
# Uso: .\scripts\free-dev-ports.ps1
#      .\scripts\free-dev-ports.ps1 -Ports 8000,5173,4173

param(
    [int[]] $Ports = @(8000, 5173, 4173)
)

$ErrorActionPreference = 'SilentlyContinue'

foreach ($port in $Ports) {
    $conns = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
    if (-not $conns) { continue }
    $pids = $conns | Select-Object -ExpandProperty OwningProcess -Unique | Where-Object { $_ -gt 0 }
    foreach ($procId in $pids) {
        try {
            $p = Get-Process -Id $procId -ErrorAction SilentlyContinue
            if ($p) {
                Write-Host "[free-ports] Port $port -> stop PID $procId ($($p.ProcessName))"
                Stop-Process -Id $procId -Force -ErrorAction Stop
            }
        }
        catch {
            Write-Host "[free-ports] Port $port -> could not stop PID $procId : $_"
        }
    }
}

# Consolas previas con el mismo titulo que start.bat (cmd con ventana visible)
$titles = @('Backend - FastAPI', 'Frontend - Vue')
Get-Process -Name 'cmd' -ErrorAction SilentlyContinue | Where-Object {
    $titles -contains $_.MainWindowTitle
} | ForEach-Object {
    Write-Host "[free-ports] Close cmd window '$($_.MainWindowTitle)' (PID $($_.Id))"
    Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
}

Write-Host "[free-ports] Done."
exit 0
