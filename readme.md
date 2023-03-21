## Дипломная работа

Репозиторий содержит конфигурацию terraform для поднятия инфраструктуры для выполнения [дипломной работы](https://github.com/Dannecron/netology-devops/blob/main/src/graduate_work/readme.md).

## Использование

Необходимо последовательно выполнить все шаги, описанные ниже. Каждый ansible-playbook описывает один шаг.

### Инициализация конфигурации terraform

* [ansible playbook `terraform_init.yml`](/terraform_init.yml)
* [ansible inventory](/ansible/terraform_init)

Запуск:

```shell
ansible-playbook --ask-vault-pass -i ansible/terraform_init terraform_init.yml
```

После этого возможно использование команд `terraform` из директории [terraform](/terraform).

__NOTES__:
* время жизни токена ограничено, поэтому при истечении данного времени необходимо заново запустить данный playbook.

### Деплой инфраструктуры

Из директории [terraform](./terraform):

```shell
terraform plan
terraform apply
```

### Инициализация конфигурации kubespray

* [ansible playbook `kubespray_init.yml`](/kubespray_init.yml)
* [ansible inventory](/ansible/kubespray_init)

Запуск:

```shell
ansible-playbook -i ansible/kubespray_init kubespray_init.yml
```

### Запуск kubespray: установка кластера kubernetes

* [ansible playbook `vendor/kubespray/cluster.yml`](/vendor/kubespray/cluster.yml) (будет создан на этапе конфигурации kubespray)
* [ansible inventory](/ansible/kubespray) (сам файл `inventory.ini` будет создан на этапе конфигурации kubespray)

Запуск:

```shell
ansible-playbook -i ansible/kubespray/inventory.ini vendor/kubespray/cluster.yml
```

### Инициализация конфигурации kubectl

* [ansible playbook `kubectl_init.yml`](/kubectl_init.yml)
* [ansible inventory](/ansible/kubectl_init) (сам файл `inventory` будет создан на этапе конфигурации kubespray)

Запуск:

```shell
ansible-playbook -i ansible/kubectl_init kubectl_init.yml
```

### Деплой сервисов

* [kube-prometheus-stack](https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack)

    ```shell
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm install monitoring prometheus-community/kube-prometheus-stack -f k8s/helm/kube-prometheus-stack/values.yml
    ```
* [приложение](https://github.com/Dannecron/parcel-example-neko)

    ```shell
    helm install simple-app k8s/helm/simple-app
    ```
    или, если чарт уже задеплоен
    ```shell
    helm upgrade simple-app k8s/helm/simple-app
    ```
* [atlantis](https://www.runatlantis.io)
  // todo
