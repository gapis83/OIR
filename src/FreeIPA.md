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

Настройка DNS сервера bind выполнена согласно [ссылке](https://redos.red-soft.ru/base/server-configuring/customize-dns/customize-dns-bind/).

Для того чтобы сервер принимал трафик по протоколам tcp и udp надо добавить правило в начало цепочки INPUT (это означает, что правило будет проверяться перед другими правилами в цепочке - импользуется флаг -I):
```bash
sudo iptables -I INPUT -p tcp --dport 53 -j ACCEPT
sudo iptables -I INPUT -p udp --dport 53 -j ACCEPT

```

Изменить файл /etc/hosts (добавить адрес сервера):
```bash
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.10.2 serv.red.in
```

### 2. Настройка NTP сервера

#### Установка Chrony
```bash
sudo yum install chrony
```

#### Конфигурация NTP
Отредактировать файл конфигурации `/etc/chrony.conf`:
```bash
sudo nano /etc/chrony.conf
```
Добавить или изменить строки для указания NTP серверов:
```bash
server 0.centos.pool.ntp.org iburst
server 1.centos.pool.ntp.org iburst
server 2.centos.pool.ntp.org iburst
server 3.centos.pool.ntp.org iburst
```
Добавить строку, чтобы позволить другим компьютерам из сети синхронизироваться с этим сервером:
```bash
allow 192.168.10.0/24
```

#### Запуск и настройка автозапуска NTP сервера
```bash
sudo systemctl start chronyd
sudo systemctl enable chronyd
```

#### Настройка брандмауэра
Открыть для доступа порт 123 (UDP) и сохранить правило, чтобы оно продолжало действовать после перезагрузки системы:
```bash
sudo iptables -A INPUT -p udp --dport 123 -j ACCEPT
sudo service iptables save
```
Чтобы была возможность сохранения правил iptables после перезагрузки системы надо установить:
```bash
sudo yum install iptables-services
```

#### Интеграция с FreeIPA
Если сервер также является сервером FreeIPA, синхронизация времени важна для работы Kerberos и других служб FreeIPA.

Надо открыть **/etc/chrony.conf** на клиентах FreeIPA и настроить их для синхронизации с NTP-сервером.

#### Проверка синхронизации
Проверить, синхронизируются ли клиенты и сервер:

На сервере:

```bash
chronyc sources
```

На клиенте:

```bash
chronyc tracking
```

### 3. Создание клиентской машины с ОС RedOS и добавление её в домен FreeIPA

#### Установка необходимых пакетов на клиентской машине
```bash
sudo yum install -y freeipa-client
```

#### Настройка клиента
Настройка выполняется согласно [инструкции](https://redos.red-soft.ru/base/arm/arm-domen/redos-in-ipa/) ("Ручная установка IPA клиента и ввод в домен").

```bash
dnf install ipa-client
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