# Hardening

Em desenvolvimento e testes.

# ── Arquivos adicionados ────────────────────────

```txt
/etc/modprobe.d/50-hardening-blacklist.conf             # Bloqueii alguns files systems
/etc/NetworkManager/conf.d/50-mac-randomization.conf    # Randomização de mac no Wifi
/etc/sysctl.d/99-hardening.conf                         # Hardening no OS
/etc/systemd/resolved.conf.d/50-dot.conf                # DoT, DNSSEC obrigatório
```

# ── Arquivos alterados ──────────────────────────

```txt
/etc/chrony.conf                                # usei servidores NTP autenticados
/etc/dnf/dnf.conf                               # Forçar gpgcheck
/etc/security/faillock.conf                     # Configuração para falha de login
/etc/sudoers                                    # Adicionei "Defaults requiretty"
```

## Tarefas Pós Instalação

- Após o primeiro boot, executar o ModuleJail[^1].

[^1]: Este é meu arquivo whitelist.conf usado para configuração no modulejail.

```txt
# VPN em uso
wireguard

# Carregado pelo meu processador AMD
amd64_edac

# Logs no nftables
nf_log_syslog
nft_log
```
