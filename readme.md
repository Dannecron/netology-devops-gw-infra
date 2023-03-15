## Дипломная работа

Репозиторий содержит конфигурацию terraform для поднятия инфраструктуры для выполнения [дипломной работы](https://github.com/Dannecron/netology-devops/blob/main/src/graduate_work/readme.md).

## Использование

### Инициализация конфигурации terraform

```shell
ansible-playbook --ask-vault-pass -i ansible/terraform_init terraform_init.yml
```

После этого возможно использование команд `terraform` из директории [terraform](/terraform).
