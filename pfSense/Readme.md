# Modulo de PfSense para Terraform
Esse modulo visa a criação de VPN usando Pfsense com Terraform

### Subindo a instancia do Pfsense
No seu terminal digite os seguintes comandos nessa ordem
- Terraform init
- Terraform plan
- Terraform apply

## Configuração do PfSense
Para configuração do Pfsense criamos o manual abaixo visando facilitar sua aplicação, configuração e utilização


### Capturando Usuario e senha do PfSense
Como primeiro passo é necessario verificarmos o usuario e senha criados para o primeiro do pfSense, siga o gif abaixo para coleta:

![](./resources/gifs/Pegando_usuario_senha_da_instancia)


### Primeiro acesso
Para fazer o primeiro acesso a instancia o PfSese siga os passos abaixo:

![](./resources/gifs/Primeiro_acesso_pfsense.gif)

### Ativando Aceleração de Hardware
Apos o primeiro acesso é necessario ativar a aceleração de hardware para otimizar a rede

![](./resources/gifs/Ativando_Aceleração_de_hardware.gif)

### Instalando o Pacote de Exportação de Cliente
Para inicio das configurações do PfSense é necessario a instalação do pacote de exportação

![](./resources/gifs/Instalando_pacote_de_exportação_de_cliente_openvpn.gif)

### Configurando OpenVpn no PfSense
Siga os passos abaixo para inicio das configurações da OpenVpn no Pfsense

![](./resources/gifs/Configurando_OPENVPN_no_PFSENSE.gif)

### Criando Usuario no PfSense para Acesso a OpenVpn
Siga os passos abaixo para criação de usuarios

![](./resources/gifs/Criando_usuario_no_pfsense_para_acesso_openvpn.gif)

### Exportando Arquivo de Configuração
Após criação do usuario é necessario exportar os aqruivos para conexão da VPN

![](./resources/gifs/Exp _arquivos_config_de_instalação_do_openvpn_para_os_usuarios.gif)

### Rebootando o PfSense
È necessario o primeiro reboot após as configurações para observação da reestruturação correta do ambiente

![](./resources/gifs/Exp Rebootando_pfsense.gif)



