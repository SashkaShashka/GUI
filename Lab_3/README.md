# DesignGUI
Лабораторная работа №3: "Основы графического интерфейса на PyQt"

# Задание на лабораторную работу
* Реализовать приложение на PyQt с использованием представления таблиц и работы с SQL.
    - В меню две вкладки: Set connection (установить соединение с бд), Close connection (очистить все, закрыть соединение с бд).
    - По умолчанию можно сделать в QTabWidget вкладки пустыми, либо создавать их по выполнению запросов при нажатии на функциональные клавиши.
    - Сразу после успешного коннета в Tab1 устанавливается таблица, соответствующая запросу «SELECT * FROM sqlite_master».
    - Кнопка bt1 делает выборочный запрос, например, «SELECT name FROM sqlite_master», результат выводится в Tab2.
    - При выборе колонки из выпадающего списка QComboBox результат соотвествующего запроса отправляется в Tab3.
    - Кнопки bt2 и bt3 выполняют запрос по выводу таблицы в Tab4 и Tab5
* Иллюстрация пример<br><br>
![фото](https://github.com/Black-Viking-63/DesignGUI/blob/main/LabWork_3/images/technical_task.png)

# Инструменты, используемые при разработке приложения
* Разработка графического приложения:
    - Python3
    - PyQt5
    - QtDesigner
* Разработка базы данных:
    - Microsoft SQL Server 2022
    - Microsoft SQL Server Managment Studio 19

# Структура решения лабораторной работы
Решение лабораторной работы состоит из двух частей:
* работа с базой данный
* работа с графическим интерфейсом

# Разработка базы данных
Для разработки базы данных использовался язык T-SQL, из MSSQL. Было разработано 2 скрипта:
* [`create table.sql`](https://github.com/SashkaShashka/GUI/blob/main/Lab_3/create%20table.sql) - производит создание таблицы, с ранее созданной базе данных.

``` sql
CREATE TABLE gui_table
(
    --пассажир
    id INT NOT NULL PRIMARY KEY, 
    фио [NVARCHAR](200) NOT NULL, 
    дата_рождения [date] NOT NULL, 
    паспорт [NVARCHAR](50) NOT NULL, 
    -- билет
    id_билета [NVARCHAR](50) NOT NULL UNIQUE,
    пункт_отправления [NVARCHAR](50) NOT NULL, 
    пункт_назначения [NVARCHAR](50) NOT NULL, 
    дата_отправления [date] NOT NULL, 
    количество_баллов [NVARCHAR](50) NOT NULL,
    вес_багажа [NVARCHAR](50) NOT NULL,
    -- параметры полета
    время_полета [NVARCHAR](50) NOT NULL, 
    самолет [NVARCHAR](50) NOT NULL
);
```

* [`bulk isert.sql`](https://github.com/SashkaShashka/GUI/blob/main/Lab_3/bulk%20isert.sql) - производит массовую вставку данных, которые были заранее подготовлены, дабы ускорить загрузку информации в базу даных.
``` sql
bulk insert gui_base.dbo.gui_table
from 'C:\Users\sasha\Desktop\Labs\DesignGUI-main\LabWork_3\output.txt'
    with
    (
	datafiletype = 'widechar',
    fieldterminator = '|',
    rowterminator = '\n'
    );
```

В результате были созданы база данных и таблица:
</br>
Создание таблицы</br>
![image](https://github.com/SashkaShashka/GUI/assets/62326372/9b303506-10ad-4deb-991e-d0a41568b82b)</br>
Заполнение базы данных</br>
![image](https://github.com/SashkaShashka/GUI/assets/62326372/ad980d1f-65dd-443f-95b3-f178ba94ab61)</br>
Результат создания БД</br>
![image](https://github.com/SashkaShashka/GUI/assets/62326372/ed5c21c3-9a3f-403f-9ec0-e01be40a101c)</br>
Результат заполнения</br>
![image](https://github.com/SashkaShashka/GUI/assets/62326372/83098d64-2bf7-4b64-ba61-8eb7706b363f)</br>
# Разработка графического интерфейса

При разработке графического интерфейса было реализовано несколько скриптов, рассмотрим каждый из них по подробнее.
## Генерация случайных данных
[`generate_data.py`](https://github.com/SashkaShashka/GUI/blob/main/Lab_3/generate_data.py)<br>
Данный скрипт, содержит код, при выполнении, которого будет производиться автоматическая генерация данных, которые будут использоваться в базе данных. Скрипт содержит в себе:
* Клас генерируемых данных с конструктором и методам сохранения объекта класса в строковом представлении.
``` python
class Flight():
    
    # конструктор
    def __init__(self, id, name, date_birth, number, id_ticket, arrival, destionation, date_arrival, count_bonus, weight, duration_fly, plane):
        self.id = id
        self.name = name
        self.date_birth = date_birth
        self.number = number
        self.id_ticket = id_ticket
        self.arrival = arrival
        self.destionation = destionation
        self.date_arrival = date_arrival
        self.count_bonus = count_bonus
        self.weight = weight
        self.duration_fly=duration_fly
        self.plane = plane
        
    # приведение к строковому виду
    def result(self):
        return str(self.id) + '|' + str(self.name) + '|' + str(self.date_birth) +'|'+ str(self.number)+ '|' + str(self.id_ticket) + '|' + str(self.arrival) + '|' + str(self.destionation) + '|' + str(self.date_arrival) + '|' + str(self.count_bonus) + '|' + str(self.weight) + '|' + str(self.duration_fly) +'|'+str(self.plane) 

```
* Массивы данных, для генерации широкого набора данных, которые будут использованы в базе данных.
```python
# массив пунктов прибытия
array_destionation = [
        "Абакан", "Анапа", "Астрахань", "Белгород", "Братск", "Варандей", "Владикавказ", "Воронеж", "Екатеринбург", "Иркутск",
        "Калининград", "Кемерово", "Красноярск", "Курск", "Магадан", "Махачкала", "Москва", "Мурманск", "Нижневартовск", "Нижний Новгород",
        "Новосибирск", "Оренбург", "Остафьево", "Петрозаводск", "Псков", "Сабетта", "Санкт-Петербург", "Саратов", "Сочи", 
        "Сургут", "Томск", "Улан-Удэ", "Уфа", "Ханты-Мансийск", "Челябинск", "Чита", "Южно-Сахалинск", "Ярославль"]
# массив компаний самолетов
array_companies = [
            "Airbus", "ATR", "Saab AB", "Антонов", "ОАК",
            "Сухой", "Иркут", "Туполев", "Ильюшин", "Boeing",
            "Douglas", "Bombardier", "Embraer"
        ]
```
* Функцию генерации случайной даты
```python
def get_random_date(start, end):
    delta = end - start
    return start + timedelta(random.randint(0, delta.days))
```
* Код, обеспечивающий генерацию набора данных и его сохранение в выходной файл.

## Вспомогательный скрипт загрузки таблиц
[`query.py`](https://github.com/SashkaShashka/GUI/blob/main/Lab_3/query.py) - в данный скрипт выненсены некоторые функции, для улучшения читаемости основного файла с описанием графического интерфейса.
* `load_name_tables` - функция, необходимая для получения имен столбцов таблицы из базы данных.
* `ld_labels` - функция, необходимая для установки имен столбцов в `QTableWidget`
* `ld_data_main_window` - функция, необходимая для загрузки данных в основное окно 
* `ld_data_add_window` - функция, необходимая для загрузки данных в дополнительное окно
* `show_message` - функция, обеспечивающая вызов сообщения "подсказки"

## Скрипты, содержащие реализцаию графического приложения
* [`ui.ui`](https://github.com/SashkaShashka/GUI/blob/main/Lab_3/ui.ui) - файл генерируемый программой `QtDesigner`
* [`ui.py`](https://github.com/SashkaShashka/GUI/blob/main/Lab_3/ui.py) - скрипт скомпилированный, на основе файла из программы `QtDesigner`, и описывающий поведение и логику работы элементов графического приложения.

## Основной скрипт программы
[`main.ipynb`](https://github.com/SashkaShashka/GUI/blob/main/Lab_3/main.ipynb) - основной скрипт, производящий запуск всего приложения

# Результаты лабораторной работы

Ниже приведены скриншоты реализованного приложения.

## Внешний вид программы
### Основные компоненты программы
| Основное окно программы|Дополнительное окно программы|
|:---:|:---:|
|![image](https://github.com/SashkaShashka/GUI/assets/62326372/9bb14883-3bab-406b-a3b8-5b6119a7e043)|![image](https://github.com/SashkaShashka/GUI/assets/62326372/58136019-fcf1-430c-891d-124d6343659a)|
### Дополнительные компоненты программы
Первое меню из бара|Второе меню из бара|Краткое окно помощи|
|:---:|:---:|:---:|
|![image](https://github.com/SashkaShashka/GUI/assets/62326372/f0c79780-3d5c-4f78-a175-0d233bb37d72)|![image](https://github.com/SashkaShashka/GUI/assets/62326372/c310a27a-1606-4244-b6db-268cf50cbe05)|![image](https://github.com/SashkaShashka/GUI/assets/62326372/76a0d211-d6cc-47a5-8c72-390dafa2eba2)|


## Работа на главном окне
Результат открытия соединения|Закрытие соединения|
|:---:|:---:|
|![image](https://github.com/SashkaShashka/GUI/assets/62326372/b786514d-d06f-4dbc-a00e-13646bd5a846)|![image](https://github.com/SashkaShashka/GUI/assets/62326372/1ae43655-f996-444d-99c5-52318df0bac2)|


## Работа с дополнительным окном
|Работа главного окна<br>при закрытом соединении|Работа главного окна<br>при открытом соединении|Выполнение запроса<br>при открытом соединении|Выполнение запроса<br>при закрытом соединении|
|:---:|:---:|:---:|:---:|
|![image](https://github.com/SashkaShashka/GUI/assets/62326372/6a38def7-3906-47b9-b07f-d2b457a29447)|![image](https://github.com/SashkaShashka/GUI/assets/62326372/edd15c98-ea4c-47af-bea7-4d34039d1de4)|![image](https://github.com/SashkaShashka/GUI/assets/62326372/22d18a0b-e4a3-4df2-943e-ca3130c9ce5d)|![image](https://github.com/SashkaShashka/GUI/assets/62326372/245ccb99-669c-4c2d-973a-8a478501dcfc)
|

