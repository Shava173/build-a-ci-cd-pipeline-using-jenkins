#!/bin/bash

# Видалити старі каталоги, якщо вони існують
rm -rf tempdir

# Крок 1: Створіть тимчасові каталоги для зберігання файлів веб-сайту
mkdir -p tempdir/templates
mkdir -p tempdir/static

# Крок 2: Скопіюйте каталоги веб-сайту та sample_app.py у тимчасовий каталог
cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

# Перевірка дозволів та встановлення дозволів, якщо необхідно
chmod -R 755 tempdir

# Крок 3: Виконайте збірку Dockerfile
echo "FROM python" > tempdir/Dockerfile
echo "RUN pip install flask" >> tempdir/Dockerfile
echo "COPY ./static /home/myapp/static/" >> tempdir/Dockerfile
echo "COPY ./templates /home/myapp/templates/" >> tempdir/Dockerfile
echo "COPY sample_app.py /home/myapp/" >> tempdir/Dockerfile
echo "EXPOSE 8080" >> tempdir/Dockerfile
echo "CMD python3 /home/myapp/sample_app.py" >> tempdir/Dockerfile

# Крок 4: Виконайте збірку контейнера Docker
cd tempdir
docker build -t sampleapp .

# Видалити старий контейнер, якщо він існує
docker rm -f samplerunning || true

# Крок 5: Запустіть контейнер і перевірте, чи він запущений
docker run -t -d -p 8080:8080 --name samplerunning sampleapp
docker ps -a
