Развернуть и настроить FreeIPA и NTP сервер на ОС RedOS, а также добавить клиентскую машину в домен и создать учетные записи, потребует выполнения ряда шагов. Вот подробная инструкция:

### 1. Установка и настройка FreeIPA на сервере с ОС RedOS

#### Установка необходимых пакетов
```bash
sudo yum install -y freeipa-server freeipa-server-dns bind-dyndb-ldap
```

#### Инициализация FreeIPA
```bash
sudo ipa-server-install --setup-dns
```
Следуйте инструкциям на экране, предоставляя необходимую информацию.

### 2. Настройка NTP сервера

#### Установка NTP
```bash
sudo yum install -y ntp
```

#### Конфигурация NTP
Отредактируйте файл конфигурации `/etc/ntp.conf`:
```bash
sudo nano /etc/ntp.conf
```
Добавьте или измените строки для указания ваших NTP серверов:
```plaintext
server 0.centos.pool.ntp.org iburst
server 1.centos.pool.ntp.org iburst
server 2.centos.pool.ntp.org iburst
server 3.centos.pool.ntp.org iburst
```

#### Запуск и настройка автозапуска NTP сервера
```bash
sudo systemctl start ntpd
sudo systemctl enable ntpd
```

### 3. Создание клиентской машины с ОС RedOS и добавление её в домен FreeIPA

#### Установка необходимых пакетов на клиентской машине
```bash
sudo yum install -y freeipa-client
```

#### Настройка клиента
```bash
sudo ipa-client-install
```
Следуйте инструкциям на экране, предоставляя необходимую информацию.

### 4. Создание доменных учетных записей и вход под ними

#### Создание учетных записей на сервере FreeIPA
```bash
sudo ipa user-add test1 --first=Test1 --last=User --password
sudo ipa user-add test2 --first=Test2 --last=User --password
```
Введите пароли для пользователей.

#### Вход на клиентской машине под учетными записями
На клиентской машине выполните выход из текущей сессии и войдите с учетной записью `test1` или `test2`.

### Дополнительные рекомендации

- Убедитесь, что сервер и клиентская машина синхронизированы по времени (это критически важно для работы Kerberos).
- При возникновении проблем с установкой или настройкой проверьте журналы `/var/log/ipaserver-install.log` и `/var/log/ipa-client-install.log`.
- Используйте команду `ipa` для управления FreeIPA сервером (например, для добавления пользователей, групп и т.д.).

Эти шаги помогут вам развернуть FreeIPA и настроить сервер и клиента для работы в домене.