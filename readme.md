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

#### Приложение

[репозиторий](https://github.com/Dannecron/parcel-example-neko)

```shell
helm upgrade -i simple-app k8s/helm/simple-app
```

#### kube-prometheus-stack

[helm-чарт](https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack)

```shell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade -i monitoring prometheus-community/kube-prometheus-stack -f k8s/helm/kube-prometheus-stack/values.yml
```

#### Atlantis

[документация](https://www.runatlantis.io)

```shell
helm upgrade -i --set "config.github.user=<access_token>" --set "config.github.token=<token_secret>" --set "config.github.secret=<webhook_secret>" atlantis k8s/helm/atlantis
```

где `<access_token>`, `<token_secret>` - это данные персонального access-токена, созданного на github,
а `<webhook_secret>` - строка, которая должна совпадать в конфигурации webhook и atlantis.

#### Jenkins

[документация](https://www.jenkins.io/)

```shell
helm upgrade -i --set "docker.dockerHubUser=<dockerHubUser>" --set "docker.dockerHubPassword=<dockerHubPassword>" jenkins k8s/helm/jenkins
```

Необходимые плагины:
* [kubernetes](https://plugins.jenkins.io/kubernetes/)
* [generic webhook trigger](https://plugins.jenkins.io/generic-webhook-trigger/)

Необходимая конфигурация:
* Автоматически прописывать `known_hosts`
* Добавить секрет с названием `github-key` с именем пользователя и ssh-ключом к github
* Настроить облачную конфигурацию воркеров для kubernetes и убрать запуск воркеров на master-ноде
* Создать новый pipeline-проект для обработки push-эвентов по всем git-веткам со скриптом [jenkins/ref.jenkinsfile](./jenkins/ref.jenkinsfile).
* Создать новый pipeline-проект для обработки создания git-тэгов со скриптом [jenkins/tag.jenkinsfile](./jenkins/tag.jenkinsfile).
