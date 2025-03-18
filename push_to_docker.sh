#!/bin/bash
if ! docker login -u faiver90 -p Malahit##2014; then
    echo 'Не авторизовался'
    exit 1
fi

if ! docker build -t faiver90/cryptouch_dev:latest . ; then
    echo 'Не создал локальный образ'
    exit 1
fi
if ! docker push faiver90/cryptouch_dev:latest; then
    echo 'Не ушел в докерхаб'
    exit 1
fi