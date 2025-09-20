<div align="center">
  <div>
    <img height = "150" width = "150" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/terraform/terraform-original-wordmark.svg" />
  </div>
</div>


<p style="text-align: justify;">Este projeto utiliza Terraform para provisionar uma infraestrutura no Azure, incluindo um Grupo de Recursos, um Cluster AKS (Azure Kubernetes Service) e um Registro de Contêineres (ACR - Azure Container Registry).</p>

<p style="text-align: justify;">Estrutura do Projeto</p>

<ul>
  <li style="text-align: justify;"><b>main.tf</b>: Contém a definição dos recursos Azure, incluindo AKS, ACR e Grupo de Recursos.</li>
  <li style="text-align: justify;"><b>variables.tf</b>: Define as variáveis usadas no projeto.</li>
  <li style="text-align: justify;"><b>terraform.tfvars</b>: Fornece os valores específicos para as variáveis, personalizados para este deployment.</li>
</ul>

<p style="text-align: justify;">Requisitos</p>

<ul>
  <li style="text-align: justify;">Conta Azure com permissões adequadas para criação de recursos.</li>
  <li style="text-align: justify;">Terraform versão 1.0 ou superior.</li>
  <li style="text-align: justify;">Azure CLI configurado para autenticação.</li>
</ul>

<p style="text-align: justify;">Configuração dos Recursos</p>

<ol>
    <li style="text-align: justify;">main.tf</li>
    <p style="text-align: justify;">Este arquivo configura os recursos principais:</p>
    <ul>
        <li style="text-align: justify;">Provider Azure: Configura o provedor Azure.</li>
        <li style="text-align: justify;">Grupo de Recursos (azurerm_resource_group): Criado com o nome e localização definidos nas variáveis rg-name e rg-location.</li>
        <li style="text-align: justify;">Cluster AKS (azurerm_kubernetes_cluster): Configurado com:</li>
        <ul>
            <li style="text-align: justify;">Nome do cluster (aks-name)</li>
            <li style="text-align: justify;">Versão do Kubernetes (aks-kubernetes_version)</li>
            <li style="text-align: justify;">Prefixo DNS (aks-dns_prefix)</li>
            <li style="text-align: justify;">Pool de nós padrão com o nome, contagem de nós e tipo de VM definidos pelas variáveis aks-pool-name, aks-pool-node_count e aks-pool-vm_size</li>
            <li style="text-align: justify;">Identidade SystemAssigned para integração com ACR.</li>
        </ul>
        <li style="text-align: justify;">Azure Container Registry (ACR) (azurerm_container_registry): Configurado com o nome (acr-name), SKU (acr-sku) e localização.</li>
        <li style="text-align: justify;">Role Assignment para o ACR (azurerm_role_assignment): Concede ao AKS permissão para acessar o ACR usando a função AcrPull.</li>
    </ul>
    <li style="text-align: justify;">variables.tf</li>
    <p style="text-align: justify;">Define as variáveis necessárias para a configuração:</p>
    <ul>
        <li style="text-align: justify;">Grupo de Recursos</li>
        <ul>
            <li style="text-align: justify;">rg-name: Nome do Grupo de Recursos.</li>
            <li style="text-align: justify;">rg-location: Localização do Grupo de Recursos.</li>
        </ul>
        <li style="text-align: justify;">AKS</li>
        <ul>
            <li style="text-align: justify;">aks-name: Nome do Cluster AKS.</li>
            <li style="text-align: justify;">aks-dns_prefix: Prefixo DNS do Cluster.</li>
            <li style="text-align: justify;">aks-kubernetes_version: Versão do Kubernetes.</li>
            <li style="text-align: justify;">aks-pool-name: Nome do Pool de Nós.</li>
            <li style="text-align: justify;">aks-pool-node_count: Número de nós no Pool.</li>
            <li style="text-align: justify;">aks-pool-vm_size: Tipo de VM para os nós.</li>
        </ul>
    </ul>
    <li style="text-align: justify;">terraform.tfvars</li>
    <p style="text-align: justify;">Este arquivo configura os recursos principais:</p>

```bash
    # Grupo de Recurso
    rg-name     = ""
    rg-location = ""

    # AKS
    aks-name               = ""
    aks-dns_prefix         = ""
    aks-pool-name          = ""
    aks-pool-vm_size       = ""

    # ACR
    acr-name                 = ""
    acr-sku                  = ""
    acr-role_definition_name = ""

```
</ol>

<p style="text-align: justify;">Passos para Utilização</p>

<ol>
<li style="text-align: justify;">Limpe as informações de conta armazenadas localmente pelo Azure CLI</li>

```bash
az account clear
```

<li style="text-align: justify;">Realize o login via CLI</li>

```bash
az login
```

<li style="text-align: justify;">Utilize o comando a baixo para saber o subscription-id da conta utilizada.</li>

```bash
az account list --output table
```

<li style="text-align: justify;">Nesse caso iremos usar a ultima credencial, pegue o SubscriptionId e coloque no comando a seguir.</li>

```bash
az account set --subscription "your-subscription-id"
```

<li style="text-align: justify;">Execute o comando  para mostrar todas as regiões disponíveis no Azure para a sua conta:</li>

```bash
az account list-locations --output table
```

<li style="text-align: justify;">Execute o comando mostra as versões do Kubernetes disponíveis para criar ou atualizar um cluster AKS na região especificada</li>

```bash
az aks get-versions --location regiaoEscolhida --output table
```

<li style="text-align: justify;">Inicialize o Terraform:</li>

```bash
terraform init
```

<li style="text-align: justify;">Valide a configuração:</li>

```bash
terraform validate
```

<li style="text-align: justify;">Valide a configuração:</li>

```bash
terraform plan
```

<li style="text-align: justify;">Aplique o plano para criar os recursos:</li>

```bash
terraform apply
```
</ol>

<p style="text-align: justify;">Observações</p>

<ul>
  <li style="text-align: justify;">Permissões: Assegure que a conta usada tenha permissão para criar clusters AKS e ACR.</li>
</ul>