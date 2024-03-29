﻿
#Область ПрограммныйИнтерфейс

// Определяет необходимость запуска обработчиков обновления.
// 
// Возвращаемое значение:
//  Булево - Признак того, что необходимо выполнить обновление ИБ.
//
Функция НеобходимоВыполнитьОбновление() Экспорт

	ВерсияИБ = Метаданные.Версия;

	Возврат НеобходимоЗапуститьОбработчик(ВерсияИБ);

КонецФункции

// Выполняет обновление ИБ.
//
// Параметры:
//  СтраницыЧтоНового		 - Массив - Массив имен страниц для показа в форме "Что нового";
//  ЕстьОшибкиПриОбновлении	 - Булево - Признак того, что обновление не выполнено.
//                                      В этом случае будет показана форма со списком ошибок.
//
Процедура ВыполнитьОбновлениеИБ(ЕстьОшибкиПриОбновлении) Экспорт

	Попытка
		ВыполнитьОбновление();
	Исключение

		Инфо = ИнформацияОбОшибке();

		ОбщееОписаниеОшибки = 
			НСтр("ru = 'При обновлении данных приложения на новую версию произошла ошибка.
				|<b>Для дальнейшей корректной работы необходима переустановка приложения и повторное подключение к серверу.</b>
				|'; en = 'An error occurred while updating program data.
				|<b> Perform reinstallation programm and reconnect to the server. </b>'");

		ТекстОшибки = 
			РаботаСоСтрокамиКлиентСервер.СформироватьПредставлениеОшибки(
				ОбщееОписаниеОшибки, ПодробноеПредставлениеОшибки(Инфо));

		МоментВремени = РегистрыСведений.ПротоколСобытий.ДобавитьОшибку(ТекстОшибки);

		РегистрыСведений.ПротоколСобытий.УстановитьНеобходимостьОтображенияПослеСинхронизации(МоментВремени, Истина);

		ЕстьОшибкиПриОбновлении = Истина;

	КонецПопытки;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Выполняет запуск необходимых обработчиков обновления, исходя из того, 
// на какую версию ранее уже производилось обновление.
//
Процедура ВыполнитьОбновление()

	Если Метаданные.Версия = Константы.ВерсияПротоколаМобильногоКлиента.Получить() Тогда
		Возврат;
	КонецЕсли;

	ВерсияПриложения = "1.0.1.1";
	Если НеобходимоЗапуститьОбработчик(ВерсияПриложения) Тогда
		ПерейтиНаВерсию_1_0_1_1(ВерсияПриложения);
	КонецЕсли;

	Константы.ВерсияПротоколаМобильногоКлиента.Установить(Метаданные.Версия);

КонецПроцедуры

// Проверяет необходимость запуска обработки обновления для указанной версии.
//
// Параметры:
//  ВерсияСравнения - Строка - Номер версии для которой нужно выполнить проверку.
// 
// Возвращаемое значение:
//  Истина - Если нужно запустить обработку обновления, Ложь в противном случае.
//
Функция НеобходимоЗапуститьОбработчик(ВерсияСравнения)

	ВерсияШоурум        = Константы.ВерсияПротоколаМобильногоКлиента.Получить();
	РазрядыВерсииШоурум = СтрРазделить(ВерсияШоурум, ".");
	РазрядыВерсииСравнения        = СтрРазделить(ВерсияСравнения, ".");

	Если ВерсияШоурум = ВерсияСравнения Тогда
		Возврат Ложь;
	КонецЕсли;

	Для Счетчик = 1 По 4 Цикл
		
		ЛевоеЗначение  = Число(РазрядыВерсииШоурум[Счетчик - 1]);
		ПравоеЗначение = Число(РазрядыВерсииСравнения[Счетчик - 1]);
		
		Если ЛевоеЗначение = ПравоеЗначение Тогда
			Продолжить;

		ИначеЕсли ЛевоеЗначение < ПравоеЗначение Тогда
			Возврат Истина;

		Иначе
			Возврат Ложь;
		КонецЕсли;

	КонецЦикла;

	Возврат Ложь;

КонецФункции

// Записывает информацию о успешном обновлении на новую версию.
//
// Параметры:
//  Версия - Строка - новая версия программы.
//
Процедура ЗаписатьИнформациюОУспешномОбновленииНаНовуюВерсию(Версия)

	ТекстИнформации = СтрШаблон(
		НСтр("ru = 'Выполнен переход на версию %1'; en = 'Successfully updated to the version %1'"),
		Версия);

	РаботаСПротоколомСобытийВызовСервера.ДобавитьИнформацию(ТекстИнформации);
	//СборСтатистикиКлиентСервер.СобратьДанныеСтатистикиПриОбновлении();

КонецПроцедуры

#Область ОбработчикиОбновления

Процедура ПерейтиНаВерсию_1_0_1_1(ВерсияПриложения)

	НачатьТранзакцию();

	Попытка

		ОбменВызовСервера.СброситьСостояниеЗагрузкиЧастейСообщений();
		
		РегистрыСведений.ПолученныеДанныеОбмена.ОчиститьРегистр();

		ЗаписатьИнформациюОУспешномОбновленииНаНовуюВерсию(ВерсияПриложения);

		ЗафиксироватьТранзакцию();

	Исключение

		Инфо = ИнформацияОбОшибке();

		ОтменитьТранзакцию();
		
		РаботаСПротоколомСобытийВызовСервера.ДобавитьОшибку(НСтр("ru = 'При обновлении версии программы произошла ошибка (2.1.9.3).'; en = 'Update installation failed (2.1.9.3).'"));
		РаботаСПротоколомСобытийВызовСервера.ДобавитьОшибку(Инфо);
		
		ВызватьИсключение;

	КонецПопытки;

КонецПроцедуры

#КонецОбласти

#КонецОбласти
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Для интеграции с подсистемой "Обновление конфигурации".
// См. макет МакетФайлаОбновленияКонфигурации обработки УстановкаОбновлений.
//
Функция ВыполнитьОбновлениеИнформационнойБазы(ВыполнятьОтложенныеОбработчики = Ложь) Экспорт
	
	ДатаНачала = ТекущаяДатаСеанса();
	Результат = ОбновлениеИнформационнойБазы.ВыполнитьОбновлениеИнформационнойБазы(ВыполнятьОтложенныеОбработчики);
	ДатаОкончания = ТекущаяДатаСеанса();
	ОбновлениеИнформационнойБазыСлужебный.ЗаписатьВремяВыполненияОбновления(ДатаНачала, ДатаОкончания);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
