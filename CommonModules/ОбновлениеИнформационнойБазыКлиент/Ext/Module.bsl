﻿
#Область ПрограммныйИнтерфейс

// Выполняет обновление информационной базы после обновления конфигурации, если была поднята версия.
//
// Параметры:
//  СтраницыЧтоНового		 - Массив - Список имен страниц для отображения в форме "что нового";
//  ЕстьОшибкиПриОбновлении	 - Булево - Признак наличия ошибок при выполнении обновления.
//
Процедура ВыполнитьОбновлениеИнформационнойБазы(ЕстьОшибкиПриОбновлении) Экспорт

	// Открываем форму с пояснением о том, что идет процесс обновления.
	ОткрытьФорму("ОбщаяФорма.ОбновлениеИБ",,,,,,, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);

	// Выполняем обновление данных.
	ОбновлениеИнформационнойБазыВызовСервера.ВыполнитьОбновлениеИБ(ЕстьОшибкиПриОбновлении);

	// Оповещаем все заинтересованные объекты, что обновление завершено.
	Оповестить("ОбновлениеЗавершено");

КонецПроцедуры

// Обработчик завершения показа формы "Что нового".
//
// Параметры:
//  Результат				 - Произвольный - Результат закрытия формы;
//  ДополнительныеПараметры	 - Структура, Неопределено - Дополнительные параметры.
//
Процедура ОбработатьПоказФормыЧтоНового(Результат, ДополнительныеПараметры) Экспорт

	ОбработчикЗавершения = Новый ОписаниеОповещения("ОбработатьЗавершениеПоказаФормыЧтоНового",
		 ОбновлениеИнформационнойБазыКлиент);
	
	ТекстЗаголовка      = НСтр("ru = 'Обновление данных'; en = 'Updating'");
	ТекстПредупреждения = НСтр("ru = 'Данные успешно обновлены. Можно продолжить работу.'; en = 'Data are successfully updated.'");

	// Покажем сообщение о том, что все обновлено.
	ПоказатьПредупреждение(ОбработчикЗавершения, ТекстПредупреждения, , ТекстЗаголовка);

КонецПроцедуры

// Обработчик закрытия предупреждения о выполнении обновления ИБ.
//
// Параметры:
//  Результат - Произвольный - Результат закрытия окна предупреждения.
//
Процедура ОбработатьЗавершениеПоказаФормыЧтоНового(Результат) Экспорт

	Оповестить("ВыполненЗапускСистемы");

КонецПроцедуры

#КонецОбласти
///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Открывает форму отложенных обработчиков.
//
Процедура ПоказатьОтложенныеОбработчики() Экспорт
	ОткрытьФорму("Обработка.РезультатыОбновленияПрограммы.Форма.ОтложенныеОбработчики");
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы.
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если Не ПараметрыКлиента.РазделениеВключено Или Не ПараметрыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		ОбновлениеИнформационнойБазыКлиентПереопределяемый.ПриОпределенииВозможностиОбновления(ПараметрыКлиента.ВерсияДанныхОсновнойКонфигурации);
	КонецЕсли;
	
	Если ПараметрыКлиента.Свойство("ИнформационнаяБазаЗаблокированаДляОбновления") Тогда
		Кнопки = Новый СписокЗначений();
		Кнопки.Добавить("Перезапустить", НСтр("ru = 'Перезапустить'"));
		Кнопки.Добавить("Завершить",     НСтр("ru = 'Завершить работу'"));
		
		ПараметрыВопроса = Новый Структура;
		ПараметрыВопроса.Вставить("КнопкаПоУмолчанию", "Перезапустить");
		ПараметрыВопроса.Вставить("КнопкаТаймаута",    "Перезапустить");
		ПараметрыВопроса.Вставить("Таймаут",           60);
		
		ОписаниеПредупреждения = Новый Структура;
		ОписаниеПредупреждения.Вставить("Кнопки",           Кнопки);
		ОписаниеПредупреждения.Вставить("ПараметрыВопроса", ПараметрыВопроса);
		ОписаниеПредупреждения.Вставить("ТекстПредупреждения",
			ПараметрыКлиента.ИнформационнаяБазаЗаблокированаДляОбновления);
		
		Параметры.Отказ = Истина;
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения(
			"ПоказатьПредупреждениеИПродолжить",
			СтандартныеПодсистемыКлиент,
			ОписаниеПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы.
Процедура ПередНачаломРаботыСистемы2(Параметры) Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыКлиента.Свойство("НеобходимоВыполнитьОбработчикиОтложенногоОбновления") Тогда
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения(
			"ИнтерактивнаяОбработкаПроверкиСтатусаОтложенногоОбновления",
			ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы.
Процедура ПередНачаломРаботыСистемы3(Параметры) Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыКлиента.Свойство("НеобходимоОбновлениеПараметровРаботыПрограммы") Тогда
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения(
			"ЗагрузитьОбновитьПараметрыРаботыПрограммы", ОбновлениеИнформационнойБазыКлиент, Параметры);
	КонецЕсли;
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы.
Процедура ПередНачаломРаботыСистемы4(Параметры) Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если НЕ ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		ЗакрытьФормуИндикацииХодаОбновленияЕслиОткрыта(Параметры);
		Возврат;
	КонецЕсли;
	
	Если ПараметрыРаботыКлиента.Свойство("НеобходимоОбновлениеИнформационнойБазы") Тогда
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения(
			"НачатьОбновлениеИнформационнойБазы", ЭтотОбъект);
	Иначе
		Если ПараметрыРаботыКлиента.Свойство("ЗагрузитьСообщениеОбменаДанными") Тогда
			Перезапустить = Ложь;
			ОбновлениеИнформационнойБазыСлужебныйВызовСервера.ВыполнитьОбновлениеИнформационнойБазы(Истина, Перезапустить);
			Если Перезапустить Тогда
				Параметры.Отказ = Истина;
				Параметры.Перезапустить = Истина;
			КонецЕсли;
		КонецЕсли;
		ЗакрытьФормуИндикацииХодаОбновленияЕслиОткрыта(Параметры);
	КонецЕсли;
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы.
Процедура ПередНачаломРаботыСистемы5(Параметры) Экспорт
	
	Если ОбщегоНазначенияКлиент.ИнформационнаяБазаФайловая()
	   И СтрНайти(ПараметрЗапуска, "ВыполнитьОбновлениеИЗавершитьРаботу") > 0 Тогда
		
		ПрекратитьРаботуСистемы();
		
	КонецЕсли;
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПриНачалеРаботыСистемы.
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если НЕ ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьОписаниеИзмененийСистемы();
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПослеНачалаРаботыСистемы.
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыКлиента.Свойство("ПоказатьСообщениеОбОшибочныхОбработчиках")
		Или ПараметрыКлиента.Свойство("ПоказатьОповещениеОНевыполненныхОбработчиках") Тогда
		ПодключитьОбработчикОжидания("ПроверитьСтатусОтложенногоОбновления", 2, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Для процедуры ОбновитьИнформационнуюБазу.
Процедура ЗакрытьФормуИндикацииХодаОбновленияЕслиОткрыта(Параметры)
	
	Если Параметры.Свойство("ФормаИндикацияХодаОбновленияИБ") Тогда
		Если Параметры.ФормаИндикацияХодаОбновленияИБ.Открыта() Тогда
			Параметры.ФормаИндикацияХодаОбновленияИБ.НачатьЗакрытие();
		КонецЕсли;
		Параметры.Удалить("ФормаИндикацияХодаОбновленияИБ");
	КонецЕсли;
	
КонецПроцедуры

// Только для внутреннего использования. Продолжение процедуры ОбновитьИнформационнуюБазу.
Процедура НачатьОбновлениеИнформационнойБазы(Параметры, ОбработкаПродолжения) Экспорт
	
	Если Параметры.Свойство("ФормаИндикацияХодаОбновленияИБ") Тогда
		Форма = Параметры.ФормаИндикацияХодаОбновленияИБ;
	Иначе
		ИмяФормы = "Обработка.РезультатыОбновленияПрограммы.Форма.ИндикацияХодаОбновленияИБ";
		Форма = ОткрытьФорму(ИмяФормы,,,,,, Новый ОписаниеОповещения(
			"ПослеЗакрытияФормыИндикацияХодаОбновленияИБ", ЭтотОбъект, Параметры));
		Параметры.Вставить("ФормаИндикацияХодаОбновленияИБ", Форма);
	КонецЕсли;
	
	Форма.ОбновитьИнформационнуюБазу();
	
КонецПроцедуры

// Только для внутреннего использования. Продолжение процедуры ПередНачаломРаботыПрограммы.
Процедура ЗагрузитьОбновитьПараметрыРаботыПрограммы(Параметры, Контекст) Экспорт
	
	ИмяФормы = "Обработка.РезультатыОбновленияПрограммы.Форма.ИндикацияХодаОбновленияИБ";
	Форма = ОткрытьФорму(ИмяФормы,,,,,, Новый ОписаниеОповещения(
		"ПослеЗакрытияФормыИндикацияХодаОбновленияИБ", ЭтотОбъект, Параметры));
	Параметры.Вставить("ФормаИндикацияХодаОбновленияИБ", Форма);
	Форма.ЗагрузитьОбновитьПараметрыРаботыПрограммы(Параметры);
	
КонецПроцедуры

// Только для внутреннего использования. Продолжение процедуры ОбновитьИнформационнуюБазу.
Процедура ПослеЗакрытияФормыИндикацияХодаОбновленияИБ(Результат, Параметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Результат = Новый Структура("Отказ, Перезапустить", Истина, Ложь);
	КонецЕсли;
	
	Если Результат.Отказ Тогда
		Параметры.Отказ = Истина;
		Если Результат.Перезапустить Тогда
			Параметры.Перезапустить = Истина;
		КонецЕсли;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
	
КонецПроцедуры

// Только для внутреннего использования. Продолжение процедуры ПроверитьСтатусОбработчиковОтложенногоОбновления.
Процедура ИнтерактивнаяОбработкаПроверкиСтатусаОтложенногоОбновления(Параметры, Контекст) Экспорт
	
	ОткрытьФорму("Обработка.РезультатыОбновленияПрограммы.Форма.ОтложенноеОбновлениеНеЗавершено", , , , , ,
		Новый ОписаниеОповещения("ПослеЗакрытияФормыПроверкиСтатусаОтложенногоОбновления",
			ЭтотОбъект, Параметры));
	
КонецПроцедуры

// Только для внутреннего использования. Продолжение процедуры ПроверитьСтатусОбработчиковОтложенногоОбновления.
Процедура ПослеЗакрытияФормыПроверкиСтатусаОтложенногоОбновления(Результат, Параметры) Экспорт
	
	Если Результат <> Истина Тогда
		Параметры.Отказ = Истина;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
	
КонецПроцедуры

// Если есть непоказанные описания изменения и у пользователя не отключен
// показ - открыть форму ОписаниеИзмененийПрограммы.
//
Процедура ПоказатьОписаниеИзмененийСистемы()
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыРаботыКлиента.ПоказатьОписаниеИзмененийСистемы Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ПоказыватьТолькоИзменения", Истина);
		
		ОткрытьФорму("ОбщаяФорма.ОписаниеИзмененийПрограммы", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

// Выводит оповещение пользователю о том, что отложенная обработка данных
// не выполнена.
//
Процедура ОповеститьОтложенныеОбработчикиНеВыполнены() Экспорт
	
	Если ПользователиКлиент.ЭтоСеансВнешнегоПользователя() Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Работа в программе временно ограничена'"),
		НавигационнаяСсылкаОбработки(),
		НСтр("ru = 'Не завершен переход на новую версию'"),
		БиблиотекаКартинок.Предупреждение32);
	
КонецПроцедуры

// Возвращает навигационную ссылку обработки ОбновлениеИнформационнойБазы.
//
Функция НавигационнаяСсылкаОбработки()
	Возврат "e1cib/app/Обработка.РезультатыОбновленияПрограммы";
КонецФункции

#КонецОбласти



