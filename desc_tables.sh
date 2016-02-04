#!/bin/bash

IFS='
'

HOST=${1}
USER=${2}
DB=${3}

read -sp "Enter password: " pass
tty -s && echo
echo "Proccessing..."
PASSWORD=$pass

exec 1> >(cat > "./${DB}.md")

echo "# ${DB}"
for table in `MYSQL_PWD=${PASSWORD} mysql -h${HOST} -u${USER} -e "show tables;" -N ${DB}`
do
  echo "## ${table}"

  echo '### テーブル定義'
  echo 'カラム名 | 型 | キー | デフォルト値 | NULL | 照合順序 | その他'
  echo '--- | --- | --- | --- | --- | --- | ---'

  for line in `MYSQL_PWD=${PASSWORD} mysql -h${HOST} -u${USER} -e "show full fields from ${table}" -N ${DB}`
  do
    field=`echo ${line} | cut -f1`
    type=`echo ${line} | cut -f2`
    key=`echo ${line} | cut -f5`
    default=`echo ${line} | cut -f6`
    null=`echo ${line} | cut -f4`
    collation=`echo ${line} | cut -f3`
    extra=`echo ${line} | cut -f7`

    echo "${field} | ${type} | ${key} | ${default} | ${null} | ${collation} | ${extra}"
  done

  echo
done

exit 0
