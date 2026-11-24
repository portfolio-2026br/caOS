# caOS

Estas são minhas versões personalizadas da imagem “Universal Blue”, com alguns ajustes para tornar o sistema mais seguro
e personalizado.

## Situação Atual

As images OCI produzidas por este repositório são listadas em:
<https://github.com/portfolio-2026br/caOS/pkgs/container/caos>.

O "novo" sistema operacional funciona adequadamente:

![Sistema Funcionando](images/Info.png)

### Notas e Problemas Encontrados

- Plymouth (boot gráfico com imagens e "animação") não funciona. Encontrei outras pessoas apontando o mesmo problema.
- Não consigo instalar o Little Snitch durante o build, mas a instalação posterior funciona normalmente.

Para migrar para meu OS:

- Use `sudo bootc switch ghcr.io/portfolio-2026br/caos`

Situação do OS:

- Use `rpm-ostree status`;
- Ou `sudo bootc status`.

#### Checagem e Atualização do OS

Para apenas verificar se há atualizações use a opção `--check`. Há muita semelhança entre os comandos `rpm-ostree` e
`bootc`.

- O comando `rpm-ostree upgrade [--check]` funciona;
- O `sudo bootc upgrade [--check]` funciona mas é frágil: não podem existir pacotes layered.

Próximos Passos:

- Refazer o processo de hardening e verificar o que pode ser aplicado à criação da imagem.
- Copiar hardening de alguma distro focada nisto.
- Dúvidas:
  - Ocorre alguma notificação automática que há uma versão nova do OS que eu posso instalar?
    - Nem no Silverblue acontece. Então, a resposta é não.
