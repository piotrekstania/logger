iqver=`curl -Gs "http://localhost:9000/exec" --data-urlencode "query=SELECT build()" | jq '.dataset[0][0]' | cut --delimiter=' ' --fields=4 | cut --delimiter=',' --fields=1`
echo "Zainstalowana wersja: ${iqver}"

qver=`git -c 'versionsort.suffix=-' ls-remote --tags --refs https://github.com/questdb/questdb.git | tail -n 1 | cut --delimiter='/' --fields=3`
echo "Najnowsza wersja    : ${qver}"


if [ "$iqver" = "$qver" ]; then
    echo "Brak nowej wersji"
else
    echo "Czy chcesz zaktualizować (y/n)?"
    read -n1 -s yesorno

    if [ "$yesorno" = y ]; then
        wget https://github.com/questdb/questdb/releases/download/${qver}/questdb-${qver}-no-jre-bin.tar.gz
        tar -xvzf questdb-${qver}-no-jre-bin.tar.gz
        rm questdb-${qver}-no-jre-bin.tar.gz
        /home/ouija/questdb/questdb.sh stop
        rm -rf questdb
        mv questdb-8.3.1-no-jre-bin questdb
        /home/ouija/questdb/questdb.sh start
    fi
fi
