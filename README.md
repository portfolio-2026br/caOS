# caOS

Esta é minha distro Linux de uso pessoal baseada no **Universal Blue**. Ao usar _hardening_ e configurações _default_
auditadas é possível criar um sistema mais limpo, seguro e personalizado.

Neste momento, a distro é baseada no Fedora Silverblue, mas seria interessante no futuro baseá-la no
[Fedora Hummingbird](https://fedoramagazine.org/fedora-hummingbird-linux-taking-the-hummingbird-model-to-the-full-os/).

Como o projeto [ublue-os/image-template](https://github.com/ublue-os/image-template) não suporta uma política rigorosa
de assinatura de _bootc_ (strict bootc signature policy), eu migrei o _build_ para o projeto **BlueBuild**.

## Situação Atual

As images OCI produzidas por este repositório são listadas em:
<https://github.com/portfolio-2026br/caOS/pkgs/container/caos>.

O "novo" sistema operacional funciona adequadamente:

<div id="Tela do OS" align="center">

![Sistema Funcionando](images/Info.png)

</div>

### Notas e Problemas Encontrados

- Não consigo instalar o Little Snitch durante o build, mas a instalação posterior funciona normalmente.

## Para migrar para meu OS

A partir de uma máquina com uma versão atômica do Fedora instalada:

- Primeiro, faça o _rebase_ para a imagem não assinada, a fim de instalar as chaves de assinatura e as políticas
  corretas:

  ```shell
  sudo bootc switch ghcr.io/portfolio-2026br/caos
  ```

- Reinicie o computador para realizar o _rebase_:

  ```shell
  systemctl reboot
  ```

- Faça _rebase_ para a imagem assinada:

  ```shell
  sudo bootc switch --enforce-container-sigpolicy ghcr.io/portfolio-2026br/caos
  ```

- Reinicie novamente o computador para concluir a instalação:

  ```shell
  systemctl reboot
  ```

### Atualização do OS

Note que há muita semelhança entre os comandos `rpm-ostree` e `bootc`:

- O comando `rpm-ostree upgrade [--check]` funciona;
- O `sudo bootc upgrade [--check]` funciona mas é frágil: não podem existir pacotes layered.

## Verificação

As imagens são assinadas com o Sigstore `cosign`. Você pode verificar a assinatura baixando o arquivo `cosign.pub` deste
repositório e executando o seguinte comando:

```shell
cosign verify --key cosign.pub ghcr.io/portfolio-2026br/caos
```

## Próximos Passos

- Copiar hardening da distro `secureblue`;
- Dúvidas:
  - Ocorre alguma notificação automática que há uma versão nova do OS que eu posso instalar?
    - Nem no Silverblue acontece. Então, a resposta é não;
    - Execute uma checagem manual usando `sudo bootc upgrade --check`.
