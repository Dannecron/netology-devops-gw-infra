## Дипломная работа

Репозиторий содержит конфигурацию terraform для поднятия инфраструктуры для выполнения [дипломной работы](https://github.com/Dannecron/netology-devops/blob/main/src/graduate_work/readme.md).

## Использование

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

__NOTES__:
* на данном этапе необходимо, чтобы инфрастуктура уже была задеплоена через `terraform`.

### Запуск kubespray: установка кластера kubernetes

* [ansible playbook `vendor/kubespray/cluster.yml`](/vendor/kubespray/cluster.yml) (будет создан на этапе конфигурации kubespray)
* [ansible inventory](/ansible/kubespray) (сам файл `inventory.ini` будет создан на этапе конфигурации kubespray)

Запуск:

```shell
ansible-playbook -i ansible/kubespray/inventory.ini vendor/kubespray/cluster.yml
```
