﻿
#Область ПрограммныйИнтерфейс

Процедура УстановитьЗначениеКонстанты(Знач Имя, Знач Значение) Экспорт
    УстановитьПривилегированныйРежим(Истина);
    Константы[Имя].Установить(Значение);
    УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

// Формирует список команд раздела Сервис в окне настроек
//
// Параметры:
//  ТаблицаКоманд	 - ТаблицаЗначений - Таблица команд в форме.
//   * Команда       - Строка - Идентификатор команды;
//   * Представление - Строка - Представление команды;
//   * Пояснение     - Строка - Краткая подсказка-пояснение для пользователя.
//
Процедура ЗаполнитьСписокКомандВРазделеСервис(ТаблицаКоманд) Экспорт

	ТаблицаКоманд.Очистить();

	Стр = ТаблицаКоманд.Добавить();
	Стр.Команда       = "УдалитьВсе";
	Стр.Представление = НСтр("ru = 'Удалить все данные'; en = 'Remove all data'");
	Стр.Пояснение     = НСтр("ru = 'Будет выполнено удаление всех загруженных данных. Клиент будет отключен от Центральной базы. ';
							|en = 'All data will be removed. The client will be disconnected from the server.'");

	Стр = ТаблицаКоманд.Добавить();
	Стр.Команда       = "ОткрытьПротокол";
	Стр.Представление = НСтр("ru = 'Открыть протокол'; en = 'Open the event log'");
	Стр.Пояснение     = НСтр("ru = 'Будет открыт протокол событий работы мобильного клиента.'; 
							|en = 'Events protocol of the mobile client will be open.'");

КонецПроцедуры

// Добавляет отбор в коллекцию отборов компоновщика или группы отборов.
//
// Параметры:
// ЭлементСтруктуры- элемент структуры КД;
// Поле			- имя поля, по которому добавляется отбор;
// Значение		- значение отбора КД;
// ВидСравнения	- вид сравнений КД (по умолчанию: неопределено);
// Использование	- признак использования отбора (по умолчанию: истина);
// ВПользовательскиеНастройки - признак добавления в пользовательсие настройки КД (по умолчанию: ложь).
//
// Возвращаемое значение:
// ЭлементОтбора (ЭлементОтбораКомпоновкиДанных).
//
Функция ДобавитьОтбор(ЭлементСтруктуры, Знач Поле, Значение, ВидСравнения = Неопределено,
	Использование = Истина, ВПользовательскиеНастройки = Ложь) Экспорт
	
	Если ТипЗнч(Поле) = Тип("Строка") Тогда
		Поле = Новый ПолеКомпоновкиДанных(Поле);
	КонецЕсли;
	Если ТипЗнч(ЭлементСтруктуры) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Отбор = ЭлементСтруктуры.Настройки.Отбор;
		Если ВПользовательскиеНастройки Тогда
			Для Каждого ЭлементНастройки Из ЭлементСтруктуры.ПользовательскиеНастройки.Элементы Цикл
				Если ЭлементНастройки.ИдентификаторПользовательскойНастройки 
					= ЭлементСтруктуры.Настройки.Отбор.ИдентификаторПользовательскойНастройки Тогда
					Отбор = ЭлементНастройки;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("НастройкиКомпоновкиДанных") Тогда
		Отбор = ЭлементСтруктуры.Отбор;
	Иначе
		Отбор = ЭлементСтруктуры;
	КонецЕсли;
	Если ВидСравнения = Неопределено Тогда
		ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли;
	ЭлементОтбора = Неопределено;
	ЭлементОтбора = НайтиЭлементОтбора(Отбор, Поле);
	Если ЭлементОтбора = Неопределено Тогда
		ЭлементОтбора = Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	КонецЕсли;
	ЭлементОтбора.Использование	 = Использование;
	ЭлементОтбора.ЛевоеЗначение	 = Поле;
	ЭлементОтбора.ВидСравнения	 = ВидСравнения;
	ЭлементОтбора.ПравоеЗначение = Значение;
	Возврат ЭлементОтбора;
	
КонецФункции // ДобавитьОтбор()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Находит элемент отбора.
//
Функция НайтиЭлементОтбора(Отбор, Поле)
	
	ЭлементОтбора = Неопределено;
	Для каждого Элемент Из Отбор.Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			ЭлементОтбора = НайтиЭлементОтбора(Элемент, Поле);
			Продолжить;
		КонецЕсли;
		Если Элемент.ЛевоеЗначение = Поле Тогда
			ЭлементОтбора = Элемент;
		КонецЕсли;
	КонецЦикла;
	Возврат ЭлементОтбора;
	
КонецФункции

#КонецОбласти