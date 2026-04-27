# YaTube

[![CI](https://github.com/nnexejen/YaTube/actions/workflows/ci.yml/badge.svg)](https://github.com/nnexejen/YaTube/actions/workflows/ci.yml) 
[![codecov](https://codecov.io/gh/nnexejen/YaTube/branch/master/graph/badge.svg)](https://codecov.io/gh/nnexejen/YaTube) 
[![Code style: flake8](https://img.shields.io/badge/code%20style-flake8-orange.svg)](https://flake8.pycqa.org/) 
[![Python 3.9](https://img.shields.io/badge/python-3.9-blue.svg)](https://www.python.org/downloads/)  
- [Введение](#введение)
- [Функционал проекта](#функционал-проекта)
- [Используемые технологии](#используемые-технологии)
- [CI/CD и безопасность](#ci-cd-и-безопасность)
- [Переменные окружения](#переменные-окружения)
- [Запуск приложения](#запуск-приложения)

## Введение
Проект YaTube представляет из себя упрощенную социальную сеть, инструмент для начинающих блогеров. 

## Функционал проекта
- Расширенная регистрация пользователей.
- Публикация постов с возможностью добавления изображений.
- Размещение постов в группах.
- Создание групп (только для привилегированных пользователей).
- Комментарии к постам других авторов.
- Подписка на авторов.
- Фильтр постов по группе.

## Используемые технологии
При создании, тестировании и разворачивании приложения использовались следующие технологии:
### Backend & Core:
- `Python 3.9`
- `Django 2.2.16`
- `Gunicorn` (WSGI сервер)
- `PostgreSQL` (База данных)
### Infrastructure & DevOps:
- `Docker` & `Docker Compose` (Контейнеризация)
- `Minikube` & `Helm` (Оркестрация и деплой)
- `GitHub Actions` (CI/CD)
- `Trivy` (Сканер уязвимостей)
- `Codecov` (Метрики качества кода)
### Testing & Quality:
- `pytest`, `pytest-django`
- `flake8` (Линтер)
- `Faker`, `mixer` (Генерация тестовых данных)

## CI/CD и безопасность

Проект использует **GitHub Actions** для полной автоматизации проверки кода, сборки образов и контроля безопасности.  

### Пайплайн (Workflow)

Файл конфигурации: `.github/workflows/ci.yml`  
При каждом `push` или `pull request` запускается следующая цепочка задач:
1. **lint** (`flake8`) - проверка стиля кода (PEP8). Исключает миграции и автогенерируемые файлы.     
2. **test** (`pytest`) - запуск автотестов с подключением к PostgreSQL.  
3. **docker-build** (`Docker`) - сборка оптимизированного Multi-stage образа. 
4. **coverage** (`Codecov`) - генерация отчета о покрытии кода тестами.  
5. **security** (`Trivy`) - сканирование образа на уязвимости (CVE). Блокирует релиз при критических ошибках.  


### Локальная проверка пайплайна

Для отладки CI-конфига без отправки кода на GitHub используйте утилиту [`act`](https://github.com/nektos/act) — эмулятор GitHub Actions на базе Docker.

#### Требования
- Установленный Docker
- Утилита `act` ([инструкция по установке](https://nektosact.com/installation/))

#### Запуск тестов локально

Быстрый запуск через скрипт:
```
./run-act.sh
```
Или вручную с параметрами:
```
act -j test \
  -P ubuntu-latest=catthehacker/ubuntu:act-latest \
  -s DB_NAME=yatube \
  -s POSTGRES_PASSWORD=postgres \
  -s SECRET_KEY=test123 \
  -s DB_HOST=localhost \
  -s POSTGRES_USER=postgres \
  -s DB_PORT=5432 \
  -s DEBUG=false
```
## Переменные окружения
В директории infra репозитория находятся файлы ```all.env``` и ```web.env```, содержащие следующие переменные окружения:\
```DEBUG``` будет ли включен режим отладки (небезопасно)\
```SECRET_KEY``` секретный ключ, при помощи которого будут генерироваться CSRF-токены\
```DB_NAME=postgres``` имя базы данных\
```POSTGRES_USER=postgres``` логин для подключения к базе данных\
```POSTGRES_PASSWORD=postgres``` пароль для подключения к БД (установите свой)\
```DB_HOST=db``` название сервиса (контейнера)\
```DB_PORT=5432``` порт для подключения к БД\
При необходимости измените значения.

## Запуск приложения
1. Запустите ```minikube``` и ```helm```, создайте namespace для релиза.
2. В отдельной вкладке консоли запустите и не закрывайте
```
minikube tunnel --bind-address 0.0.0.0
```
3. Сгенерируйте сертификаты и поместите их в ```infra/yatube-charts/ssl```
4. Перейдите в директорию ```infra/yatube-charts``` и выполните
```
helm install yatube-release .
```

5. Сайт по умолчанию доступен по имени https://yatube.local (или по имени, которое вы назначили в ```values.yaml (.Values.ingress)```). 
5.1. Если вы используете ```minikube```, имя сайта должно быть записано в файле ```hosts```.
6. Учётная запись суперпользователя создаётся автоматически, параметры входа можно изменить в ```values.yaml (.Values.superuser)```.

