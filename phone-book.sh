#!/bin/sh

file="data.txt"	# База хранения телефонов 
# Цвет для красоты
RED="\e[31m"  	# Красный
GRN="\e[32m"	# Зелёный
E_COL="\e[0m"	# Конец цвета
YEL="\e[1;33m"	# Жёлтый
# проверяем существует-ли файл
[ -e "$file" ] || touch $file
echo "Добро пожаловать в телефонный справочник!"
echo "Укажите раздел меню или напишите help"
# --> Цикл программы <--
while [ "qq" != "$menu" ]
do
	echo -n "Укажите раздел: "
	read menu
# Структура меню
 case $menu in
	"list") 
		echo "Список : "
		# выводим список без разделителя
		awk -F ":" '{print $1,"-",$2}' $file | sort | nl
		;;	
	"new")  # Создание нового контакта 
		# проверка введены-ли параметры
		echo -n "Введите имя и фамилию: "
		read name
		# Выход из пункта меню
		if [[ "$name" == "qq" ]];then
			echo -e "$GRNВыходим из $E_COL[new]"
			continue
		fi
		echo -n "Введите телефон: "
		read phone

		if [[ -z "$name" ||  -z "$phone" ]];then
			# Я Малевич =) 
			echo -e "$REDВведите <$E_COL $GRNИмя$E_COL $RED> и <$E_COL $GRNТелефон$E_COL $RED>$E_COL"
		else
			# Ищем номер телефона и записываем строку в переменную
			# var=$(sed -n "/$phone/p" $file)
			var=$(awk -F: -v var2="$phone" '{if (var2==$2) print $1,"-",$2}' $file)
			
			# Если переменная пустая записываем новый КОНТАКТ или говорим что он существует
			if [ -z "$var" ];then
				echo $name":"$phone >> $file 
				var=$(awk -F: -v var2="$phone" '{if (var2==$2) print $1,"-",$2}' $file)
				echo -e "Новая запись: "$YEL$var$E_COL
			else
				echo "Номер телефона уже записан: " $phone
				echo -e $RED $var $E_COL
			fi
		fi
		;;
	"search")
		# Если строка не пуста то ищем по номеру или имени
		# Проверяем переменную на данные
		echo -n "Введте имя или фамилию: "
		read name
		# Выход из пункта меню
		if [[ "$name" == "qq" ]];then
			echo -e $GRN"Выходим из $E_COL[search]"
			continue
		fi

		if [[ -n "$name" ]];then
		echo "Результат поиска: "
		# Выводим только номер телефона
			var=$(awk -F ":" "/$name/"'{print $1,"-",$2}' $file)
			if [ -z "$var" ];then
				echo -e $YEL"Контакт не найден - $RED"$name $E_COL
			else
				echo -e $GRN $(awk -F ":" "/$name/"'{print $1,"-",$2}' $file) $E_COL
			fi	
		else
			echo -e "$REDВведите имя или телефон$E_COL"
		fi
		;;
	"delete")
		# Вводим данные
		echo  "Ввидите имя или фамилию или телефон"
		echo -n "что удаляем? "
		read name
		# Выход из пункта меню
		if [[ "$name" == "qq" ]];then
			echo -e $GRN"Выходим из $E_COL[delete]"
			continue
		fi
		# Проверяем переменную на данные
		if [[ -n $name ]];then
			echo "Удаляем:"
			# Выводим и удаляем строку(-ки) 
			sed -n "/$name/p" $file
			sed -i "/$name/d" $file
		else
			echo -e "$REDВведите имя или телефон$E_COL"
		fi
		;;
		# выводим помощь при пустой строке или с аргументом help
	"help")
		echo "Пример использования:"
		echo -e $YEL"	./phone-book.sh [команда]"$E_COL
		echo "Доступные Команды:"
		echo -e $YEL"	new 	 	Добавление записи в телефонную кнгу"$E_COL
		echo -e $YEL"	search 		Поиск записей в телефонной книге"$E_COL
		echo -e $YEL"	list 		просмотр всех записей"$E_COL
		echo -e $YEL"	delete		удаление записи"$E_COL
		echo -e $YEL"	qq		Выход из программы или пункта меню"$E_COL
		;;
	"qq")
		echo -e $GRN"=== Выходим из программы! ==="$E_COL
		echo "Список в файле"
		ls -l $file
		menu="qq"
		exit 0
		;;
	*)
		echo -e $YEL"	введите help чтобы получить справку по командам"$E_COL
		
 esac
done
# < Конец цикла >
exit 0
